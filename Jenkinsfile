pipeline {
    agent any

    stages {
        stage('Fix Permissions') {
            steps {
                // Исправить владельца и права на все файлы, чтобы избежать проблем при git checkout
                sh 'sudo chown -R $(id -u):$(id -g) . || true'
                sh 'chmod -R u+rwX,go+rwX . || true'
            }
        }
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Dania409/example-app'
            }
        }
        // Следующий этап можно добавить для уверенности,
        // что после обновления кода права на storage и cache опять корректны
        stage('Fix Laravel Folders Permissions') {
            steps {
                sh 'sudo chown -R $(id -u):$(id -g) storage bootstrap/cache database || true'
                sh 'chmod -R u+rwX,go+rwX storage bootstrap/cache database || true'
            }
        }
        stage('Build and Run Docker') {
            steps {
                // Остановить и удалить старые контейнеры, если были
                sh 'docker-compose down || true'
                // Собрать и запустить всё заново
                sh 'docker-compose up -d --build'
            }
        }
    }
}
