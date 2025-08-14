// Job DSL script to create 'go-app' Pipeline job

pipelineJob('go-app') {
    description('Pipeline job for go-app application')

    // SCM configuration to pull the repository
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/andeerlb/devops-mug-and-dream')
                    }
                    branches('*/master')
                    extensions {}
                }
            }
            scriptPath('app/Jenkinsfile')
            lightweight(true)
        }
    }

    // Parameter to select environment
    parameters {
        choiceParam('ENV', ['dev', 'prod'], 'Choose environment')
    }
}
