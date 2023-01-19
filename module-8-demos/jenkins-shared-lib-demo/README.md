# Module 8 - Build Automation & CI/CD with Jenkins

### Demo Project:
Create a Jenkins Shared Library

### Technologies Used:
Jenkins, Groovy, Docker, Git, Java, Maven

### Project Objectives:
- Create a Jenkins Shared Library to extract common build logic:
    - Create separate Git repository for Jenkins Shared Library project
    - Create functions in the JSL to use in the Jenkins pipeline
    - Integrate and use the JSL in Jenkins Pipeline (globally and for a specific project in Jenkinsfile)
---
### Create Jenkins Shared Library
1. create a new git repository for jenkins shared library project
    - the jenkins shared library is an extension to the pipeline
    - the project will be written in groovy
    - will reference logic from the shared library in a jenkinsfile
2. create a new groovy project that will have the functions for the shared library
    - folder structure
        - vars folder: the main folder
            - will have the functions that are called from the jenkinsfile
            - each function/step execution has its own groovy file
        - src folder: helper code
        - resources folder
            - where you can use external libraries or scripts
            - for non-groovy files
3. integrate and use the shared library in your jenkins pipeline
    - in jenkins go to 'Manage Jenkins' > 'Configure System' > 'Global Pipeline Libraries'
    - enter a name
    - enter a default version (best practice is to version it, so you have a fixed version)
    - check 'Allow default version to be overridden'
    - for 'Retrieval Method' select 'Modern SCM'
        - select 'Git' and add the information for your shared library repo
    - save it
    - make sure to update the jenkinsfile to use the functions from the shared library
4. for global use, configure the library in 'Global Pipeline Libraries' as described above.
    - make sure to use the @Library('name-of-shared-library>') annotation at the top of your jenkinsfile
5. for use in a specific project, make sure to remove the shared library from 'Global Pipeline Libraries' configuration
    - in your jenkinsfile reference the library directly using the library identifier method
6. jenkinsfile with both examples: https://github.com/daniellehopedev/java-maven-app/blob/feature/jenkins-shared-lib/Jenkinsfile