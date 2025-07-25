pipeline {
    agent any
    environment {
        COMPOSE_FILE = 'docker-compose.yml'
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Dania409/example-app.git'
            }
        }
        stage('Copy .env') {
            steps {
                script {
                    if (!fileExists('.env')) {
                        sh 'cp .env.example .env'
                    }
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker-compose build'
            }
        }
        stage('Start Services') {
            steps {
                sh 'docker-compose pull'
                sh 'docker-compose up -d'
            }
        }
        stage('Wait for MySQL') {
            steps {
                sh 'sleep 15'
                // или вместо sleep можно использовать скрипт ожидания, например wait-for-it
            }
        }
        stage('Set Permissions') {
            steps {
                sh 'docker-compose exec -T app chmod -R 775 storage bootstrap/cache'
            }
        }
        stage('Artisan Key Generate') {
            steps {
                sh 'docker-compose exec -T app php artisan key:generate'
            }
        }
        stage('Migrate DB') {
            steps {
                sh 'docker-compose exec -T app php artisan migrate --force'
            }
        }
        stage('Test') {
            steps {
                sh 'docker-compose exec -T app php artisan test --env=testing'
            }
        }
    }
    post {
        always {
            // Эти команды будут выполняться В ЛЮБОМ случае — после сборки независимо от результата
            sh 'docker-compose ps'
            sh 'docker-compose down -v'
        }
        // Можно добавить и другие дефолтные блоки:
        // success { ... }
        // failure { ... }
        // unstable { ... }
        // changed { ... }
    }
}
