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
        stage('Docker Compose Up') {
            steps {
                sh 'docker-compose pull'
                sh 'docker-compose up -d'
            }
        }
        stage('Composer Install & Key Generate') {
            steps {
                sh 'docker-compose exec -T app composer install'
                sh 'docker-compose exec -T app php artisan key:generate'
            }
        }
        stage('Migrate DB') {
            steps {
                sh 'docker-compose exec -T app php artisan migrate'
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
            sh 'docker-compose ps'
        }
        cleanup {
            sh 'docker-compose down -v'
        }
    }
}
