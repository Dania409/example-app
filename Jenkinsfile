pipeline {
    agent any

    environment {
        // Вы можете добавить нужные переменные окружения
    }

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
        // Если нужен деплой — добавьте соответствующий шаг
        //stage('Deploy') {
        //    steps {
        //        // Ваши команды деплоя
        //    }
        //}
    }
    post {
        failure {
            echo 'Pipeline failed.'
        }
    }
}
    
