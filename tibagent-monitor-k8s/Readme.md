# Deploy tibagent in K8S Cluster to Manage and Monitor the local apps

### **API Access Key** 
For DB service and hybrid connectivity in Flogo tester<br><br>
Name: mpandav<br>
Value: 0sIC3+xxxx

### **Oauth Token**
For authorization of the tibagent with TIBCO Cloud<br><br>
Name: tibagent_demo<br>
Value: CIC~xxxxx


## 1. Login
mpandav@mpandav-m1 TCI % ./tibagent_latest authorize <br>
AccessToken: CIC~xxxx
You've successfully logged into organization: " SC-DACH eu-west-1 " 

## 2. Configure Agent
mpandav@mpandav-m1 TCI % ./tibagent_latest configure agent --config-dir /Users/mpandav/tmp/working/tibagnet-k8s/ -p 5150 agent001<br>
Configuring agent [DONE]                 
Agent 'agent001' was configured
mpandav@mpandav-m1 TCI % 

## 3. Gernerate K8S config templates files
mpandav@mpandav-m1 TCI % ./tibagent_latest configure manage --config-dir /Users/mpandav/tmp/working/tibagnet-k8s/ agent001    <br>   
Configuring manage file  [DONE]                 
Generating k8s templates  [DONE]                 
Downloading tibagent-main  [DONE]                 
✓ New tibagent-main is downloaded
Downloading tibagentx-k8s  [DONE]                 
✓ New tibagentx-k8s is downloaded
Review K8s deployment configuration generated for hybrid agent 'agent001' at '/Users/mpandav/tmp/working/tibagnet-k8s/agents/agent001' and change it as per your cluster configuration.
mpandav@mpandav-m1 TCI % 

## 4.  Create k8s resources
mpandav@mpandav-m1 TCI % ./tibagent_latest -d  apply manage --config-dir /Users/mpandav/tmp/working/tibagnet-k8s/ agent001<br><br>    
May 16 17:59:50 192.168.2.183 [a:tibagent:a][49349]: {"timestamp":1684252790,"time":"2023-05-16T17:59:50.236Z","level":"DEBUG","app":"tibagent","message":"Validate tibagent version and check login..."}
May 16 17:59:50 192.168.2.183 [a:tibagent:a][49349]: {"timestamp":1684252790,"time":"2023-05-16T17:59:50.240Z","level":"DEBUG","app":"tibagent","message":"tccURL to GET PlatformVersion: https://eu.integration.cloud.tibco.com/platformapiversion"}
May 16 17:59:50 192.168.2.183 [a:tibagent:a][49349]: {"timestamp":1684252790,"time":"2023-05-16T17:59:50.430Z","level":"DEBUG","app":"tibagent","message":"PlatformApiVersion received from 'https://eu.integration.cloud.tibco.com/platformapiversion': 2.0.0"}
May 16 17:59:50 192.168.2.183 [a:tibagent:a][49349]: {"timestamp":1684252790,"time":"2023-05-16T17:59:50.430Z","level":"DEBUG","app":"tibagent","message":"platformApiVersion: '2.0.0' cliVersion: '2.12.0'"}
Applying resources  [DONE]                 
persistentvolume/tibagent-pv created
persistentvolumeclaim/tibagent-pvc created
serviceaccount/tibagent-sa created
role.rbac.authorization.k8s.io/tibagent-role created
rolebinding.rbac.authorization.k8s.io/tibagent-role-bind created
Running scripts  [DONE]     

## 5. Create k8s Deployment
mpandav@mpandav-m1 TCI % ./tibagent_latest -d start agent agent001<br><br>
Starting tibagent 'tibagent-agent001' on k8s [namespace: default]
service/tibagent-service-agent001 unchanged
deployment.apps/tibagent-agent001 created
mpandav@mpandav-m1 TCI % 

![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/3614ba50-6e8f-4812-ae61-0f10d0ca24d0)

![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/060715a2-9fe4-4f32-af81-34c3cbd8976d)

![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/1ce2af4a-dd3b-4478-8f88-a3b37806881d)

## TIBCO Cloud Control Pane
See how it looks after applying the config to the k8s cluster.

![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/4611d07c-0928-4872-9d2e-77fe34ceb996)

![image](https://github.com/mpandav/tibco-cloud-usability/assets/38240734/93f70365-6f9c-49ea-a937-f103f2a58f18)



