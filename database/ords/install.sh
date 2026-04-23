#!/bin/sh

echo "ORDS install başlıyor..."

ords --config /etc/ords/config install \
  --admin-user SYS \
  --db-hostname oracleservice \
  --db-port 1521 \
  --db-servicename FREEPDB1 \
  --feature-db-api true \
  --log-folder /tmp \
  --password-stdin <<EOF
$ORDS_ADMIN_PASSWORD
$ORDS_ADMIN_PASSWORD
EOF

echo "ORDS install tamamlandı."
