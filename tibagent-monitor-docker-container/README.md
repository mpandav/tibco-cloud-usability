# How to monitor BWCE app running in Local Docker Container in TCI

Monitor a container running app from TCI control pane.

## Steps to setup tibagent at onPrem
Follow below steps to create and configure the tibagent process. This will run and allow all the process trying connect and also allow all the TCI deplyoed applications using configured key to connect to all the onPrem resources (DB, IT Systems, etc.)

### 1. Login to TIBCO Cloud
mpandav@mpandav-m1 TCI % ./tibagent_latest authorize --token CIC~Gxxxxxx                                                           
You've successfully logged into organization: " SC-DACH eu-west-1 " 
mpandav@mpandav-m1 TCI % 

### 2. Configure tibagent 
mpandav@mpandav-m1 TCI % ./tibagent_latest configure agent -p 5151 agent002              
Configuring agent [DONE]                 
Agent 'agent002' was configured

### 3. Create connect profile with accessKey and secretKey
Start the agent with accessKey and secretKey so any application using this Key will be able to connect with onPrem and all the application connecting to this Host & configure port will be visible in TIBCO Cloud.<br/>
mpandav@mpandav-m1 TCI % ./tibagent_latest configure connect --accessSecret 0sIC3+xxxxxx --accessKey mpandav agent002                       
Configuring connect [DONE]                 
Connect 'agent002' was configured

### 4. Start the configure agent
mpandav@mpandav-m1 TCI % ./tibagent_latest start agent agent002                                                                         
May 16 19:30:24 192.168.2.183 [a:tibagent:a][52058]: {"timestamp":1684258224,"time":"2023-05-16T19:30:24.578Z","level":"INFO","app":"tibagent","message":"Server port: 5151"}
May 16 19:30:25 192.168.2.183 [a:tibagent:a][20]: {"timestamp":1684258225,"time":"2023-05-16T19:30:25.576Z","level":"INFO","app":"tibagent","message":"Agent version=1.7.0 build=1361 tibtunnel version=2.44.0"}
May 16 19:30:25 192.168.2.183 [a:tibagent:a][20]: {"timestamp":1684258225,"time":"2023-05-16T19:30:25.577Z","level":"DEBUG","app":"tibagent","message":"Agent started with data-ack-mode=true"}
May 16 19:30:25 192.168.2.183 [a:tibagent:a][20]: {"timestamp":1684258225,"time":"2023-05-16T19:30:25.577Z","level":"DEBUG","app":"tibagent","message":"Agent started with data-chunk-size=32KB"}
May 16 19:30:25 192.168.2.183 [a:tibagent:a][20]: {"timestamp":1684258225,"time":"2023-05-16T19:30:25.577Z","level":"INFO","app":"tibagent","message":"Agent 'agent002' started on port '5151' successfully."}
May 16 19:30:25 192.168.2.183 [a:tibtunnel:a][52058]: {"timestamp":1684258225,"time":"2023-05-16T19:30:25.619Z","level":"INFO","app":"tibtunnel","message":"tibtunnel(ad81821dd3e9): (TT) client connected"}
May 16 19:30:25 192.168.2.183 [a:tibtunnel:a][52058]: {"timestamp":1684258225,"time":"2023-05-16T19:30:25.619Z","level":"INFO","app":"tibtunnel","message":"tibtunnel(ad81821dd3e9): (T) tunnel created (WS connection)"}
May 16 19:30:25 192.168.2.183 [a:tibtunnel:a][52058]: {"timestamp":1684258225,"time":"2023-05-16T19:30:25.619Z","level":"INFO","app":"tibtunnel","message":"tibtunnel(ad81821dd3e9): Changed log level to 'info'"}
May 16 19:30:25 192.168.2.183 [a:tibtunnel:a][52058]: {"timestamp":1684258225,"time":"2023-05-16T19:30:25.619Z","level":"INFO","app":"tibtunnel","message":"tibtunnel(ad81821dd3e9): (M) set data chunk size to '32768'"}
May 16 19:30:25 192.168.2.183 [a:tibtunnel:a][52058]: {"timestamp":1684258225,"time":"2023-05-16T19:30:25.619Z","level":"INFO","app":"tibtunnel","message":"tibtunnel(ad81821dd3e9): (M) set data ack mode to 'true'"}
May 16 19:30:25 192.168.2.183 [a:tibtunnel:a][52058]: {"timestamp":1684258225,"time":"2023-05-16T19:30:25.620Z","level":"INFO","app":"tibtunnel","message":"tibtunnel(ad81821dd3e9): (M) negotiated protocol: v3"}
192.168.2.183 [a:tibagent:a][20]: {"timestamp":1684258225,"time":"2023-05-16T19:30:25.577Z","level":"DEBUG","app":"tibagent","message":"Agent started with data-chunk-size=32KB"}
May 16 19:30:25 192.168.2.183
![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/fa79b6f8-abad-4ff8-90ae-54e31f7b9f8e)

## Steps to follow from BWCE Application
Follow below outlined steps to connect bwce app docker container to running tibagent so it will be available to TIBCO cloud for monitoring
### Environent Varibale
You need to set below set of environment variable for hybrid agent in your BWCE application

TCI_HYBRID_AGENT_HOST : This hybrid agent host to be specified at time of application startup.
TCI_HYBRID_AGENT_PORT: This hybrid agent port to be specified at time of application startup.
HYBRID_AGENT_REGISTER_ATTEMPTS : default 10
HYBRID_AGENT_REGISTER_DELAY: default 10000 ms

### Deploy aplication

docker run -e TCI_HYBRID_AGENT_HOST="10.97.98.107"  -e TCI_HYBRID_AGENT_PORT="7816" -e BW_LOGLEVEL="INFO" repo/image:version
  
  ![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/52222734-cec6-42a6-9157-c1869798d252)
  
##  TIBCO Cloud Control Pane
  ![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/33187d5c-3cc2-4db7-8a9f-f3559b72f5b4)

