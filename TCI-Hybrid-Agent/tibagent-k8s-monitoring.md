# Deploy tibagent in K8S Cluster to Manage and Monitor the local apps

### **API Access Key** 
For DB service and hybrid connectivity in Flogo tester<br><br>
Name: mpandav<br>
Value: 0sIC3+vWOXCO11y9eFfqnKb1Q9tirsZG3hRqG6HtY3s

### **Oauth Token**
For authorization of the tibagent with TIBCO Cloud<br><br>
Name: tibagent_demo<br>
Value: CIC~GxDa5Ad3E7Xgt97rxjJY1oiL


## 1. Login
mpandav@mpandav-m1 TCI % ./tibagent_latest authorize <br>
AccessToken: CIC~GxDa5Ad3E7Xgt97rxjJY1oiL
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
