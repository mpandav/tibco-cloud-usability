#!/bin/bash
echo "========================="
echo "TIBCO Cloud Integration Hybrid Agent [${AGENT_NAME}@${AGENT_PORT}]"
./tibagent --version

echo "========================="


echo ================================================================
echo
echo "./tibagent start agent --config-dir . ${AGENT_SPEC}  ${AGENT_NAME}"
echo
echo ================================================================

./tibagent start agent --config-dir . ${AGENT_SPEC}  ${AGENT_NAME}

echo "========================="
echo "Hybrid Agent ended"
echo "========================="

