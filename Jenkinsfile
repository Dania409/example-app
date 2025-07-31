pipeline {
    agent any

    stages {
        // Можно добавить степ очистки рабочих каталогов перед checkout
        stage('Cleanup workspace') {
            steps {
                sh 'sudo rm -rf storage bootstrap/cache database || true'
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
            // Сброс прав после билда и работы Docker, чтобы в следующем запуске не было проблем
            sh 'sudo chown -R $(id -u):$(id -g) . || true'
            sh 'chmod -R u+rwX,go+rwX . || true'
        }
    }
}
