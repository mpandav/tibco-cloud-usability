#!/bin/bash

chmod 777 *
. ./build-agent.sh
echo 
echo "========================="
echo "TIBCO Cloud Integration Hybrid Agent [${AGENT_NAME}@${AGENT_PORT}]"
echo 
echo 
./tibagent --version

echo "========================="
echo "Starting Hybrid Agent [${AGENT_NAME}@${AGENT_PORT} ]..."
echo "========================="

if ($LOG_STREAM -eq "true") 
then {
        echo "With Log streaming"
        echo "./tibagent start agent --config-dir . ${AGENT_SPEC} --logStream  --logStreamPort=7111 --log-file=/opt/tci/logs/${AGENT_NAME}.log ${AGENT_NAME}"
        echo 
        echo "====================================="
        mkdir /opt/tci/logs
        logfile=${AGENT_NAME}.log
        ./tibagent start agent --config-dir . ${AGENT_SPEC} --logStream --log-file=/opt/tci/logs/${AGENT_NAME}.log ${AGENT_NAME} &
        echo "Hybrid Agent [ ${AGENT_NAME} ] Started..."
        echo
        echo
        sleep 10
        tail -f /opt/tci/logs/${AGENT_NAME}.log
    }
else {
        echo "Without Log Streaming" 
        echo
        echo "./tibagent start agent --config-dir . ${AGENT_SPEC}  ${AGENT_NAME}"
        echo 
        echo "Hybrid Agent [ ${AGENT_NAME} ] Started..."
        echo
        echo
        ./tibagent start agent --config-dir . ${AGENT_SPEC}  ${AGENT_NAME} 
}
fi
echo "========================="
echo "Hybrid Agent ended"
echo "========================="

