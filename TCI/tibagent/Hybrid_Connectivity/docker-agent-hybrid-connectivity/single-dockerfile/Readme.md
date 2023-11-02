#  Build a tibagent Docker Image (Hybrid Connectivity)

## Steps to build a Docker Image
- Download and exact the .zip into /tmp directory

-  The required latest version of tibagent you need to download it from cloud.tibco.com 

- Run a docker build command from ternminal/command promt

      docker  build  --tag  mpandav/tibagent:latest .

 - The outcome of this process will look like something below:
   <img width="1068" alt="image" src="https://github.com/mpandav/tibco-cloud-usability/assets/38240734/5ae85f42-cec9-4790-876f-75d53de51913">

   
- Run the docker image to verify if its configured correctly and working as per the expectation. Use docker RUN command as below,

      docker run  --name tibagent-demo -e AGENT_NAME=tibagent-demo -e AGENT_PORT=7188 -e AGENT_SPEC="--spec 9093:192.168.2.183:9093" -e ACCESS_TOKEN="CIC~xxxxx" -e ACCESS_SECRET="O5whxxxxxxxxx" -e ACCESS_KEY_NAME="xxxx_bw"  mpandav/tibagent:latest

   <img width="1728" alt="image" src="https://github.com/mpandav/tibco-cloud-usability/assets/38240734/1cffb223-8418-49d1-839f-75cc78463d9f">



### NOTE
You can modify the startup script to have log streaming options enabled if you need.
