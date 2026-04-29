#!/bin/sh
set -eu

: "${ORDS_ADMIN_PASSWORD:?Missing ORDS_ADMIN_PASSWORD}"

ORDS_CONFIG="${ORDS_CONFIG:-/etc/ords/config}"
ORDS_DB_HOSTNAME="${ORDS_DB_HOSTNAME:-oracleservice}"
ORDS_DB_PORT="${ORDS_DB_PORT:-1521}"
ORDS_DB_SERVICE="${ORDS_DB_SERVICE:-FREEPDB1}"
ORDS_INSTALL_RETRIES="${ORDS_INSTALL_RETRIES:-60}"
ORDS_INSTALL_DELAY="${ORDS_INSTALL_DELAY:-5}"
ORDS_INSTALL_MARKER="${ORDS_CONFIG}/.installed"
ORDS_PUBLIC_USER_PASSWORD="${ORDS_PUBLIC_USER_PASSWORD:-$ORDS_ADMIN_PASSWORD}"

if [ -f "$ORDS_INSTALL_MARKER" ]; then
  echo "ORDS already configured."
  exit 0
fi

echo "ORDS install başlıyor..."

# Clean up and create config directory
rm -rf "$ORDS_CONFIG"
mkdir -p "$ORDS_CONFIG"

attempt=1
while [ "$attempt" -le "$ORDS_INSTALL_RETRIES" ]; do
  echo "ORDS install denemesi ${attempt}/${ORDS_INSTALL_RETRIES}"

  # Try with user password method
  if ords --config "$ORDS_CONFIG" install \
    --admin-user SYS \
    --db-hostname "$ORDS_DB_HOSTNAME" \
    --db-port "$ORDS_DB_PORT" \
    --db-servicename "$ORDS_DB_SERVICE" \
    --feature-db-api true \
    --log-folder /tmp \
    --proxy-user \
    --password-stdin <<EOF
$ORDS_ADMIN_PASSWORD
$ORDS_PUBLIC_USER_PASSWORD
$ORDS_PUBLIC_USER_PASSWORD
EOF
  then
    touch "$ORDS_INSTALL_MARKER"
    echo "ORDS install tamamlandı."
    exit 0
  fi

  attempt=$((attempt + 1))
  if [ "$attempt" -le "$ORDS_INSTALL_RETRIES" ]; then
    echo "ORDS install başarısız oldu, ${ORDS_INSTALL_DELAY} saniye sonra yeniden denenecek..."
    sleep "$ORDS_INSTALL_DELAY"
  fi
done

echo "ORDS install başarısız oldu, konteyner başlatılmayacak." >&2
exit 1
