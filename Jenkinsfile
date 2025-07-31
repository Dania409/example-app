pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Dania409/example-app'
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'composer install --no-interaction --prefer-dist'
                sh 'cp .env.example .env || true'
                sh 'php artisan key:generate'
            }
        }
        stage('Run Tests') {
            steps {
                sh 'php artisan test || vendor/bin/phpunit'
            }
        }
        // Можно добавить стадию деплоя при необходимости
    }
    post {
        failure {
            echo 'Pipeline failed.'
        }
    }
}
      
    
