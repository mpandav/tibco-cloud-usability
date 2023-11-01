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
echo "Building docker image to run Hybrid Agent [docker build --tag  ${image}/${agent}:${tag} 	--build-arg ARG_AGENT=${agent} 	--build-arg ARG_PORT=${port} --build-arg ARG_SPEC=${spec}] "
echo
echo ================================================================

docker build \
	--tag  ${image}/${agent}:${tag} \
	--build-arg ARG_AGENT=${agent} \
	--build-arg ARG_PORT=${port} \
	--build-arg ARG_SPEC="${spec}" .

echo ================================================================
echo
docker images | grep ${image}/${agent}
echo
echo ================================================================

echo ================================================================
echo
echo "Generate docker run agent script [run-agent-${agent}.sh]"
echo
echo ================================================================

container=$(echo $agent | sed 's/\./_/g')

echo "#!/bin/bash" > run-agent-${agent}.sh
echo "kubectl create deployment ${container}-agent --image=${image}/${agent}:${port}" >> run-agent-${agent}.sh
echo "kubectl expose deployment ${container}-agent --port=${port} --target-port=${port} --type=ClusterIP --name=${container}-agent" >> run-agent-${agent}.sh
echo "kubectl get service  ${container}-agent" >> run-agent-${agent}.sh
echo "kubectl get deployment  ${container}-agent" >> run-agent-${agent}.sh

chmod +x run-agent-${agent}.sh
