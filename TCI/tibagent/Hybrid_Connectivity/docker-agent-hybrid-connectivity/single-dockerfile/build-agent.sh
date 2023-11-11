#!/bin/bash

echo ================================================================
echo
echo "Login to TIBCO Cloud using token [${ACCESS_TOKEN}]..."
echo  "./tibagent authorize --token ${ACCESS_TOKEN}" 
echo
echo ================================================================

 ./tibagent authorize --token ${ACCESS_TOKEN} 

echo ================================================================
echo
echo "Configure  tibagent [${AGENT_NAME}:${AGENT_PORT}]..."
echo "./tibagent configure agent --port ${AGENT_PORT} --config-dir . ${AGENT_NAME}"
echo
echo ================================================================

./tibagent configure agent --port ${AGENT_PORT} --config-dir . ${AGENT_NAME}

echo ================================================================
echo
echo "Configure Connectivity for tibagent [${AGENT_NAME}:${AGENT_PORT} and ${AGENT_SPEC}]..."
echo " ./tibagent configure connect --config-dir . --accessSecret ${ACCESS_SECRET}  --accessKey ${ACCESS_KEY_NAME}  ${AGENT_NAME}"
echo
echo ================================================================

 ./tibagent configure connect --config-dir . --accessSecret ${ACCESS_SECRET}  --accessKey ${ACCESS_KEY_NAME}  ${AGENT_NAME}

echo ================================================================
echo
echo "Hybrid Agnet [ ${AGENT_NAME}:${AGENT_PORT} ] is Configured Successfully..."
echo
echo ================================================================
