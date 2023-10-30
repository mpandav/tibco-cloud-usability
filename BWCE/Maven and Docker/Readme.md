# Running BWCE Apps in Docker using Maven pluing

## Frequestky Occurred Errors 
1. ERROR WHILE RUNNING APP FROM MAVEN  													

	 [ERROR] DOCKER> Error getting the credentials for https://index.docker.io/v1/ from the configured credential helper [Failed to start 'docker-credential-osxkeychain get' : Cannot run program "docker-credential-osxkeychain"

	 SOLUTION:  Check your ~/.docker/config.json and replace "credsStore" by "credStore" dckr_pat_XMxSgfmzGnIjkoMa0c-2Y95D_vM


2. ERROR: WHILE PUSH IMAGE TO DOCKERHUB REGISTRY
 
 	 [ERROR] DOCKER> Unable to push '' : denied: requested access to the resource is denied  [denied: requested access to the resource is denied ] 
 
	 SOLUTION: To use DockerHub as a docker registry use personal access token instead User/Password auth mechanism

