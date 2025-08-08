import jenkins.model.*
import org.jenkinsci.plugins.workflow.job.WorkflowJob
import org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition
import hudson.plugins.git.*
import hudson.scm.SCM
import hudson.model.ParametersDefinitionProperty
import hudson.model.ChoiceParameterDefinition

def jenkins = Jenkins.getInstance()
def jobName = "go-app"
def prefix = "==> "

println ""
println ""

if (jenkins.getItem(jobName) != null) {
    println "${prefix} Job '${jobName}' already exists, nothing to do."
    return
}

println "${prefix} Criating job '${jobName}'..."

def gitSCM = new GitSCM(
    GitSCM.createRepoList("https://github.com/andeerlb/devops-mug-amd-dream", null),
    [new BranchSpec("*/master")],
    false,
    Collections.emptyList(),
    null,
    null,
    new ArrayList<>()
)

def definition = new CpsScmFlowDefinition(gitSCM, "app/Jenkinsfile")
definition.setLightweight(true)

def job = new WorkflowJob(jenkins, jobName)
job.setDefinition(definition)

def choices = ["dev", "prod"]
def param = new ChoiceParameterDefinition("ENV", choices as String[], "Choose environment")
def paramsDef = new ParametersDefinitionProperty(param)
job.addProperty(paramsDef)

jenkins.putItem(job)

println "${prefix} Job '${jobName}' was created with success!"

println ""
println ""