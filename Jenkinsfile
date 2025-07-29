pipeline {
    agent any

    environment {
        COMPOSER_CACHE_DIR = "$HOME/.composer"
    }

    stages {
        stage('Fix workspace permissions before checkout') {
            steps {
                // Если у Jenkins нет sudo — эту часть можно убрать, а права выдать вручную
                sh 'sudo chown -R jenkins:jenkins $WORKSPACE || true'
                sh 'sudo chmod -R u+rwX $WORKSPACE || true'
            }
        }

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

        stage('Copy .env / Настроить окружение') {
            steps {
                sh 'cp .env.example .env || true'
            }
        }

        stage('Удалить старую SQLite-базу (если была)') {
            steps {
                sh 'rm -f database/database.sqlite || true'
            }
        }

        stage('Generate Application Key') {
            steps {
                sh 'docker-compose run --rm app php artisan key:generate'
            }
        }

        stage('Set Storage and Bootstrap Permissions') {
            steps {
                sh 'docker-compose run --rm app bash -c "chown -R www-data:www-data storage bootstrap/cache && chmod -R 775 storage bootstrap/cache"'
            }
        }

        stage('Set Database Permissions') {
            steps {
                sh 'docker-compose run --rm app bash -c "chown -R www-data:www-data database && chmod -R 775 database"'
            }
        }

        // === Блок надёжного ожидания MySQL ===
        stage('Wait for MySQL') {
            steps {
                script {
                    sh '''
                    tries=60
                    while [ $tries -gt 0 ]; do
                        if docker-compose exec -T db laravel_db ping -h"db" -ularavel_user -psecret --silent; then
                            echo "✅ MySQL уже готов!"
                            exit 0
                        fi
                        echo "⏳ Ждем MySQL ($tries попыток осталось)..."
                        sleep 2
                        tries=$((tries - 1))
                    done
                    echo "❌ Не удалось дождаться запуска MySQL в docker-compose."
                    exit 1
                    '''
                }
            }
        }

        stage('Run Migrations') {
            steps {
                sh 'docker-compose run --rm app php artisan migrate --force'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'docker-compose run --rm app php artisan test'
            }
        }

        stage('Start Application') {
            steps {
                sh 'docker-compose down || true'
                sh 'docker-compose up --build -d'
            }
        }
    }

    post {
        success {
            echo '✅ Приложение успешно развернуто и доступно на http://localhost:8083'
        }
        failure {
            echo '❌ Ошибка при развертывании. Смотрите логи пайплайна.'
        }
    }
}
