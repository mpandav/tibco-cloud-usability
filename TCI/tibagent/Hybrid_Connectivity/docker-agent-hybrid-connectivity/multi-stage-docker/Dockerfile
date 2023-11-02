# multi-stage docker build process
# Building tibAgent for Hybrid Connectivity
FROM ubuntu:latest AS builder
LABEL stage=builder

WORKDIR /opt/tci/bin

#INCOMING ARGUMENTS
ARG ARG_AGENT_NAME
ARG ARG_AGENT_PORT
ARG ARG_AGENT_SPEC
ARG ARG_ACCESS_TOKEN
ARG ARG_ACCESS_SECRET
ARG ARG_ACCESS_KEY_NAME

#Environment variables
ENV AGENT_NAME=$ARG_AGENT_NAME
ENV AGENT_PORT=$ARG_AGENT_PORT
ENV AGENT_SPEC=$ARG_AGENT_SPEC
ENV ACCESS_TOKEN=$ARG_ACCESS_TOKEN
ENV ACCESS_SECRET=$ARG_ACCESS_SECRET
ENV ACCESS_KEY_NAME=$ARG_ACCESS_KEY_NAME


COPY  . /opt/tci/bin/
RUN { \
  apt-get update; \
  apt-get install -y curl; \
  apt-get install -y vim; \
  apt-get install -y iputils-ping; \
  apt-get install --no-install-recommends -y ca-certificates; \
}

RUN chmod 777 build-agent.sh && /opt/tci/bin/build-agent.sh $AGENT_NAME $AGENT_PORT $ACCESS_TOKEN $ACCESS_SECRET $ACCESS_KEY_NAME

# coping the contents from previously built images

FROM ubuntu:latest
LABEL maintainer="Cloud Software Group, Inc."

#Environment variables
ARG ARG_AGENT_NAME=$ARG_AGENT_NAME
ENV AGENT_NAME=$ARG_AGENT_NAME
ENV AGENT_PORT=$ARG_AGENT_PORT
ENV AGENT_SPEC=$ARG_AGENT_SPEC

RUN echo ${ARG_AGENT_NAME}
RUN echo ${AGENT_NAME}
RUN echo ${AGENT_PORT}

WORKDIR /opt/tci/bin

RUN groupadd tibgroup && useradd -ms /bin/bash tibagent

#RUN addgroup -S tibgroup && adduser -S tibagent -G tibgroup

COPY --from=builder --chown=tibagent:tibgroup  /opt/tci/bin/startup.sh /opt/tci/bin/startup.sh
COPY --from=builder --chown=tibagent:tibgroup  /opt/tci/bin/agents/$ARG_AGENT_NAME/ /opt/tci/bin/agents/$ARG_AGENT_NAME/
COPY --from=builder --chown=tibagent:tibgroup  /opt/tci/bin/tibagent-linux /opt/tci/bin/tibagent
RUN chmod 777 *
RUN { \
  apt-get update; \
  apt-get install -y curl; \
  apt-get install -y vim; \
  apt-get install -y iputils-ping; \
  apt-get install --no-install-recommends -y ca-certificates; \
}
USER tibagent
#ENV LANG C.UTF-8
#ENV LC_ALL C.UTF-8
EXPOSE $AGENT_PORT
ENTRYPOINT ["/opt/tci/bin/startup.sh"]


