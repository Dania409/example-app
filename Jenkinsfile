pipeline {
    agent any

    environment {
        COMPOSER_CACHE_DIR = "$HOME/.composer"
    }

    stages {
        stage('Клонирование репозитория') {
            steps {
                git branch: 'master', url: 'https://github.com/Dania409/example-app.git'
            }
        }

        stage('Composer install (Docker)') {
            steps {
                sh 'docker run --rm -v "/var/lib/jenkins/workspace/Daniil pipeline:/app" -v /var/lib/jenkins/.composer:/tmp -w /app composer:latest composer install'
            }
        }

        stage('Копия .env и генерация ключа Laravel') {
            steps {
                sh 'cp .env.example .env || true'
                sh 'docker-compose run --rm app php artisan key:generate'
            }
        }

        stage('Права на storage и cache') {
            steps {
                sh 'docker-compose run --rm app bash -c "chown -R www-data:www-data storage bootstrap/cache && chmod -R 775 storage bootstrap/cache"'
            }
        }

        stage('Миграции') {
            steps {
                sh 'docker-compose run --rm app php artisan migrate --force'
            }
        }

        stage('Тесты') {
            steps {
                sh 'docker-compose run --rm app php artisan test'
            }
        }

        stage('Сборка и запуск приложения') {
            steps {
                sh 'docker-compose down'
                sh 'docker-compose up --build -d'
            }
        }
    }

    post {
        success {
            echo '✅ Проект успешно собран, протестирован и запущен через docker-compose!'
        }
        failure {
            echo '❌ Ошибка на этапе сборки или запуска!'
        }
    }
}
