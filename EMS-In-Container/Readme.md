# TIBCO Enterprise Messaging Service in Container
The TIBCO Enterprise Message Service™ allows you to send and receive messages from your applications in a format that conforms to the Jakarta Messaging specification (JMS).

Here we will understand how you can deploy or run TIBCO EMS in containerized world (in K8S or OC).

    NOTE : We're using non-default base OS (eclipse-temurin:11-jre-focal) to build the EMS container image; the default base OS is cent:7.

# How to download, build and deploy TIBCO EMS in Container?

Let's understand how to use TIBCO EMS development instance in docker or k8s env. I will be using EMS 10.2.1 for the purpose.

You need to follow the below steps before using TIBCO EMS in environment:

1. Where to find information on how to it?
2. How to build EMS Docker Image with non-default base OS?
3. Deploy the EMS Image to container env (stanalone container, K8S, OC)


Let's see how we can do all these in simple steps:

## 1. Where to find information on how to it?
- Download the below listed files from [TIBCO Community](https://community.tibco.com/s/article/how-configure-tibco-enterprise-message-service-tm-kubernetes-docker)
  - **TIBCO EMS 10 Kubernetes Files.zip**:<br> _It contains the necessary scripts, configuration files and binaries to build a EMS container image and deploy it in any K8S environment._
  - **TIBCO EMS on Kubernetes v1.3.pdf**: :<br> _A document that describes and demonstrate the step-by-step process in the journey._
 
## 2. How to build EMS Docker Image with non-default base OS?

### Select base OS & Identify Package Manager:
- Once you choose which base OS you are planning to use then identify the correct package manager to install required packages needed by EMS instance to RUN
- We are using eclipse-temurin:11-jre-focal as a base OS which is debian based Operating System; so we are using apt package manager

### Update the tibemsfilescreateimage Script 
- Unzip the tibemsd_10.2_files_kubernetes.zip in /tmp/ location
- Look for a script file named tibemsfilescreateimage under directory ../tmp/tibemsd_10.2_files_kubernetes/docker/bin/ and take a good look at the script file to understand the functioning of the same.
- You need to edit/update the Dockerfile Contents (starting at line 192) to change the base-os, installation packages, etc. as below,

        cat > ${DOCKER_BUILD_DIR}/tmp/Dockerfile <<DOCKERFILE
        FROM eclipse-temurin:11-jre-focal
        MAINTAINER TIBCO Software Inc.
        ARG JAVA_DIR
        VOLUME /shared
        EXPOSE 7222
        EXPOSE 7220
        ENTRYPOINT [ "tibems.sh" ]
        CMD []
        WORKDIR /install
        
        RUN mkdir -p /home/user /opt/tibco/ems/docker/{jdbc,security,ftl,rv} /opt/${JAVA_DIR} /shared
        RUN groupadd -g ${GROUP_ID}  tibgroup && useradd -m -d /home/user/tibuser -r -u ${USER_ID} -g tibgroup tibuser
        
        RUN chown -R tibuser:tibgroup /home/user/tibuser /opt/tibco /opt/${JAVA_DIR} /shared /install
        
        ENV EMS_SERVICE_NAME=emsserver
        ENV EMS_NODE_NAME=localhost
        ENV EMS_PUBLIC_PORT=7222
        ENV EMS_PROBE_PORT=7220
        
        
        RUN apt-get update && apt-get --no-install-recommends -y install unzip ssh net-tools \ 
        && apt-get -y install xsltproc && apt-get clean && rm -rf /var/lib/apt/lists/*
        
        COPY --chown=tibuser:tibgroup . /install
        
        USER tibuser
        
        RUN /install/ems_install.sh
        RUN mv /install/*configbase.* /opt/tibco/ems/docker
        RUN mv /install/tibems.sh /opt/tibco/ems/docker
        
        ${install_java_instructions}
        
        RUN rm -rf /install/*
        
        ENV PATH=".:/opt/tibco/ems/${MAJOR_MINOR}/bin:/opt/\${JAVA_DIR}/bin:/opt/tibco/ems/docker:\${PATH}"

- In this tutorial, we are using docker buildx to build the multi-platform docker images. To use docker buildx we need to update the script a bit starting at line 492 as shown below,

        chmod +x ${DOCKER_BUILD_DIR}/tmp/*.sh
  
        [[ "${CREATE_IMAGE_FILE}" = "true" ]] && DOCKER_IMAGE_FILE_NAME=ems-${TAG_NAME}.dockerimage.xz
        docker_image_summary
        
        echo Copying the EMS installation zip file
        cp ${EMS_DOWNLOAD} ${DOCKER_BUILD_DIR}/tmp || die Unable to copy EMS installer
        
        docker buildx build --platform linux/arm64,linux/amd64 ${SQUASH} --build-arg=JAVA_DIR=${JAVA_DIR} -t <repository>/ems:${TAG_NAME} ${DOCKER_BUILD_DIR}/tmp --push || die docker build failed

        # comment below code to use buildx feature
        # docker tag <repository>/ems:${TAG_NAME} ems:latest || die unable to tag docker build

- After above changes our script is now ready for action.

### Build the EMS docker image
- To build the EMS container image, execute the updated the script "**tibemsfilescreateimage**"

        $ ./tibemsfilescreateimage
- This will create and push the docker image to your docker hub repository as shown in below snapshot. You also can verify the build logs for more details...
  ![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/c059039a-b1e7-4623-ae84-6e1face9bb60)

  
## 3. Deploy the EMS Image to container env (stanalone container, K8S, OC)
In this tutorial, we are deploying and starting the EMS container in standalone docker container, but user can refer to deployment configuration files provided in the .zip file under /kubernetes/ for each of the main stream K8S service provider. 

- To start or deploy EMS in standalone container, you need to execute below docker command: 

      docker run -p 7222:7222 -v pwd:/shared <repository>/ems:10.2.1
  We are using volume to store the EMS datastore, configurations and logs in present working directory/shared from where we are running the container. 

# Reference
- A sample [Docker Image](https://hub.docker.com/r/mpandav/ems) for your reference.
