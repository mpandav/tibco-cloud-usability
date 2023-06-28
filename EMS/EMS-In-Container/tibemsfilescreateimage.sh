#!/bin/bash

#
# Copyright (c) 2017-2022 by TIBCO Software Inc.
# ALL RIGHTS RESERVED
#
# $Id: tibemsfilescreateimage 2022-09-19 $
#
# Create a Docker image for running TIBCO EMS server on Kubernetes using persistent file storage
#
die()
{
    echo "$@"
    echo ""
    usage
    exit 1
}

######

usage()
{
    echo "Syntax: $0 <EMS installation zip file> [-h <EMS hotfix zip file>]* [-j <Java installation tar.gz file>} [-d <Docker image ouput directory>] [-u <user ID>] [-g <group ID>] [-t <tag name>]"
    echo ""
    echo "        where the required argument is:"
    echo "          <EMS installation zip file>"
    echo ""
    echo "        and the [optional arguments] are:"
    echo "          -h <EMS hotfix zip file> Install this hotfix. Default is no hotfix."
    echo "          -j <Java installation tar.gz file> Install Java. Default is no Java."
    echo "          -d <Docker image ouput directory>. Create a Docker image file there."
    echo "             Default is no Docker image file is created."
    echo "          -u <user ID> set in the image."
    echo "          -g <group ID> set in the image."
    echo "          -t <tag name> used to tag the image."
    echo "          -s Use experimental \"docker build --squash\"."
    echo "             *: Multiple -h entries allowed."
}

