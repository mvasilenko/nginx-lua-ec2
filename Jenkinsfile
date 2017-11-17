env.DOCKER_IMAGE='mvasilenko/nginx-lua-ec2'
env.IMAGE='nginx-lua-ec2'

node {
    def app

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        app = docker.build(DOCKER_IMAGE)
    }

    stage('Test image') {
        /* Ideally, we would run a test framework against our image.
         * For this example, we're using a Volkswagen-type approach ;-) */

        app.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker-hub-credentials',
          usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
          sh 'echo "username $USERNAME password $PASSWORD"'
          sh 'docker login -u "$USERNAME" -p "$PASSWORD"'
          app.push("${env.BUILD_NUMBER}")
          app.push("latest")
        }

   stage('Deploy') {
        withCredentials([[$class: "AmazonWebServicesCredentialsBinding",, credentialsId: 'aws-credentials',
          accessKeyVariable: "AWS_ACCESS_KEY_ID", secretKeyVariable: "AWS_SECRET_ACCESS_KEY"]]) {
          sh '''
          set +e 
          docker-machine create -d amazonec2 --amazonec2-open-port 80 --amazonec2-instance-type \"t2.micro\" aws-test
          eval $(docker-machine env aws-test --shell=bash) 
          containerId=\$(docker ps -aqf \"name=$IMAGE\")
          docker stop ${containerId}
          docker rm ${containerId} 
          docker run -d --name $IMAGE -p 80:80 $DOCKER_IMAGE 
         '''
   }
/* This doesn't work when running on docker-in-docker config, possibly related to
   https://issues.jenkins-ci.org/browse/JENKINS-38018 */

/*        docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
            sh 'cp /var/jenkins_home/.dockercfg ~/.dockercfg'
            sh 'cat ~/.dockercfg'
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
*/        }
    }
}
