pipeline {
    agent any

    // Enable ONE trigger at a time if you want to compare trigger types.
    // For GitHub webhook: configure the GitHub plugin and enable the job's
    // "GitHub hook trigger for GITScm polling" option in Jenkins.
    // For Poll SCM: uncomment the cron line below.
    // For scheduled execution: use a cron expression such as H 9 * * 1-5.
    triggers {
    pollSCM('H/2 * * * *')
    // cron('H 9 * * 1-5')
}

    environment {
        IMAGE_NAME = 'triggerflow-web'
        CONTAINER_NAME = 'triggerflow-web'
        HOST_PORT = '8081'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo 'Source code checked out successfully.'
            }
        }

        stage('Validate Project Files') {
            steps {
                sh '''
                    test -f index.html
                    test -f style.css
                    test -f Dockerfile
                    echo "Required project files are present."
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .'
                sh 'docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${IMAGE_NAME}:latest'
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    docker rm -f ${CONTAINER_NAME} || true
                    docker run -d --name ${CONTAINER_NAME} \
                      --restart unless-stopped -p ${HOST_PORT}:80 \
                      ${IMAGE_NAME}:${BUILD_NUMBER}
                '''
            }
        }

        stage('Smoke Test') {
            steps {
                sh '''
                    for i in 1 2 3 4 5; do
                      if curl --fail --silent http://localhost:${HOST_PORT}/ > /tmp/triggerflow.html; then
                        grep -q "TriggerFlow" /tmp/triggerflow.html
                        echo "Smoke test passed."
                        exit 0
                      fi
                      sleep 2
                    done
                    echo "Smoke test failed."
                    exit 1
                '''
            }
        }
    }

    post {
        success {
            echo "TriggerFlow deployed successfully at http://localhost:8081"
        }
        failure {
            echo 'Pipeline failed. Check the Console Output for the failing stage.'
        }
        always {
            echo "Build number: ${BUILD_NUMBER}"
        }
    }
}
