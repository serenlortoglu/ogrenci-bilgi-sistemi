#!/usr/bin/env bash
set -euo pipefail

: "${ORACLE_PDB:?Missing ORACLE_PDB}"
: "${ORACLE_USER:?Missing ORACLE_USER}"
: "${ORACLE_PASSWORD:?Missing ORACLE_PASSWORD}"

echo "Ensuring user '${ORACLE_USER}' exists in PDB '${ORACLE_PDB}'..."

sqlplus -s / as sysdba <<SQL
set serveroutput on size unlimited
whenever sqlerror exit failure

begin
  dbms_output.put_line('Switching to PDB ${ORACLE_PDB}...');
end;
/
alter session set container = ${ORACLE_PDB};

begin
  dbms_output.put_line('Checking for user ${ORACLE_USER} in ${ORACLE_PDB}...');
end;
/
declare
  v_count integer := 0;
begin
  select count(*) into v_count from dba_users where username = upper('${ORACLE_USER}');
  if v_count = 0 then
    dbms_output.put_line('User ${ORACLE_USER} not found. Creating user...');
    execute immediate 'create user ${ORACLE_USER} identified by "${ORACLE_PASSWORD}"';
    dbms_output.put_line('Granting privileges to ${ORACLE_USER}...');
    execute immediate 'grant create session, create table, create sequence, create view to ${ORACLE_USER}';
    execute immediate 'grant unlimited tablespace to ${ORACLE_USER}';
    dbms_output.put_line('User ${ORACLE_USER} created and privileges granted.');
  else
    dbms_output.put_line('User ${ORACLE_USER} already exists. Ensuring privileges...');
    execute immediate 'grant create session, create table, create sequence, create view to ${ORACLE_USER}';
    execute immediate 'grant unlimited tablespace to ${ORACLE_USER}';
    dbms_output.put_line('Privileges ensured for ${ORACLE_USER}.');
  end if;
end;
/
SQL

echo "User check completed."

echo "Finished user setup."
