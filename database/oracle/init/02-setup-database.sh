#!/bin/bash

set -euo pipefail

: "${ORACLE_USER:?Missing ORACLE_USER}"
: "${ORACLE_PASSWORD:?Missing ORACLE_PASSWORD}"

DB_SERVICE="${ORACLE_PDB:-FREEPDB1}"
APP_CONNECT="${ORACLE_USER}/${ORACLE_PASSWORD}@${DB_SERVICE}"
BASE_SCHEMA_SQL="/opt/oracle/scripts/custom/ogr.sql"
ORDS_SCHEMA_SQL="/opt/oracle/scripts/custom/ords.sql"
ORDS_SETUP_RETRIES="${ORDS_SETUP_RETRIES:-60}"
ORDS_SETUP_DELAY="${ORDS_SETUP_DELAY:-5}"

sqlplus_scalar() {
  local sql_text="$1"

  sqlplus -L -S "$APP_CONNECT" <<EOF | tr -d '[:space:]'
WHENEVER OSERROR EXIT FAILURE
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET HEADING OFF FEEDBACK OFF PAGESIZE 0 VERIFY OFF ECHO OFF
${sql_text}
EXIT
EOF
}

run_sql_file() {
  local file_path="$1"

  sqlplus -L -S "$APP_CONNECT" <<EOF
WHENEVER OSERROR EXIT FAILURE
SET ECHO OFF
SET FEEDBACK OFF
SET PAGESIZE 0
SET LINESIZE 1000
WHENEVER SQLERROR EXIT SQL.SQLCODE
@${file_path}
EXIT
EOF
}

expand_sql_source() {
  local sql_source="$1"
  local sql_dir
  local line
  local include_path
  local resolved_path

  if [[ ! -f "$sql_source" ]]; then
    echo "SQL source not found: $sql_source" >&2
    return 1
  fi

  sql_dir="$(cd "$(dirname "$sql_source")" && pwd)"

  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%$'\r'}"

    if [[ "$line" =~ ^[[:space:]]*@{1,2}([^[:space:]]+) ]]; then
      include_path="${BASH_REMATCH[1]}"

      if [[ "$include_path" != /* ]]; then
        resolved_path="$sql_dir/$include_path"
      else
        resolved_path="$include_path"
      fi

      expand_sql_source "$resolved_path" || return 1
      continue
    fi

    printf '%s\n' "$line"
  done < "$sql_source"
}

materialize_sql_source() {
  local sql_source="$1"
  local expanded_sql_file

  expanded_sql_file="$(mktemp /tmp/ords-expanded.XXXXXX.sql)"

  if ! expand_sql_source "$sql_source" >"$expanded_sql_file"; then
    rm -f "$expanded_sql_file"
    return 1
  fi

  printf '%s\n' "$expanded_sql_file"
}

echo "Setting up Student Information System database..."

base_schema_count="$(sqlplus_scalar "SELECT COUNT(*) FROM user_tables WHERE table_name = 'USERS';")"

if [[ "$base_schema_count" == "0" ]]; then
  echo "Base schema not found. Running application schema setup..."
  run_sql_file "$BASE_SCHEMA_SQL"
else
  echo "Base schema already present. Skipping application schema setup."
fi

for ((attempt = 1; attempt <= ORDS_SETUP_RETRIES; attempt += 1)); do
  expanded_ords_schema_sql=""
  ords_synonym_count="$(sqlplus_scalar "SELECT COUNT(*) FROM all_synonyms WHERE synonym_name = 'ORDS';")"

  if [[ "$ords_synonym_count" == "1" ]]; then
    echo "ORDS package is available. Applying ORDS schema configuration..."
    expanded_ords_schema_sql="$(materialize_sql_source "$ORDS_SCHEMA_SQL")"
    trap 'rm -f "$expanded_ords_schema_sql"' EXIT
    run_sql_file "$expanded_ords_schema_sql"
    rm -f "$expanded_ords_schema_sql"
    trap - EXIT
    echo "Student Information System database setup completed successfully."
    exit 0
  fi

  echo "ORDS package is not available yet (${attempt}/${ORDS_SETUP_RETRIES}). Retrying in ${ORDS_SETUP_DELAY} seconds..."
  sleep "$ORDS_SETUP_DELAY"
done

echo "ORDS package did not become available in time. Database schema is created, but ORDS routes were not configured." >&2
exit 1
