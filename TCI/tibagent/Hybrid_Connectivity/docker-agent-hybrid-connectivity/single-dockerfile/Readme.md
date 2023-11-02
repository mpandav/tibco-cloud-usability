#  Build a tibagent Docker Image (Hybrid Connectivity)

## Steps to build a Docker Image
- Download and exact the .zip into /tmp directory

-  The required latest version of tibagent you need to download it from cloud.tibco.com 

- Run a docker build command from ternminal/command promt

      docker  build  --tag  mpandav/tibagent:latest .

 - The outcome of this process will look like something below:
   
   <img width="1025" alt="image" src="https://github.com/mpandav/tibco-cloud-usability/assets/38240734/ae0bcc7a-c5a0-436c-b613-8fac2d58aed0">
- Run the docker image to verify if its configured correctly and working as per the expectation. Use docker RUN command as below,

      docker run  --name tibagent-demo -e AGENT_NAME=tibagent-demo -e AGENT_PORT=7188 -e AGENT_SPEC="--spec 9093:192.168.2.183:9093" -e ACCESS_TOKEN="CIC~xxxxx" -e ACCESS_SECRET="O5whxxxxxxxxx" -e ACCESS_KEY_NAME="xxxx_bw"  mpandav/tibagent:latest


  

  <img width="1728" alt="image" src="https://github.com/mpandav/tibco-cloud-usability/assets/38240734/28b23d0a-984f-44fe-807e-a11b79ef9525">

### NOTE
You can modify the startup script to have log streaming options enabled if you need.
