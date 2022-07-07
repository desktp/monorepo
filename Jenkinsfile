def boolean hasChangesIn(String module) {
    if (env.CHANGE_TARGET == null) {
       return true;
    }

    def MASTER = sh(
        returnStdout: true,
        script: "git rev-parse origin/${env.CHANGE_TARGET}"
    ).trim()

    // Gets commit hash of HEAD commit. Jenkins will try to merge master into
    // HEAD before running checks. If this is a fast-forward merge, HEAD does
    // not change. If it is not a fast-forward merge, a new commit becomes HEAD
    // so we check for the non-master parent commit hash to get the original
    // HEAD. Jenkins does not save this hash in an environment variable.
    def HEAD = sh(
        returnStdout: true,
        script: "git show -s --no-abbrev-commit --pretty=format:%P%n%H%n HEAD | tr ' ' '\n' | grep -v ${MASTER} | head -n 1"
    ).trim()

    return sh(
        returnStatus: true,
        script: "git diff --name-only ${MASTER}...${HEAD} | grep ^${module}/"
    ) == 0
}

pipeline {
  agent { docker { image 'node:16.13.1' } }
  stages {
      stage('Install dependencies') {
        steps {
          sh(script: 'npm install')
        }
      }

      stage('Build and deploy apps') {
          parallel {
            stage('Next App') {
              when {
                expression {
                    return hasChangesIn("packages/next-app/**")
                }
              }

              stages {
                stage('Build static HTML') {
                  steps {
                    sh(script: 'npm run next:build', label: 'Build Next.JS')
                    sh(script: 'npm run next:export', label: 'Export Next.JS static HTML')
                  }
                }

                stage('Deploy to GitHub Pages') {
                  // when { branch: 'master' }
                  steps {
                    withCredentials([gitUsernamePassword(credentialsId: 'github-desktp', gitToolName: 'Default')]) {
                      sh(script: "NEXT_APP_VERSION=`cat packages/next-app/package.json | grep version | cut -d '\"' -f 4`", label: "Parse Next App version")
                      sh(script: 'mv packages/next-app/out/* .', label: 'Move static files to repository root')
                      sh(script: 'git checkout gh-pages && git add . && git commit -m "Next App ${NEXT_APP_VERSION}"', label: 'Checkout to gh-pages branch and commit')
                      sh(script: 'git push origin gh-pages', label: 'Push to origin')
                    }
                  }
                }
              }
            }

            stage('Remix App') {
              when {
                changeset "packages/remix-app/**/*"
              }

              environment {
                CF_API_TOKEN = credentials('cf-apitoken')
                CF_ACCOUNT_ID = credentials('cf-accountid')
              }

              steps {
                sh(script: 'echo "This is the remix app"', label: 'Confirm branch')

                sh(script: 'echo "loaded api key ${CF_ACCOUNT_ID"', label: 'Confirm API key')
              }
            }
          }
      }
  }

  post {
    cleanup {
      cleanWs()
    }
  }
}