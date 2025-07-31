pipeline {
    agent any

    options {
        // Включает очистку workspace до начала каждой сборки
        cleanWs()
    }

    stages {
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
}
