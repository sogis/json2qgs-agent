Json2qgs Agent
=======================

Jenkins Agent with included json2qgs. Json2qgs generates QGIS project files from config files 

For all necessary informations about json2qgs have a look at https://github.com/sogis/json2qgs


Integration in AGI environment
------------------------------

Adapt Dockerfile for use of json2qgs in a jenkins agent.

Create an example secret for a pg_service file from a local pg_service file with

    oc create secret generic config-generator-agent-pg-service-gdi-test --from-file=pg_service.conf -n agi-apps-test

Templates for the pg_service Secrets are also stored under H:\BJSVW\Agi\GDI\Betrieb\Openshift\Pipelines\secret-config-generator-agent-pg-service-gdi-xxx.yaml. Download the secret templates to your local machine and create with

    oc create -f secret-config-generator-agent-pg-service-gdi-test.yaml
    oc create -f secret-config-generator-agent-pg-service-gdi-integration.yaml
    oc create -f secret-config-generator-agent-pg-service-gdi-production.yaml

Every GDI environment needs a different pg_service File in the config-generator because the config-generator needs to connect to the right DBs.

##### From here use these steps also for updating config-generator-agent to a newer version

Build the config-generator-agent Image (!!Image works only if used as a slave in Jenkins!!) => Change Tag if needed

    docker build -t sogis/config-generator-agent:latest .

Tag Image to push in sogis Repo => change Tag if needed

    docker push sogis/config-generator-agent:latest

Update ImageStream in Openshift (to version 1.20 in Int and Prod Environment. Test Environment always uses latest Image which is scheduled)

    oc project agi-apps-test

    oc tag --source=docker sogis/config-generator-agent:1.20 config-generator-agent:1.20

Update configMap for the config-generator-agent in Jenkins (to Image Version 1.20)

    git clone https://github.com/sogis/pipelines.git
    
    cd pipelines/api_webgisclient

    oc process -f template-configGenAgent.yaml -p PROJECTNAME=agi-apps-test -p IMAGE_TAG_AGENT=1.20 | oc apply -n agi-apps-test -f-  
