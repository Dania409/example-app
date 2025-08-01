pipeline {
    agent any
    
    stages {
        stage('Cleanup') {
            steps {
                script {
                    // Останавливаем и удаляем существующие контейнеры
                    sh '''
                        docker-compose down --volumes --remove-orphans || true
                        docker system prune -f || true
                    '''
                }
            }
        }
        
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Dania409/example-app'
            }
        }
        
        stage('Setup Environment') {
            steps {
                script {
                    // Создаем .env файл с правильными настройками для Docker
                    sh '''
                        cp .env.example .env || echo "APP_NAME=Laravel" > .env
                        echo "APP_ENV=production" >> .env
                        echo "APP_KEY=" >> .env
                        echo "APP_DEBUG=true" >> .env
                        echo "APP_URL=http://89.169.184.40:8083" >> .env
                        echo "" >> .env
                        echo "DB_CONNECTION=mysql" >> .env
                        echo "DB_HOST=db" >> .env
                        echo "DB_PORT=3306" >> .env
                        echo "DB_DATABASE=laravel_db" >> .env
                        echo "DB_USERNAME=laravel_user" >> .env
                        echo "DB_PASSWORD=secret" >> .env
                    '''
                }
            }
        }
        
        stage('Install Dependencies') {
            steps {
                script {
                    // Устанавливаем Composer зависимости в временном контейнере
                    sh '''
                        docker run --rm -v $(pwd):/app -w /app composer:2 install --no-interaction --prefer-dist --optimize-autoloader
                    '''
                }
            }
        }
        
        stage('Build and Deploy') {
            steps {
                script {
                    // Запускаем контейнеры через docker-compose
                    sh '''
                        docker-compose up -d --build
                        
                        # Ждем пока MySQL запустится
                        echo "Waiting for MySQL to start..."
                        sleep 30
                        
                        # Генерируем ключ приложения
                        docker-compose exec -T app php artisan key:generate
                        
                        # Запускаем миграции
                        docker-compose exec -T app php artisan migrate --force
                        
                        # Устанавливаем права доступа
                        docker-compose exec -T app chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
                        docker-compose exec -T app chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
                    '''
                }
            }
        }
        
        stage('Health Check') {
            steps {
                script {
                    // Проверяем что приложение отвечает
                    sh '''
                        echo "Waiting for application to start..."
                        sleep 10
                        
                        # Проверяем что контейнеры запущены
                        docker-compose ps
                        
                        # Проверяем доступность приложения
                        curl -f http://89.169.184.40:8083 || echo "Application not yet ready"
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo 'Laravel application deployed successfully!'
            echo 'Access your application at: http://89.169.184.40:8083'
            echo 'phpMyAdmin available at: http://89.169.184.40:8081'
        }
        failure {
            echo 'Deployment failed! Cleaning up...'
            sh 'docker-compose down --volumes || true'
        }
        always {
            // Показываем логи для отладки
            sh '''
                echo "=== Container Status ==="
                docker-compose ps || true
                echo "=== Application Logs ==="
                docker-compose logs app || true
                echo "=== Database Logs ==="  
                docker-compose logs db || true
            '''
        }
    }
}

