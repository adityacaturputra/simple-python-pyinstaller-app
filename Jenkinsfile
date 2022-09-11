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
    stage('Deliver') {
        def VOLUME = '$(pwd)/sources:/src'
        def IMAGE = 'cdrx/pyinstaller-linux:python2'
        try {
            dir(path: env.BUILD_ID) {
                unstash(name: 'compiled-results')
                sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'"
            }
            archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals"
            sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
        } catch (e) {
            echo 'deliver failed: '
            throw e
        }
    }
}