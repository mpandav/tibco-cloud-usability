# Building tibAgent for Hybrid Connectivity
FROM ubuntu:latest
LABEL maintainer="Cloud Software Group, Inc."

WORKDIR /opt/tci/bin

# ARGUMENTS
#ARG ARG_LOG_STREAM_FILE=/opt/tci/logs/${AGENT_NAME}.log

#Environment variables
ENV AGENT_NAME=""
ENV AGENT_PORT=""
ENV AGENT_SPEC=""
ENV ACCESS_TOKEN=""
ENV ACCESS_SECRET=""
ENV ACCESS_KEY_NAME=""
ENV LOG_STREAM=false
ENV LOG_STREAM_PORT=""
ENV DATA_CHUNK_SIZE=1024
ENV DATA_ACK_MODE=false
#ENV LOG_STREAM_FILE=/opt/tci/logs/${AGENT_NAME}.log

COPY  . /opt/tci/bin/
RUN { \
  apt-get update; \
  apt-get install -y curl; \
  apt-get install -y vim; \
  apt-get install -y iputils-ping; \
  apt-get install --no-install-recommends -y ca-certificates; \
  apt-get install -y  socat; \
}

#ENV LANG C.UTF-8
#ENV LC_ALL C.UTF-8
EXPOSE $AGENT_PORT
ENTRYPOINT ["/opt/tci/bin/startup.sh"]


