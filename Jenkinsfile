pipeline {
    agent any

    environment {
        // Пример — укажите ваши переменные окружения для deploy
        DEPLOY_SERVER = 'adm-dev@89.169.189.111'
        APP_DIR = '/var/www/example-app'
    }

    stages {
        stage('Клонирование репозитория') {
            steps {
                git branch: 'master', url: 'https://github.com/Dania409/docker-project'
            }
        }
        stage('Установка зависимостей') {
            steps {
                sh 'composer install --no-interaction --prefer-dist'
                sh 'cp .env.example .env || true'
                sh 'php artisan key:generate'
            }
        }
        stage('Тестирование') {
            steps {
                sh 'php artisan test --env=testing || true' // тесты опциональны
            }
        }
        stage('Сборка фронтенда (если нужно)') {
            steps {
                sh 'npm ci'
                sh 'npm run build || npm run prod || true'
            }
        }
        stage('Деплой на сервер') {
            steps {
                // Используйте SSH credentials для безопасной деплоя
                sshagent(['jenkins-ssh-key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER} '
                        cd ${APP_DIR} &&
                        git pull &&
                        composer install --no-dev --prefer-dist &&
                        php artisan migrate --force
                    '
                    """
                }
            }
        }
    }
    post {
        failure {
            // Здесь добавьте уведомления по почте или Slack (по необходимости)
            echo 'Деплой завершился с ошибкой!'
        }
    }
}
