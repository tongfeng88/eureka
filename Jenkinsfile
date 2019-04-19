// 需要在jenkins的Credentials设置中配置jenkins-harbor-creds、jenkins-k8s-config参数
pipeline {
    agent any
    environment {
        REPOSITORY_CREDS = credentials('jenkins-repository-creds')
        K8S_CONFIG = credentials('jenkins-k8s-config')
        GIT_TAG = sh(returnStdout: true,script: 'git describe --tags').trim()
    }
    parameters {
        string(name: 'REPOSITORY_HOST', defaultValue: 'ccr.ccs.tencentyun.com', description: '仓库地址')
        string(name: 'DOCKER_IMAGE', defaultValue: 'tongfeng88/eureka', description: 'docker镜像名')
        string(name: 'APP_NAME', defaultValue: 'eureka-demo', description: 'k8s中标签名')
        string(name: 'K8S_NAMESPACE', defaultValue: 'default', description: 'k8s的namespace名称')
    }
    stages {
        stage('Maven Build') {
            when { expression { env.GIT_TAG != null } }
            agent {
                docker {
                    image 'maven:3-jdk-8-alpine'
                    args '-v $HOME/.m2:/root/.m2'
                }
            }
            steps {
                sh 'mvn clean package -Dfile.encoding=UTF-8 -DskipTests=true'
                stash includes: 'target/*.jar', name: 'app'
            }

        }
        stage('Docker Build') {
            when { 
                allOf {
                    expression { env.GIT_TAG != null }
                }
            }
            agent any
            steps {
                unstash 'app'
                sh "docker login -u 100009328407 -p Qwe12345 ${params.REPOSITORY_HOST}"
                sh "docker build --build-arg JAR_FILE=`ls target/*.jar |cut -d '/' -f2` -t ${params.REPOSITORY_HOST}/${params.DOCKER_IMAGE}:${GIT_TAG} ."
                sh "docker push ${params.REPOSITORY_HOST}/${params.DOCKER_IMAGE}:${GIT_TAG}"
                sh "docker rmi ${params.REPOSITORY_HOST}/${params.DOCKER_IMAGE}:${GIT_TAG}"
            }
            
        }
        stage('Deploy') {
                  when {
                      allOf {
                          expression { env.GIT_TAG != null }
                      }
                  }
                  agent {
                      docker {
                          image 'lwolf/helm-kubectl-docker'
                      }
                  }
                  steps {
                      sh "mkdir -p ~/.kube"
                  }

              }
        
    }
}
