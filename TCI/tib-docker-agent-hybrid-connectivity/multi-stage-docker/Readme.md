# Multi-stage Docker Build for Hybridagents Docker Image (Hybrid Connectivity)

## Steps to build a Docker Image
- Download and exact the .zip into /tmp directory

-  The required latest version of tibagent you need to download it from cloud.tibco.com 

- Run a docker build command from ternminal/command promt

      docker build \
            --tag  mpandav/tibagent:latest \
            --build-arg ARG_AGENT_NAME=demo \
            --build-arg ARG_AGENT_PORT=7818 \
            --build-arg ARG_ACCESS_TOKEN="CIC~xx"  \
            --build-arg ARG_ACCESS_SECRET="O5xxxxxxbxbbxbxbxbx"  \
            --build-arg ARG_ACCESS_KEY_NAME="xxxxxx_bw"  \
            --build-arg ARG_AGENT_SPEC="--spec 9093:192.168.2.183:9093"  .

    - **demoagent** = Agent Name (provide any name of your choice)
    - **7888** = Management port for tibagent to communicate (select as per your chouice, default is 7818)
    - **CIC~xxxx** = Access Token to login into TIBCO Cloud (Its OAuth token generated from the TIBCO Cloud)
    - **O5xxxxnxx** = Access Secret to create tibagent tunnel to connect backend OnPrem services. It will be created from TIBCO Cloud -> Settings -> Proxy Agent Access Key
    - **xxxxx_bw** = It is name of your Access Key created from TIBCO Cloud -> Settings -> Proxy Agent Access Key
    - **"--spec 9093:192.168.2.183:9093 "** = A spec or target backend service to which you want to connect to. Make sure provide the value in "" to accommodate multiple specs.

 - The outcome of this process will look like something below:
   
   <img width="1025" alt="image" src="https://github.com/mpandav/tibco-cloud-usability/assets/38240734/ae0bcc7a-c5a0-436c-b613-8fac2d58aed0">
- Run the docker image to verify if its configured correctly and working as per the expectation. Use docker RUN command as below,

      docker run -e AGENT_NAME=demo -e AGENT_SPEC="--spec 9093:192.168.2.183:9093 --spec 5150:kafka1.dev.frankfurt.internal.kaas.3stripes.net:5150" mpandav/tibagent:latest
  

  <img width="1728" alt="image" src="https://github.com/mpandav/tibco-cloud-usability/assets/38240734/28b23d0a-984f-44fe-807e-a11b79ef9525">

