# TIBCO BWCE Monitoring

A build in tool for monitoring the TIBCO BWCE containers deployed in the kubernates or Openshift or docker environment. 

## How to use?

Let's understand how to use BWCEMon application in docker or k8s env. Here I will be using bwce-mon-2.8.2.zip for the purpose.

You need to follow the below steps before using BWCEMon in environment:
1. Download the BWCEMon from official TIBCO download site
2. Build BWCEMon Docker Image
3. Deploy the BWCEMon to container env

Let's see how we can do all these in simple steps:

### 1. Download the BWCEMon from official TIBCO download site 
- Logon to edelivery.tibco.com site
- Look for BusinessWorks Container Edition -> latest version
- Under runtime select the Container -> and download bwce-mon-x.x.x.zip

### 2. Build BWCEMon Docker Image
Once you download the bwce-mon-x.x.x.zip file, we need to cretae the docker image for deployment. You can find the steps documented here in official TIBCO BWCE document: https://docs.tibco.com/pub/bwce/2.8.2/doc/html/Default.htm#bwce-app-monitoring/setting-up-bwce-appl.htm?TocPath=Application%2520Monitoring%2520and%2520Troubleshooting%257CApplication%2520Monitoring%2520Overview%257CApplication%2520Monitoring%2520on%2520Docker%257CSetting%2520Up%2520%2520%2520%2520TIBCO%2520BusinessWorks%2520Container%2520Edition%2520Application%2520Monitoring%2520on%2520Docker%257C_____0 

Follow below steps to build the BWCEMon docker image:
- Extract the bwce_mon-x.x.x.zip 
- Navigate to the bwce_mon directory and build the docker image:

    docker build -t mpandav/bwce-monitoring:282
image.png
- 



### 3. Deploy the BWCEMon to container env