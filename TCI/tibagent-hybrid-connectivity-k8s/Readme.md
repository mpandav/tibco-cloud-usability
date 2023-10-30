# Deploy tibagent in K8S for Hybrid Connectivity

## auth with TIBCO Cloud

./tibagent authorize --token CIC~PC7uutpANWTPbd9dROMaolEH 


## Configure tib Agent
./tibagent configure agent -p 5150 kafkaagent001

## Configure to Hybrid connectivity with AccessKey & Secret
 ./tibagent configure connect --accessSecret O5whWjnSsoAFSuMUJlMMrpWVlGzatRGnSgcGOb2LQkE  --accessKey mpandav_bw  kafkaagent001

## Generate K8S templates and config files
./tibagent configure manage kafkaagent001

## Update tibagent.yaml file
Edit the .yml file for tiagent-main section to add specification or source & targets to be connected.
Ex. 
         env:
            - name: CMD_OPTIONS
            value: "--spec 9093:192.168.2.183:9093"

# Apply deployment
./tibagent apply manage kafkaagent001  

# Start agent and do deployment in K8S
./tibagent -d apply manage kafkaagent001


NOTE: You can do the deployment of tibagent in specific namespace as well, pls follow the documentation here: 
https://eu.integration.cloud.tibco.com/docs/index.html#tci/using/hybrid-agent/agent-command-reference.html#configure-manage
