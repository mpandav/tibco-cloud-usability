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
- Look for a script file named tibemsfilescreateimage under directory ../tibemsd_10.2_files_kubernetes/docker/bin/ and take a good look at the script file to understand the functioning of the same.
- 
### Build the EMS docker image
-
- 
## 3. Deploy the EMS Image to container env (stanalone container, K8S, OC)

# Reference
- [Docker Image](https://hub.docker.com/r/mpandav/ems) for reference.
