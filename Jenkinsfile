pipeline {
    agent any

    stages {
        stage('Workspace cleanup') {
            steps {
                sh 'rm -rf * .[^.]* || true'
            }
        }
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Dania409/example-app'
            }
        }
        stage('Build and Run Docker') {
            steps {
                sh 'docker-compose down || true'
                sh 'docker-compose up -d --build'
            }
        }
    }
    post {
        always {
            sh 'chmod -R u+rwX,go+rwX . || true'
        }
    }
}pipeline {
    agent any

    stages {
        stage('Workspace cleanup') {
            steps {
                sh 'rm -rf * .[^.]* || true'
            }
        }
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Dania409/example-app'
            }
        }
        stage('Build and Run Docker') {
            steps {
                sh 'docker-compose down || true'
                sh 'docker-compose up -d --build'
            }
        }
    }
    post {
        always {
            sh 'chmod -R u+rwX,go+rwX . || true'
        }
    }
}
