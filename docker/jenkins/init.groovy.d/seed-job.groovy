import jenkins.model.*
import hudson.model.*
import javaposse.jobdsl.plugin.ExecuteDslScripts
import hudson.plugins.git.GitSCM
import hudson.plugins.git.UserRemoteConfig
import hudson.plugins.git.BranchSpec
import hudson.model.ParametersDefinitionProperty
import hudson.model.StringParameterDefinition

def jobName = "seed-job"
def jenkins = Jenkins.instance

println "Creating seed job..."

def job = jenkins.createProject(FreeStyleProject, jobName)
job.setDescription("Seed job to create other jobs via Job DSL from Git repository")

def param = new StringParameterDefinition(
    "DSL_SCRIPT",
    null,
    "The path to the Job DSL script to be executed"
)
job.addProperty(new ParametersDefinitionProperty(param))

def gitUrl = "https://github.com/andeerlb/devops-mug-and-dream"
def branch = "master"

def userRemoteConfig = new UserRemoteConfig(gitUrl, null, null, null)
def gitSCM = new GitSCM(
    [userRemoteConfig],                    // remotes
    [new BranchSpec("*/${branch}")],       // branches
    false,                                 // doGenerateSubmoduleConfigurations
    [],                                    // submoduleCfg
    null,                                  // browser
    null,                                  // gitTool
    []                                     // extensions
)

job.scm = gitSCM

def dslStep = new ExecuteDslScripts()
dslStep.targets = "docker/jenkins/jobs/\${DSL_SCRIPT}.groovy"
dslStep.ignoreMissingFiles = false
dslStep.removedJobAction = javaposse.jobdsl.plugin.RemovedJobAction.DELETE
dslStep.lookupStrategy = javaposse.jobdsl.plugin.LookupStrategy.JENKINS_ROOT

job.buildersList.add(dslStep)

job.save()
println "Seed job created successfully!"