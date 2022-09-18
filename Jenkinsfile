node {
    stage('Try') {
        // sshagent(credentials : ['13.212.67.149']){
        //     sh '''
        //     [ -d ~/.ssh ] || mkdir ~/.ssh && chmod 0700 ~/.ssh
        //     ssh-keyscan -t rsa,dsa example.com >> ~/.ssh/known_hosts
        //     ssh user@example.com ...
        // '''
        // }
        // withCredentials([sshUserPrivateKey(credentialsId: "13.212.67.149", keyFileVariable: 'keyfile')]) {
        //     writeFile file: 'dicoding-devops-intermediate.pem', text: "${keyfile}"
        //     sh "chmod 400 dicoding-devops-intermediate.pem"
        //     sh "ssh -i \"dicoding-devops-intermediate.pem\" ec2-user@ec2-13-212-67-149.ap-southeast-1.compute.amazonaws.com && yes"
        //     sh "pwd"
        // } 
        def herokuCliImage = docker.image("sue445/heroku-cli")
        herokuCliImage.inside{
            sh 'echo Dityablast1412 | echo adityacaturputra25@gmail.com | heroku login -i'
            sh "git config --global user.email \"adityacaturputra25@gmail.com\""
            sh "git config --global user.name \"Aditya Catur Putra\""
            sh "heroku git:remote -a pycalc-adityacaturputra"
            sh "git add ."
            sh "git commit -m 'reinitialized files'"
            sh "git push heroku master"
        }
    }
    // stage('Build') {
    //     def pythonImage = docker.image("python:2-alpine")
    //     pythonImage.inside{
    //         sh 'python -m py_compile sources/add2vals.py sources/calc.py'
    //         stash(name: 'compiled-results', includes: 'sources/*.py*')
    //     } 
    // }
    // stage('Test') {
    //     def pytestImage = docker.image("qnib/pytest") 
    //     pytestImage.inside{
    //         try {
    //             sh 'py.test --junit-xml test-reports/results.xml sources/test_calc.py' 
    //         } catch (e) {
    //             echo 'test failed: '
    //             throw e
    //         } finally {
    //             junit 'test-reports/results.xml' 
    //         }
    //     }
    // }
    // stage('Deploy') {
    //     def VOLUME = '$(pwd)/sources:/src'
    //     def IMAGE = 'cdrx/pyinstaller-linux:python2'
    //     try {
    //         dir(path: env.BUILD_ID) {
    //             unstash(name: 'compiled-results')
    //             sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'"
    //         }
    //         archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals"
    //         sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
    //         sleep time: 1, unit: 'SECONDS'
    //     } catch (e) {
    //         echo 'Deploy failed: '
    //         throw e
    //     }
    // }
    // stage('Manual Approval') {
    //     def VOLUME = '$(pwd)/sources:/src'
    //     def IMAGE = 'cdrx/pyinstaller-linux:python2'
    //     try {
    //         dir(path: env.BUILD_ID) {
    //             unstash(name: 'compiled-results')
    //             sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'"
    //         }
    //         archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals"
    //         def USER_INPUT = input(
    //                 message: 'Lanjutkan ke tahap deploy? (Klik "Proceed" atau "Abort")?',
    //                 parameters: [
    //                         [$class: 'ChoiceParameterDefinition',
    //                          choices: ['Abort','Proceed'].join('\n'),
    //                          name: 'input',
    //                          description: 'Menu - select box option']
    //         ])
    //         if( "${USER_INPUT}" == "Proceed"){
    //             echo "Melanjutkan ke tahap deploy"
    //             sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
    //         } else {
    //             echo "Tidak melanjutkan ke tahap deploy"
    //         }
            
    //     } catch (e) {
    //         echo 'Deploy failed: '
    //         throw e
    //     }
    // }
}