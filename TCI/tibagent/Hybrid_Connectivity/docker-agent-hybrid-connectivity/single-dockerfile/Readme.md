#  Build a tibagent Docker Image (Hybrid Connectivity)

## Steps to build a Docker Image
- Download and exact the .zip into /tmp directory

-  The required latest version of tibagent you need to download it from cloud.tibco.com 

- Run a docker build command from ternminal/command promt

      docker  build  --tag  mpandav/tibagent:latest .

 - The outcome of this process will look like something below:
   <img width="1068" alt="image" src="https://github.com/mpandav/tibco-cloud-usability/assets/38240734/5ae85f42-cec9-4790-876f-75d53de51913">

## Test the tibagent Image

### Test in Docker Container

#### Hybrid Connectivity   
- Run the docker image to verify if its configured correctly and working as per the expectation. Use docker RUN command as below,

      docker run  --name tibagent-demo -e AGENT_NAME=tibagent-demo -e AGENT_PORT=7188 -e AGENT_SPEC="--spec 9093:192.168.2.183:9093" -e ACCESS_TOKEN="CIC~xxxxx" -e ACCESS_SECRET="O5whxxxxxxxxx" -e ACCESS_KEY_NAME="xxxx_bw" -e LOG_STREAM=false mpandav/tibagent:latest

   <img width="1728" alt="image" src="https://github.com/mpandav/tibco-cloud-usability/assets/38240734/1cffb223-8418-49d1-839f-75cc78463d9f">

#### Log Streaming and Hybrid Connectivity
The Log Streaming is controlled through the Environment variable **LOG_STREAM**; if it is set to **true** then agent will start with LogStreaming otherwise it will only run hybrid connectivity mode.

      docker run -e AGENT_NAME=tibagent-demo -e AGENT_PORT=7188 -e AGENT_SPEC="--spec 9093:192.168.2.183:9093" -e ACCESS_TOKEN="CIC~xxxx" -e ACCESS_SECRET="O5whWjxxxxxx" -e LOG_STREAM=true -e ACCESS_KEY_NAME="xxxxxxx_bw"  mpandav/tibagent:latest

The result of above executaion looks like something below:

<img width="1728" alt="image" src="https://github.com/mpandav/tibco-cloud-usability/assets/38240734/8804c4d8-3c07-4f92-a656-fb4d90d9f2ab">

### Deploy in K8S Cluster
Use the deployment .yml file from K8S folder, update required environment variables as per your Environmen and using kubeclt push to k8s cluster.

Ex. 

            kubectl apply -f ~./tibagent/tci-demo-tibagent.yml

![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/f2036369-1165-4391-a30a-7cf1fcc98e2b)

![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/8516d094-b826-4ecf-b44a-d959202d48a4)

![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/862b548a-ddc5-49d2-977e-364cabee1a75)



## Refrerence
A sample  [Docker Image](https://hub.docker.com/r/mpandav/tibagent) for your reference.

### NOTE
