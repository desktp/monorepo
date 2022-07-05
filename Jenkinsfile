pipeline {
    agent { docker { image 'node:16.13.1-alpine' } }
    stages {
        stage('Build apps') {
            parallel {
              stage('Next App') {
                when {
                  allOf {
                    changeset "packages/next-app/**"

                    expression {  // there are changes in some-directory/...
                        sh(returnStatus: true, script: 'git diff  origin/master --name-only | grep --quiet "^packages/next-app/.*"') == 0
                    }

                    expression {   // ...and nowhere else.
                        sh(returnStatus: true, script: 'git diff origin/master --name-only | grep --quiet --invert-match "^packages/next-app/.*"') == 1
                    }
                  }
                }

                steps {
                  sh 'echo "This is the next app"'
                }
              }
              stage('Remix App') {
                when {
                  changeset "packages/remix-app/**/*"
                }

                steps {
                  sh 'echo "This is the remix app"'
                }
              }
            }
        }
    }
}