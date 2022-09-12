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
            sh "apt-get update"
            sh "apt-get -y install sudo"
            withCredentials([usernamePassword(credentialsId:'Heroku',usernameVariable:'USR',passwordVariable:'PWD')])
                {
                    sh "curl https://cli-assets.heroku.com/install.sh | sh"
                    sh "(echo "${env.USR}" echo "${env.PWD}") | heroku login -i"
                    dir(path: env.BUILD_ID) {
                        unstash(name: 'compiled-results')
                        sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'"
                    }
                    archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals"
                    sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
                    sleep time: 60, unit: 'SECONDS'
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