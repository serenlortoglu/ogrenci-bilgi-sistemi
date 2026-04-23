FROM container-registry.oracle.com/database/ords:latest

USER root

ENV ORDS_CONFIG=/etc/ords/config

RUN mkdir -p /etc/ords/config

RUN ords install \
    --admin-user SYS \
    --db-hostname oracleservice \
    --db-port 1521 \
    --db-servicename FREEPDB1 \
    --feature-db-api true \
    --log-folder /tmp \
    --password-stdin <<EOF
Str0ngPassw0rd1
Str0ngPassw0rd1
EOF

CMD ["serve"]
