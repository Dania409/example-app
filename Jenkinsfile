pipeline {
    agent any

    environment {
        COMPOSER_CACHE_DIR = "$HOME/.composer"
    }

    stages {
        stage('Clone') {
            steps {
                git url: 'https://github.com/Dania409/example-app.git'
            }
        }

        stage('Composer Install') {
            steps {
                sh 'docker run --rm -v "/var/lib/jenkins/workspace/Daniil pipeline:/app" -v /var/lib/jenkins/.composer:/tmp -w /app composer:latest composer install'
            }
        }

        stage('Copy .env & Generate Key') {
            steps {
                sh 'cp .env.example .env || true'
                sh 'docker-compose run --rm app php artisan key:generate'
            }
        }

        // ✅ Новый шаг: исправление прав на storage
        stage('Fix Permissions') {
            steps {
                sh 'sudo chown -R www-data:www-data storage bootstrap/cache'
                sh 'sudo chmod -R 775 storage bootstrap/cache'
            }
        }

        stage('Run Migrations') {
            steps {
                sh 'docker-compose run --rm app php artisan migrate --force'
            }
        }

        stage('Run Laravel Tests') {
            steps {
                sh 'docker-compose run --rm app php artisan test'
            }
        }

        stage('Build & Up') {
            steps {
                sh 'docker-compose down'
                sh 'docker-compose up --build -d'
            }
        }
    }

    post {
        success {
            echo "✅ Успешно собрано и поднято!"
        }
        failure {
            echo "❌ Ошибка при сборке!"
        }
    }
}
