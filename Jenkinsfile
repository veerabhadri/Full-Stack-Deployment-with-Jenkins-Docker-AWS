pipeline {
    agent any

    environment {
        FRONTEND_REPO = 'frontend-local'
        BACKEND_REPO  = 'backend-local'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Frontend Image') {
            steps {
                sh '''
                docker build -t $FRONTEND_REPO:latest ./frontend
                '''
            }
        }

        stage('Build Backend Image') {
            steps {
                sh '''
                docker build -t $BACKEND_REPO:latest ./backend
                '''
            }
        }

        stage('Run Containers Locally') {
            steps {
                sh '''
                docker run -d -p 3000:3000 $FRONTEND_REPO:latest
                docker run -d -p 5000:5000 $BACKEND_REPO:latest
                '''
            }
        }
    }

    post {
        success {
            echo 'Local build completed successfully!'
        }

        failure {
            echo 'Local build failed.'
        }
    }
}
