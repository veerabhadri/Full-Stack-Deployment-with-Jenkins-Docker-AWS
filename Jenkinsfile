pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'

        FRONTEND_REPO = '215786710391.dkr.ecr.us-east-1.amazonaws.com/full-stack-deployment-frontend'
        BACKEND_REPO  = '215786710391.dkr.ecr.us-east-1.amazonaws.com/full-stack-deployment-backend'

        ECS_CLUSTER = 'full-stack-deployment-cluster'
        FRONTEND_SERVICE = 'full-stack-deployment-frontend-service'
        BACKEND_SERVICE  = 'full-stack-deployment-backend-service'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Login to Amazon ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION \
                | docker login --username AWS --password-stdin 215786710391.dkr.ecr.us-east-1.amazonaws.com
                '''
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

        stage('Push Frontend Image') {
            steps {
                sh '''
                docker push $FRONTEND_REPO:latest
                '''
            }
        }

        stage('Push Backend Image') {
            steps {
                sh '''
                docker push $BACKEND_REPO:latest
                '''
            }
        }

        stage('Deploy to ECS') {
            steps {
                sh '''
                aws ecs update-service \
                  --cluster $ECS_CLUSTER \
                  --service $FRONTEND_SERVICE \
                  --force-new-deployment \
                  --region $AWS_REGION

                aws ecs update-service \
                  --cluster $ECS_CLUSTER \
                  --service $BACKEND_SERVICE \
                  --force-new-deployment \
                  --region $AWS_REGION
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully!'
        }

        failure {
            echo 'Deployment failed.'
        }
    }
}