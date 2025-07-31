pipeline {
    agent any
    stages {
        stage('Workspace cleanup') {
            steps {
                // Удалить только те каталоги, которые ломают git checkout
                sh 'sudo rm -rf storage bootstrap/cache database || true'
            }
        }
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Dania409/example-app'
            }
        }
        // остальные стадии остаются без изменений...
    }
    post {
        always {
            // Как и раньше, можно (и нужно) сбрасывать права, чтобы не было проблем в будущем
            sh 'sudo chown -R $(id -u):$(id -g) . || true'
            sh 'chmod -R u+rwX,go+rwX . || true'
        }
    }
}
