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
            }
        }
        stage('Prepare Environment') {
            steps {
                sh 'cp .env.example .env || true'
                sh 'php artisan key:generate'
            }
        }
        // Этот этап опционален, уберите если не нужны тесты:
        // stage('Test') {
        //     steps {
        //         sh './vendor/bin/phpunit'
        //     }
        // }
        stage('Deploy') {
            steps {
                echo 'Deploy step: добавьте ваш скрипт деплоя/копирования файлов'
            }
        }
    }
}
