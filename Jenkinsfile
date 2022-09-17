node {
    stage('Build') {
        def pythonImage = docker.image("python:2-alpine")
        pythonImage.inside{
            sh 'python -m py_compile sources/add2vals.py sources/calc.py'
            stash(name: 'compiled-results', includes: 'sources/*.py*')
        } 
    }
    stage('Test') {
        def pytestImage = docker.image("qnib/pytest") 
        pytestImage.inside{
            try {
                sh 'py.test --junit-xml test-reports/results.xml sources/test_calc.py' 
            } catch (e) {
                echo 'test failed: '
                throw e
            } finally {
                junit 'test-reports/results.xml' 
            }
        }
    }
    stage('Deploy') {
        def VOLUME = '$(pwd)/sources:/src'
        def IMAGE = 'cdrx/pyinstaller-linux:python2'
        try {
            dir(path: env.BUILD_ID) {
                unstash(name: 'compiled-results')
                sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'"
            }
            archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals"
            sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
            sleep time: 1, unit: 'SECONDS'
            def herokuCliImage = docker.image("sue445/heroku-cli")
            herokuCliImage.inside{
                withCredentials([usernamePassword(credentialsId: '66eeda7f-1794-43a0-ace8-391e7d8acc9b', passwordVariable: 'pass', usernameVariable: 'user')]) {
                    def HEROKU_APP_NAME = "pycalc-adityacaturputra"
                    sh "git push https://heroku:$pass@git.heroku.com/pycalc-adityacaturputra.git master"
                }
            }
        } catch (e) {
            echo 'Deploy failed: '
            throw e
        }
    }
    stage('Manual Approval') {
        def VOLUME = '$(pwd)/sources:/src'
        def IMAGE = 'cdrx/pyinstaller-linux:python2'
        try {
            dir(path: env.BUILD_ID) {
                unstash(name: 'compiled-results')
                sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'"
            }
            archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals"
            def USER_INPUT = input(
                    message: 'Lanjutkan ke tahap deploy? (Klik "Proceed" atau "Abort")?',
                    parameters: [
                            [$class: 'ChoiceParameterDefinition',
                             choices: ['Abort','Proceed'].join('\n'),
                             name: 'input',
                             description: 'Menu - select box option']
            ])
            if( "${USER_INPUT}" == "Proceed"){
                echo "Melanjutkan ke tahap deploy"
                sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
            } else {
                echo "Tidak melanjutkan ke tahap deploy"
            }
            
        } catch (e) {
            echo 'Deploy failed: '
            throw e
        }
    }
}