Json2qgs Agent
=======================

Jenkins Agent with included json2qgs. Json2qgs generates QGIS project files from json config files 

For all necessary informations about json2qgs have a look at https://github.com/sogis/json2qgs


Integration in AGI environment
------------------------------

##### Use these steps also for updating json2qgs-agent to a newer version

Build the json2qgs-agent Image (!!Image works only if used as a slave in Jenkins!!) => Change Tag if needed

    docker build -t sogis/json2qgs-agent:latest .

Tag Image to push in sogis Repo => change Tag if needed

    docker push sogis/json2qgs-agent:latest

Update ImageStream in Openshift (to version 1.1 in Int and Prod Environment. Test Environment always uses latest Image which is scheduled)

    oc project agi-apps-test

    oc tag --source=docker sogis/json2qgs-agent:1.1 json2qgs-agent:1.1

Update configMap for the config-generator-agent in Jenkins (to Image Version 1.1)

    git clone https://github.com/sogis/pipelines.git
    
    cd pipelines/api_webgisclient

    oc process -f template-configGenAgent.yaml -p PROJECTNAME=agi-apps-test -p IMAGE_TAG_AGENT=1.1 | oc apply -n agi-apps-test -f-  
