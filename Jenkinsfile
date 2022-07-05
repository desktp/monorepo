pipeline {
    agent { docker { image 'node:16.13.1-alpine' } }
    stages {
        stage('Debug') {
          steps {
            git branch: 'next-app-update', url: 'https://github.com/desktp/monorepo'
          }
        }

        stage("Test changeset") {
             when {
                 changeset "**/Jenkinsfile"
             }
             steps {
                 echo("changeset works")
             }
         }

         stage("Display changeset?") {
             steps {
                 script {
                     def changeLogSets = currentBuild.changeSets
                     echo("changeSets=" + changeLogSets)
                     for (int i = 0; i < changeLogSets.size(); i++) {
                         def entries = changeLogSets[i].items
                         for (int j = 0; j < entries.length; j++) {
                             def entry = entries[j]
                             echo "${entry.commitId} by ${entry.author} on ${new Date(entry.timestamp)}: ${entry.msg}"
                             def files = new ArrayList(entry.affectedFiles)
                             for (int k = 0; k < files.size(); k++) {
                                 def file = files[k]
                                 echo " ${file.editType.name} ${file.path}"
                             }
                         }
                     }
                 }
             }
         }

        stage('Build apps') {
            parallel {
              stage('Next App') {
                when {
                  changeset "packages/next-app/**"
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