pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Dania409/example-app'
            }
        }
        stage('Build and Run Docker') {
            steps {
                // Останавливаем и удаляем старые контейнеры (если были)
                sh 'docker-compose down || true'
                // Собираем и запускаем проект в фоне
                sh 'docker-compose up -d --build'
            }
        }
    }
}
