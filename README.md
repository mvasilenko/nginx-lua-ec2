# nginx-lua-ec2

test task - build ec2 instance with html page which updates from commits to github

files description

Dockerfile 
* 1st stage build nginx by shell script build.sh
* 2st stage copy newly built nginx binaries, index.html nginx.conf into fresh ubuntu image

Jenkinsfile stages
* clone repository
* build docker image (Dockerfile)
* test image (auto pass)
* tag docker image and push image to docker hub
* deploy (
  * create docker-machine (if doesn't exist)
  * get current running container id
  * stop current running container
  * run newly built container


build.sh - build nginx latest version + lua module, install to /opt/nginx
nginx.conf - nginx config
index.html - html page

# Jenkins setup
plugins needed - aws credentials, pipeline

Dockerfile.jenkins-with-docker - dockerfile for jenkins with docker, for local builds
ubuntu-docker-install.sh - install latest docker CE and docker-machine, needs to be run inside jenkins, if jenkins was not built with docker


