pipeline {
    agent { docker { image 'node:16.13.1-alpine' } }
    stages {
        stage('Build apps') {
            parallel {
              stage('Next App') {
                when {
                  changeset "./packages/next-app/**"
                }

                steps {
                  sh 'echo "This is the next app"'
                }
              }
              stage('Remix App') {
                when {
                  changeset "./packages/remix-app/**/*"
                }

                steps {
                  sh 'echo "This is the remix app"'
                }
              }
            }
        }
    }
}