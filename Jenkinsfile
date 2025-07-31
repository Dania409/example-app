pipeline {
    agent any

    stages {
        // Работает только если не используется автоматическая очистка (Clean Workspace) в настройках job
        stage('Pre-cleanup') {
            steps {
                sh 'rm -rf storage bootstrap/cache database || true'
            }
        }
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Dania409/example-app'
            }
        }
        stage('Build and Run via Docker Compose') {
            steps {
                // Остановит и удалит старые контейнеры, если есть
                sh 'docker-compose down || true'
                // Соберёт и запустит сервисы в фоновом режиме
                sh 'docker-compose up -d --build'
            }
        }
    }
    post {
        always {
            // Восстанавливаем права на файлы после сборки, чтобы не возникало проблем при следующих билдах
            sh 'chmod -R u+rwX,go+rwX . || true'
        }
    }
}