docker_image_summary()
{
    if [[ ${#HOTFIX_FILES[@]} -eq 1 ]]; then
        HOTFIX_TITLE=" EMS hotfix:     "
    else
        HOTFIX_TITLE=" EMS hotfixes:   "
    fi
    [[ -n ${SQUASH} ]] && summary_squash=true || summary_squash=false

    echo ""
    echo "================================================================================"
    echo " Building EMS Docker image"
    echo ""
    echo " EMS package:    ${EMS_FILE}"
    echo "${HOTFIX_TITLE}${HOTFIX_FILES_LIST[@]}"
    echo " Java package:   $summary_java"
    echo " Stores type:    ${stype}"
    echo " Output folder:  ${DOCKER_IMAGE_DIR}"
    echo " Image file:     ${DOCKER_IMAGE_FILE_NAME}"
    echo " Image name:tag: ems:${TAG_NAME}"
    echo " Image UID:      ${USER_ID}"
    echo " Image GID:      ${GROUP_ID}"
    echo " Docker squash:  ${summary_squash}"
    echo "================================================================================"
    echo ""
}

set_environment()
{
    if [[ $# -lt 1 ]]; then
        usage
        exit 1
    fi

    DOCKER_IMAGE_DIR=""
    JAVA_DOWNLOAD=""
    USER_ID=1000
    GROUP_ID=1000
    DOCKER_IMAGE_FILE_NAME=None
    stype="file"

    HOTFIX_DOWNLOADS=()
    HOTFIX_FILES=()
    HOTFIX_NUMS=()
    summary_java="None"

    EMS_DOWNLOAD=${1}
    [[ -r ${EMS_DOWNLOAD} ]] || die EMS distribution zip file not found or not readable

    EMS_FILE=$(basename ${EMS_DOWNLOAD})
    EMS_NAME=$(basename  ${EMS_FILE} .zip)
    MAJOR_MINOR=`expr "$EMS_NAME" : '[A-Za-z_]*\([0-9]*\.[0-9]*\)'`
    MAJOR_MINOR_SPACK=`expr "$EMS_NAME" : '[A-Za-z_]*\([0-9]*\.[0-9]*\.[0-9]*\)'`
    TAG_NAME=${MAJOR_MINOR_SPACK}

    shift
    OPTIND=1
    while getopts a:h:j:d:u:g:t:s ARGS
    do
        case $ARGS in
            h)
                [[ -r ${OPTARG} ]] || die EMS hotfix zip file ${OPTARG} not found or not readable
                HOTFIX_DOWNLOADS+=($OPTARG)
                HOTFIX_FILE=($(basename ${OPTARG}))
                HOTFIX_FILES+=(${HOTFIX_FILE})
                HOTFIX_NUMS+=(`expr "$HOTFIX_FILE" : '[A-Za-z0-9._]*\(_HF-[0-9]*\)'`)
                ;;
            j)
                JAVA_DOWNLOAD=$OPTARG
                [[ -r ${JAVA_DOWNLOAD} ]] || die Java tar.gz file not found or not readable
                JAVA_PATH=$(dirname $(tar tf $JAVA_DOWNLOAD | grep bin/java$ | grep -v jre/bin))
                JAVA_DIR=${JAVA_PATH%/bin}
                JAVA_FILE=$(basename ${JAVA_DOWNLOAD})
                ;;
            d)
                DOCKER_IMAGE_DIR=$OPTARG
                CREATE_IMAGE_FILE=true
                ;;
            u)
                USER_ID=$OPTARG
                ;;
            g)
                GROUP_ID=$OPTARG
                ;;
            t)
                EXPLICIT_TAG_NAME=$OPTARG
                ;;
            s)
                SQUASH=--squash=true
                ;;
            *)
                die
                ;;
        esac
    done

    DOCKER_BUILD_DIR=$(pwd)

    [[ -z ${DOCKER_IMAGE_DIR} ]] && DOCKER_IMAGE_DIR=None

    install_hotfix_instructions="echo Not installing a hotfix"
    install_java_instructions="RUN echo Not installing Java"

    if [[ -r ${JAVA_DOWNLOAD} ]]
    then
        summary_java=${JAVA_FILE}
        install_java_instructions="RUN cd /opt; tar xzf /install/${JAVA_FILE}"
    fi

    if [[ ${#HOTFIX_DOWNLOADS[@]} -gt 0 ]]
    then
        install_hotfix_instructions="cd /opt/tibco/ems/${MAJOR_MINOR}"
        IFS=$'\n'
        HOTFIX_FILES_LIST=($(sort <<<"${HOTFIX_FILES[*]}"))
        HOTFIX_NUMS_LIST=($(sort <<<"${HOTFIX_NUMS[*]}"))
        unset IFS
        for hf_file in ${HOTFIX_FILES_LIST[@]}
        do
            install_hotfix_instructions+="; unzip -o /install/${hf_file}"
        done
        TAG_NAME=${MAJOR_MINOR_SPACK}${HOTFIX_NUMS_LIST[-1]}
    else
        HOTFIX_FILES_LIST+=("None")
    fi
    
    if [[ $EXPLICIT_TAG_NAME ]]
    then
        TAG_NAME=$EXPLICIT_TAG_NAME
    fi
}

######

set_environment $@

rm -rf ${DOCKER_BUILD_DIR}/tmp || die Could not remove old temp directory
mkdir -p ${DOCKER_BUILD_DIR}/tmp || die Could not create new temp directory

if [[ -r ${JAVA_DOWNLOAD} ]]
then
    cp ${JAVA_DOWNLOAD} ${DOCKER_BUILD_DIR}/tmp || die Unable to copy java distribution
fi

if [[ ${#HOTFIX_DOWNLOADS[@]} -gt 0 ]]
then
    for hotfix in ${HOTFIX_DOWNLOADS[@]}
    do
        cp ${hotfix} ${DOCKER_BUILD_DIR}/tmp || die Unable to copy EMS hotfix ${hotfix}
    done
fi

cat > ${DOCKER_BUILD_DIR}/tmp/Dockerfile <<DOCKERFILE
FROM eclipse-temurin:11-jre-focal
MAINTAINER TIBCO Software Inc.
ARG JAVA_DIR
VOLUME /shared
EXPOSE 7222
EXPOSE 7220
ENTRYPOINT [ "tibems.sh" ]
CMD []
WORKDIR /install

RUN mkdir -p /home/user /opt/tibco/ems/docker/{jdbc,security,ftl,rv} /opt/${JAVA_DIR} /shared
RUN groupadd -g ${GROUP_ID}  tibgroup && useradd -m -d /home/user/tibuser -r -u ${USER_ID} -g tibgroup tibuser

RUN chown -R tibuser:tibgroup /home/user/tibuser /opt/tibco /opt/${JAVA_DIR} /shared /install

ENV EMS_SERVICE_NAME=emsserver
ENV EMS_NODE_NAME=localhost
ENV EMS_PUBLIC_PORT=7222
ENV EMS_PROBE_PORT=7220


RUN apt-get update && apt-get --no-install-recommends -y install unzip ssh net-tools \ 
&& apt-get -y install xsltproc && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --chown=tibuser:tibgroup . /install

USER tibuser

RUN /install/ems_install.sh
RUN mv /install/*configbase.* /opt/tibco/ems/docker
RUN mv /install/tibems.sh /opt/tibco/ems/docker

${install_java_instructions}

RUN rm -rf /install/*

ENV PATH=".:/opt/tibco/ems/${MAJOR_MINOR}/bin:/opt/\${JAVA_DIR}/bin:/opt/tibco/ems/docker:\${PATH}"

WORKDIR /shared
DOCKERFILE

cat > ${DOCKER_BUILD_DIR}/tmp/ems_install.sh <<INSTALLER
#!/bin/bash
cd /install
unzip ${EMS_FILE} TIB_ems_${MAJOR_MINOR_SPACK}/tar/*
for file in \`ls -1 /install/TIB_ems_${MAJOR_MINOR_SPACK}/tar/*.tar.gz\`; do tar zxf "\${file}" -C /; done
${install_hotfix_instructions}
INSTALLER

chmod +x ${DOCKER_BUILD_DIR}/tmp/ems_install.sh

echo installing type $stype
cat > ${DOCKER_BUILD_DIR}/tmp/tibemsd-configbase.json <<TIBEMSDCONFIG
{
  "factories":[
    {
      "name":"ConnectionFactory",
      "type":"generic",
      "url":"tcp://localhost:7222"
    },
    {
      "name":"FTConnectionFactory",
      "reconnect_attempt_count":"120",
      "reconnect_attempt_delay":"500",
      "type":"generic",
      "url":"tcp://localhost:7222,tcp://localhost:7222"
    },
    {
      "name":"SSLConnectionFactory",
      "ssl":
      {
        "ssl_verify_host":false,
        "ssl_verify_hostname":false
      },
      "type":"generic",
      "url":"ssl://localhost:7222"
    },
    {
      "name":"SSLFTConnectionFactory",
      "reconnect_attempt_count":"120",
      "reconnect_attempt_delay":"500",
      "ssl":
      {
        "ssl_verify_host":false,
        "ssl_verify_hostname":false
      },
      "type":"generic",
      "url":"ssl://localhost:7222,ssl://localhost:7222"
    },
    {
      "name":"GenericConnectionFactory",
      "type":"generic",
      "url":"tcp://localhost:7222"
    },
    {
      "name":"TopicConnectionFactory",
      "type":"topic",
      "url":"tcp://localhost:7222"
    },
    {
      "name":"QueueConnectionFactory",
      "type":"queue",
      "url":"tcp://localhost:7222"
    },
    {
      "name":"FTTopicConnectionFactory",
      "reconnect_attempt_count":"120",
      "reconnect_attempt_delay":"500",
      "type":"topic",
      "url":"tcp://localhost:7222,tcp://localhost:7222"
    },
    {
      "name":"FTQueueConnectionFactory",
      "reconnect_attempt_count":"120",
      "reconnect_attempt_delay":"500",
      "type":"queue",
      "url":"tcp://localhost:7222,tcp://localhost:7222"
    },
    {
      "name":"SSLQueueConnectionFactory",
      "ssl":
      {
        "ssl_verify_host":false,
        "ssl_verify_hostname":false
      },
      "type":"generic",
      "url":"ssl://localhost:7222"
    },
    {
      "name":"SSLTopicConnectionFactory",
      "ssl":
      {
        "ssl_verify_host":false,
        "ssl_verify_hostname":false
      },
      "type":"generic",
      "url":"ssl://localhost:7222"
    }
  ],
  "groups":[
    {
      "description":"Administrators",
      "members":[
        {
          "name":"admin"
        }
      ],
      "name":"\$admin"
    }
  ],
  "model_version":"1.0",
  "queues":[
    {
      "name":">"
    },
    {
      "name":"sample",
      "flowControl":"512MB"
    },
    {
      "name":"queue.sample",
      "flowControl":"512MB"
    }
  ],
  "stores":[
    {
      "file":"meta.db",
      "file_crc":true,
      "mode":"async",
      "name":"\$sys.meta",
      "type":"file"
    },
    {
      "file":"async-msgs.db",
      "file_crc":true,
      "mode":"async",
      "name":"\$sys.nonfailsafe",
      "type":"file"
    },
    {
      "file":"sync-msgs.db",
      "file_crc":true,
      "mode":"sync",
      "name":"\$sys.failsafe",
      "type":"file"
    }
  ],
  "tibemsd":{
    "always_exit_on_disk_error":true,
    "authorization":false,
    "client_heartbeat_server":5,
    "client_timeout_server_connection":20,
    "console_trace":"DEFAULT",
    "detailed_statistics":"NONE",
    "flow_control":true,
    "handshake_timeout":3,
    "health_check_listen":"http://:7220",
    "log_trace":"DEFAULT",
    "logfile":"/shared/ems/logs/tibemsd.log",
    "logfile_max_size":"1MB",
    "max_msg_memory":"512MB",
    "max_stat_memory":"64MB",
    "primary_listens":[
      {
        "url":"tcp://7222"
      }
    ],
    "reserve_memory":"64MB",
    "server":"EMS-SERVER",
    "server_heartbeat_client":5,
    "server_heartbeat_server":5,
    "server_timeout_client_connection":20,
    "server_timeout_server_connection":20,
    "server_rate_interval":1,
    "statistics":true,
    "statistics_cleanup_interval":30,
    "store":"/shared/ems/datastore"
  },
  "topics":[
    {
      "name":">"
    },
    {
      "name":"sample",
      "flowControl":"512MB"
    },
    {
      "name":"topic.sample",
      "flowControl":"512MB"
    }
  ],
  "users":[
    {
      "description":"Administrator",
      "name":"admin"
    },
    {
      "description":"Main Server",
      "name":"EMS-SERVER"
    }
  ]
}
TIBEMSDCONFIG

cat > ${DOCKER_BUILD_DIR}/tmp/tibems.sh <<TIBEMS
#!/bin/bash

tibemsd_seed()
{
    if [ ! -f "/shared/ems/config/\$EMS_SERVICE_NAME.json" ]; then
        echo Creating EMS configuration file and folders:
        echo "  /shared/ems/config"
        echo "  /shared/ems/config/\$EMS_SERVICE_NAME.json"
        echo "  /shared/ems/datastore-\$EMS_SERVICE_NAME"
        echo "  /shared/ems/logs"

        mkdir -p /shared/ems/config
        mkdir -p /shared/ems/datastore-\$EMS_SERVICE_NAME
        mkdir -p /shared/ems/logs

        cp /opt/tibco/ems/docker/tibemsd-configbase.json /shared/ems/config/\$EMS_SERVICE_NAME.json
        sed -i "s/localhost:7222/\$EMS_NODE_NAME:\$EMS_PUBLIC_PORT/g; \\
                s/7220/\$EMS_PROBE_PORT/g; \\
                s/tibemsd\.log/\$EMS_SERVICE_NAME\.log/; \\
                s/datastore/datastore-\$EMS_SERVICE_NAME/; \\
                s/EMS-SERVER/\$EMS_SERVICE_NAME/" \\
            /shared/ems/config/\$EMS_SERVICE_NAME.json
    fi
}

tibemsd_run()
{
    shift
    if [[ \$# -ge 1 ]]; then
        PARAMS=\$*
    else
        tibemsd_seed
        PARAMS="-config /shared/ems/config/\$EMS_SERVICE_NAME.json"
    fi

    echo " "
    ls -lrt
    echo tibemsd \$PARAMS
    exec tibemsd \$PARAMS
}

case "\$1" in
    "")
        tibemsd_run \$*
        ;;
    "file")
        tibemsd_run \$*
        ;;
    *)
        echo \$1 is not a valid EMS run option
        exit 1
        ;;
esac
TIBEMS

chmod +x ${DOCKER_BUILD_DIR}/tmp/*.sh

[[ "${CREATE_IMAGE_FILE}" = "true" ]] && DOCKER_IMAGE_FILE_NAME=ems-${TAG_NAME}.dockerimage.xz
docker_image_summary

echo Copying the EMS installation zip file
cp ${EMS_DOWNLOAD} ${DOCKER_BUILD_DIR}/tmp || die Unable to copy EMS installer

docker buildx build --platform linux/arm64,linux/amd64 ${SQUASH} --build-arg=JAVA_DIR=${JAVA_DIR} -t mpandav/ems:${TAG_NAME} ${DOCKER_BUILD_DIR}/tmp --push || die docker build failed


# docker tag mpandav/ems:${TAG_NAME} ems:latest || die unable to tag docker build

if [[ "${CREATE_IMAGE_FILE}" == "true" ]]
then
    mkdir -p ${DOCKER_IMAGE_DIR}
    echo -n Saving the image...
    docker save ems:${TAG_NAME} | xz -9 > ${DOCKER_IMAGE_DIR}/${DOCKER_IMAGE_FILE_NAME} \
      || die Could not save docker image
    echo " done."
fi

rm -rf ${DOCKER_BUILD_DIR}/tmp || die Could not remove old tmp directory