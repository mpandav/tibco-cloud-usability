# Deploy tibagent in K8S for Hybrid Connectivity

## Authenticate with TIBCO Cloud

     ./tibagent authorize --token CIC~PC7uutpANWTPbd9dROMaolEH 


## Configure tibagent
     ./tibagent configure agent -p 5150 kafkaagent001

## Configure to Hybrid connectivity with AccessKey & Secret 
You need to use accessKey and secret generated from **Proxy Agent access keys** setion.

     ./tibagent configure connect --accessSecret O5whWjnSsoAFSuMUJlMMrpWVlGzatRGnSgcGOb2LQkE  --accessKey mpandav_bw  kafkaagent001
![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/29eeba10-7751-4d2d-987b-7ffae455592b)

## Generate K8S templates and config files
     ./tibagent configure manage kafkaagent001
![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/ed811363-14b5-4d5f-b2ff-a660ac72f777)

## Update tibagent.yaml file
Edit the .yml file for tiagent-main section to add specification or source & targets to be connected.

Ex.     
          env:
                           - name: CMD_OPTIONS
                           value: "--spec 9093:192.168.2.183:9093"
![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/fa686b11-d671-4c09-9183-cf587365224f)


# Apply deployment
    ./tibagent apply manage kafkaagent001  
![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/6acbfd2a-cab5-4294-a4be-1c9e7abdd994)

# Start agent in K8S Cluster
   ./tibagent  -d start agent kafkaagent001    
![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/31d930b1-381e-43d3-971c-1db4a17e8535)
![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/86dd6e21-0657-493b-9087-7f0f8901e3e3)
![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/943c2b13-8f92-4979-9704-92fa78168980)
![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/48297230-c6bd-4c72-bd45-61aa67a5973a)


**NOTE**: You can do the deployment of tibagent in specific namespace as well, pls follow the documentation here: 
https://eu.integration.cloud.tibco.com/docs/index.html#tci/using/hybrid-agent/agent-command-reference.html#configure-manage
