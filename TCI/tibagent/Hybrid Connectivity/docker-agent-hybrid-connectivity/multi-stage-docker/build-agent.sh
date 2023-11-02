#!/bin/bash

agent=${1:-tci-tibagent}
port=${2:-7818}
token=${3}
accessSecret=${4}
accessKey=${5}
spec=${6}

image=tibagent
tag=latest

echo ================================================================
echo
echo "Login to TIBCO Cloud using token [${token}]..."
echo
echo ================================================================

 ./tibagent authorize --token ${token} 

echo ================================================================
echo
echo "Configure  tibagent [${agent}:${port}]..."
echo
echo ================================================================

./tibagent configure agent --port ${port} --config-dir . ${agent}

echo ================================================================
echo
echo "Configure Connectivity for tibagent [${agent}:${port} and ${spec}]..."
echo
echo ================================================================

 ./tibagent configure connect --config-dir . --accessSecret ${accessSecret}  --accessKey ${accessKey}  ${agent}

echo ================================================================
echo
echo "Hybrid Agnet [ ${agent}:${port} ] is Configured Successfully..."
echo
echo ================================================================
