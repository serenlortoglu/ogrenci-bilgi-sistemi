FROM container-registry.oracle.com/database/ords:latest

USER root

ENV ORDS_CONFIG=/etc/ords/config

RUN mkdir -p /etc/ords/config
COPY install.sh /opt/ords/install.sh

RUN chmod +x /opt/ords/install.sh

ENTRYPOINT ["/bin/sh", "-c"]

CMD ["/opt/ords/install.sh && exec ords --config /etc/ords/config serve"]
