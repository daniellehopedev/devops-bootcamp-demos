# Module 8 - Build Automation & CI/CD with Jenkins

### Demo Project:
Configure Webhook to trigger CI Pipeline automatically on every change

### Technologies Used:
Jenkins, GitHub, Git, Docker, Java, Maven

### Project Objectives:
- Configure Jenkins to trigger the CI pipeline, whenever a change is pushed to GitHub
---
### Configure Jenkins to Automatically Trigger the CI Pipeline
- if using GitHub
    - in the Configure settings of your Pipeline job, select 'GitHub hook trigger for GITScm Polling' in the 'Build Triggers' section
    - in the GitHub repo for your project, go to 'Settings'
        - go to 'Webhooks' > 'Add Webhook'
        - Payload URL = Jenkins URL + '/github-webhook/'
        - Content Type = application/json
        - Secret = optional
        - Which events? = Just the Push event (may select others if needed)
    - for Multibranch Pipeline, install the 'Multibranch Scan Webhook Trigger' plugin in Jenkins
        - select one of the branches in the multibranch pipeline and go to 'Configure'
        - a new option 'Scan by Webhook' will show under the 'Scan Multibranch Pipeline Triggers' section
        - add a Trigger token (can be named to your liking), this will be used for communication between GitHub and Jenkins
        - then in github, do the same steps as above for adding a webhook
            - this time the Payload URL will be what is given in the section where you declare the Trigger token in Jenkins (may have to click the question mark)
- if using GitLab
    - install the Gitlab plugin in Jenkins
    - go to 'Manage Jenkins' > 'Configure System', should now see a newly added Gitlab section
    - make sure 'Enable Authentication for '/project' end-point' is checked
    - configure gitlab connections
        - enter connection name
        - enter the gitlab host url: https://gitlab.com/
        - add an api token
            - for 'Kind', choose 'Gitlab API token' (this is the Personal Access token configured in the settings from Gitlab)
    - in your pipeline job, there will now be a gitlab connection section (this is from the plugin)
    - configure build triggers in the 'Build Triggers' section
        - select the 'Build when a change is pushed to gitlab...' option
    - configure gitlab to send a notification to jenkins when a push or commit happens
        - in gitlab, got to 'Settings' > 'Integrations' > select 'Jenkins CI'
            - add the jenkins url (webhook url), enter jenkins username and password
    - for multibranch pipeline configuration, the setup will be the same as the above for github
---
---
### Demo Project:
Dynamically Increment Application version in Jenkins Pipeline

### Technologies Used:
Jenkins, Docker, GitHub, Git, Java, Maven

### Project Objectives:
- Configure CI step: Increment patch version
- Configure CI step: Build Java application and clean old artifacts
- Configure CI step: Build Image with dynamic Docker Image Tag
- Configure CI step: Push Image to private Docker Hub repository
- Configure CI step: Commit version update of Jenkins back to Git repository
- Configure Jenkins pipepline to not trigger automatically on CI build commit to avoid commit loop
---
### Configure CI step: Increment patch version
1. create a jenkinsfile (will not be using the jenkins-shared-library here)
2. add a 'increment version' stage
    - make sure the version increment stage is done before the stage for packaging the app so we have the correct version when building the app
3. mvn build-helper command will be used to in this step
```
sh 'mvn build-helper:parse-version versions:set \
    -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} 
    versions:commit'
```

### Configure CI step: Build Java app and clean old artifacts
1. to clean the target folder during the build step, use this command: `mvn clean package`
    - using just `mvn package` will just create new jar files in the target folder
    - the problem with just using `mvn package` is that there will be multiple jars in the target folder and the COPY command in the Dockerfile will need to reference the correct jar
    - in this case since we are using '*' to match the jar file and it will match all of the jar files, so we want to 'clean' so we just have one single jar file

### Configure CI step: Build image with dynamic Docker Image tag
1. get the version from the java application pom file to tag the docker image with
2. create $IMAGE_NAME variable, instead of hard coding the version
3. access the version by reading the pom file with readFile() method
```
def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
def version = matcher[0][1] //grabs the version tag from the pom and gets the version number in between the tags
env.IMAGE_NAME = "$version-$BUILD_NUMBER" //BUILD_NUMBER is an environment variable that holds the build number from the jenkins pipeline
// append the BUILD_NUMBER to the version, to have a unique tag related to the pipeline
```
4. update the Dockerfile
    - change the COPY command, if needed, so that you are handling the changing version number when the jar is built, and the jar file name can be found
    - don't use the hardcoded jar file name, needs to be dynamic
    - Dockerfile example: https://github.com/daniellehopedev/java-maven-app/blob/feature/jenkins-jobs-webhook/Dockerfile

### Configure CI step: Push Image to private Docker Hub repository
1. the build image step will have the docker push comand
2. as usual, use the withCredentials() method to do the docker login and build and push the image to docker hub

### Configure CI step: Commit version update of Jenkins back to Git repository
1. need to allow jenkins to commit the version bump that it executed locally and push it back to the git repo
2. in jenkinsfile, add a 'commit version update' stage, so jenkins can update the pom file with the version bump
3. install SSH Agent plugin in jenkins to push via ssh
    - configure your ssh credentials from gitlab or github
4. or just use withCredentials method if using https with gitlab
```
stage('commit version update') {
    steps {
        script {
            //https
            withCredentials([usernamePassword(credentialsId: 'github-credentials', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                // git config here for the first time run
                sh 'git config --global user.email "jenkins@example.com"'
                sh 'git config --global user.name "jenkins"'

                sh "git remote set-url origin https://${USER}:${PASS}@github.com:daniellehopedev/java-maven-app.git"
                sh 'git add .'
                sh 'git commit -m "ci: version bump"'
                sh 'git push origin HEAD:feature/jenkins-jobs'
            }
        }
    }
}

stage('commit version update') {
    steps {
        script {
            //ssh
            sshagent(['github-ssh-credentials']) {
                sh "git remote set-url origin git@github.com:daniellehopedev/java-maven-app.git"
                sh 'git add .'
                sh 'git commit -m "ci: version bump"'
                sh 'git push origin HEAD:feature/jenkins-jobs-webhook'
            }
        }
    }
}
```

### Avoid commit loop by ignoring the push made by Jenkins in the pipeline
1. in jenkins, install a plugin, Ignore Committer Strategy
2. on your pipeline go to Configure > Branch Sources
    - under the Branch Sources section, there will be a new Build Strategies section that was added from the plugin
    - select Ignore Committer Strategy
        - enter the email address configure for jenkins in the git config (look at the commit version update step)
        - check 'Allow builds when a changeset contains non-ignored author(s)'
3. Save! (the pipeline trigger should now be ignoring commits made by jenkins)

Final Jenkinsfile: https://github.com/daniellehopedev/java-maven-app/blob/feature/jenkins-jobs-webhook/Jenkinsfile