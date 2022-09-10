node {
    stage('Build') {
            def pythonImage = docker.image("python:2-alpine")
            pythonImage.inside{
                sh 'python -m py_compile sources/add2vals.py sources/calc.py'
                stash(name: 'compiled-results', includes: 'sources/*.py*')
            }
        }
}