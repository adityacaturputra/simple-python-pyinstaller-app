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
}