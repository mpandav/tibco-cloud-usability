#!/bin/bash

chmod 777 *
. ./build-agent.sh

echo "========================="
echo "TIBCO Cloud Integration Hybrid Agent [${AGENT_NAME}@${AGENT_PORT}]"
echo "========================="
./tibagent --version


echo "================================================================"
echo
echo "./tibagent start agent --config-dir . ${AGENT_SPEC}  ${AGENT_NAME}"
echo
echo "================================================================"

./tibagent start agent --config-dir . ${AGENT_SPEC}  ${AGENT_NAME}

echo "========================="
echo "Hybrid Agent ended"
echo "========================="

