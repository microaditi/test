pipeline{
    agent any
    environment{
        DOCKER_IMAGE = "microaditi/test:latest"
        
    }
    
    stages{
        stage('Clone the Repository'){
            steps{
                git branch: 'main',
                url: "https://github.com/microaditi/test.git"
            }
        }
        
        
        stage('Build Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: "dockerhub", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                sh 'docker build -t $DOCKER_IMAGE .'
                sh 'docker logout'
        }
    }
}

        
        stage('Push Image to Docker Registry'){
            steps{
                withCredentials([usernamePassword(credentialsId: "dockerhub", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push $DOCKER_IMAGE'
            }
        }
    }
    
        stage('Run Tests') {
            steps {
                sh 'chmod +x test_api.sh'
                sh './test_api.sh'
            }
        }

        
        stage('Deploy to K8s'){
            steps {
                withCredentials([file(credentialsId: "kubeconfig", variable: 'KUBECONFIG')]) {
                    sh 'kubectl --kubeconfig=$KUBECONFIG apply -f k8s/deployment.yml'
                    sh 'kubectl --kubeconfig=$KUBECONFIG apply -f k8s/service.yml'
                    
                    
                }
            }
        }
        
        stage('Cleaning Up the Image'){
            steps{
                sh 'docker rmi -f $DOCKER_IMAGE'
            }
        }
        
        stage('Cleaning Workspace'){
            steps{
                cleanWs()
            }
        }
    }
}
