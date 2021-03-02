
pipeline {
    agent {
        node {
            label "master"
        } 
    }

    stages {
        stage('clone repo') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/spadevapps/jenkins-terraform.git']]])
            }
        }

        stage('start terraform') {
            steps {
                script {
                    sh '/c/ProgramData/chocolatey/bin/terraform init'
                }             
            }      
        }

        stage('apply terraform') {
            steps {
                script {
                    // sh '/bin/terraform apply -auto-approve'
					sh '/c/ProgramData/chocolatey/bin/terraform apply -auto-approve'

                }
            }
        }
        
        stage('get pods') {
            steps {
                script {
                    sh '/c/ProgramData/chocolatey/bin/kubectl get all --all-namespaces'
                }
            }
        }
    } 
}
