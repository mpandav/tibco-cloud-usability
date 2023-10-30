# Run tibagent in Dokcker Container for Hybrid Connectivity

## Steps to build a Docker Image
- Download and exact the .zip into /tmp directory
- Follow the step 1 and 2 documented here in TIBCO Support KA : https://support.tibco.com/s/article/Running-Hybrid-Agent-in-a-docker-container
- Run a build-agent.sh to build a docker image

       ./build-agent.sh demoagent 7888  CIC~PC7uutpANWTPbd9dROMaolEH O5whWjnSsoAFSuMUJlMMrpWVlGzatRGnSgcGOb2LQkE mpandav_bw "--spec 9093:192.168.2.183:9093 --spec 5150:kafka1.dev.frankfurt.internal.kaas.3stripes.net:5150"

  - **demoagent** = Agent Name (provide any name of your choice)
  - **7888** = Management port for tibagent to communicate (select as per your chouice, default is 7818)
  - **CIC~xxxx** = Access Token to login into TIBCO Cloud (Its OAuth token generated from the TIBCO Cloud)
  - **O5whWxnxx** = Access Secret to create tibagent tunnel to connect backend OnPrem services. It will be created from TIBCO Cloud -> Settings -> Proxy Agent Access Key
  - **mpandav_bw**  = It is name of your Access Key created from TIBCO Cloud -> Settings -> Proxy Agent Access Key
  - "--spec 9093:192.168.2.183:9093 --spec 5150:kafka1.dev.frankfurt.internal.kaas.3stripes.net:5150" = A spec or target backend service to which you want to connect to. Make sure provide the value in "" to accommodate multiple specs.

    ![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/767e8397-f968-4f54-a110-b2b2c50e50ef)

- It will create the docker image with name

         tibagent/<AgentName>:latest
  Example.
         tibagent/demoagent:latest

  ![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/b1defcf7-c655-4954-84dd-10929193929c)

## Run the tibagent in Docker Container

- Create the Container out of generated Docker Image

  ![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/2d108564-407f-42b2-8c2f-f6a317c769c4)
