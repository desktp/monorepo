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

    echo sh(
        script: "git diff --name-only ${MASTER}...${HEAD} | grep ^${module}/"
    )

    return sh(
        returnStatus: true,
        script: "git diff --name-only ${MASTER}...${HEAD} | grep ^${module}/"
    ) == 0
}

pipeline {
    agent { dockerfile true }
    stages {
        stage('Debug image') {
          steps {
            sh 'git -v'
            sh 'wrangler -v'
          }
        }

        stage('Build apps') {
            parallel {
              stage('Next App') {
                when {
                  expression {
                      return hasChangesIn("packages/next-app/**")
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
}