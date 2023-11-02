#  Build a tibagent Docker Image (Hybrid Connectivity)

## Steps to build a Docker Image
- Download and exact the .zip into /tmp directory

-  The required latest version of tibagent you need to download it from cloud.tibco.com 

- Run a docker build command from ternminal/command promt

      docker  build  --tag  mpandav/tibagent:latest .

 - The outcome of this process will look like something below:
   <img width="1068" alt="image" src="https://github.com/mpandav/tibco-cloud-usability/assets/38240734/5ae85f42-cec9-4790-876f-75d53de51913">

## Test the tibagent Image

### Run it with for Hybrid Connectivity   
- Run the docker image to verify if its configured correctly and working as per the expectation. Use docker RUN command as below,

      docker run  --name tibagent-demo -e AGENT_NAME=tibagent-demo -e AGENT_PORT=7188 -e AGENT_SPEC="--spec 9093:192.168.2.183:9093" -e ACCESS_TOKEN="CIC~xxxxx" -e ACCESS_SECRET="O5whxxxxxxxxx" -e ACCESS_KEY_NAME="xxxx_bw" -e LOG_STREAM=false mpandav/tibagent:latest

   <img width="1728" alt="image" src="https://github.com/mpandav/tibco-cloud-usability/assets/38240734/1cffb223-8418-49d1-839f-75cc78463d9f">

### Run it with Log Streaming and Hybrid Connectivity
The Log Streaming is controlled through the Environment variable **LOG_STREAM**; if it is set to **true** then agent will start with LogStreaming otherwise it will only run hybrid connectivity mode.

      docker run -e AGENT_NAME=tibagent-demo -e AGENT_PORT=7188 -e AGENT_SPEC="--spec 9093:192.168.2.183:9093" -e ACCESS_TOKEN="CIC~xxxx" -e ACCESS_SECRET="O5whWjxxxxxx" -e LOG_STREAM=true -e ACCESS_KEY_NAME="xxxxxxx_bw"  mpandav/tibagent:latest

The result of above executaion looks like something below:

<img width="1728" alt="image" src="https://github.com/mpandav/tibco-cloud-usability/assets/38240734/8804c4d8-3c07-4f92-a656-fb4d90d9f2ab">

## Refrerence
A sample  [Docker Image](https://hub.docker.com/r/mpandav/tibagent) for your reference.

### NOTE
You must have to provide the **LOG_STREAM** enviroment variable while starting the container. it won't work with this variable as its controlling the behavior of hybrid agent.