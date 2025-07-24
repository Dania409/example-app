pipeline {
    agent any

    environment {
        COMPOSER_CACHE_DIR = "$HOME/.composer"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Dania409/example-app.git'
            }
        }
        stage('Composer Install') {
            steps {
                sh 'docker run --rm -v "$PWD:/app" -v "$COMPOSER_CACHE_DIR:/tmp" -w /app composer:latest composer install'
            }
        }
        stage('Copy .env and Generate Key') {
            steps {
                sh 'cp .env.example .env || true'
                sh 'docker-compose run --rm app php artisan key:generate'
            }
        }
        stage('Storage Permissions') {
            steps {
                sh 'docker-compose run --rm app bash -c "chown -R www-data:www-data storage bootstrap/cache && chmod -R 775 storage bootstrap/cache"'
            }
        }
        stage('Database Permissions') {
            steps {
                sh 'docker-compose run --rm app bash -c "chown -R www-data:www-data database && chmod -R 775 database"'
            }
        }
        stage('Migrate Database') {
            steps {
                sh 'docker-compose run --rm app php artisan migrate --force'
            }
        }
        stage('Run Tests') {
            steps {
                sh 'docker-compose run --rm app php artisan test'
            }
        }
        stage('Up Application') {
            steps {
                sh 'docker-compose down || true'
                sh 'docker-compose up --build -d'
            }
        }
    }

    post {
        success {
            echo '✅ Проект успешно развернут и доступен!'
        }
        failure {
            echo '❌ Ошибка при развертывании. Проверяйте логи.'
        }
    }
}
