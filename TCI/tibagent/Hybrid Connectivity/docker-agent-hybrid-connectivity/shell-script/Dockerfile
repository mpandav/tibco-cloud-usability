FROM ubuntu

ARG ARG_AGENT=tibagent
ARG ARG_PORT=7816
ARG ARG_PORT1=9093
ARG ARG_PORT2=9094
ARG ARG_PORT3=9095
ARG ARG_SPEC

WORKDIR /opt/tci/bin

ENV AGENT_NAME=$ARG_AGENT
ENV AGENT_PORT=$ARG_PORT
ENV AGENT_SPEC=$ARG_SPEC

CMD ["/opt/tci/bin/startup.sh"]

ADD ./startup.sh ./startup.sh
COPY ./agents/$ARG_AGENT/ ./agents/$ARG_AGENT/
COPY ./tibagent-linux ./tibagent

RUN { \
  apt-get update; \
  apt-get install -y curl; \
  apt-get install -y vim; \
  apt-get install -y iputils-ping; \
  apt-get install --no-install-recommends -y ca-certificates; \
}

EXPOSE $ARG_PORT $ARG_PORT $ARG_PORT1 $ARG_PORT2 $ARG_PORT3

RUN ls -la /opt/tci/bin
