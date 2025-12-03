pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Init') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-jenkins-tf',
                     accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                     secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                ]) {
                    sh 'terraform init'
                }
            }
        }

        stage('Plan') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-jenkins-tf',
                     accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                     secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                ]) {
                    sh 'terraform plan -out=tfplan -var="region=${AWS_REGION}"'
                }
            }
        }

        stage('Approval') {
            when {
                anyOf {
                    environment name: 'BRANCH_NAME', value: 'main'
                    environment name: 'GIT_BRANCH', value: 'origin/main'
                }
            }
            steps {
                script {
                    timeout(time: 15, unit: 'MINUTES') {
                        input message: 'Apply the Terraform changes?', ok: 'Apply'
                    }
                }
            }
        }

        stage('Apply') {
            when {
                anyOf {
                    environment name: 'BRANCH_NAME', value: 'main'
                    environment name: 'GIT_BRANCH', value: 'origin/main'
                }
            }
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-jenkins-tf',
                     accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                     secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                ]) {
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'tfplan', allowEmptyArchive: true
        }
        success {
            echo "Terraform pipeline completed successfully."
        }
        failure {
            echo "Terraform pipeline failed."
        }
    }
}
