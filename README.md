# tecnologies

* https://opentofu.org/
* https://helm.sh/
* https://grafana.com/
* https://prometheus.io/

# to run and destroy
to create run
```
tofu destroy
tofu apply -target=null_resource.minikube
tofu apply
```
or only one command
```
tofu destroy --auto-approve && tofu apply -target=null_resource.minikube --auto-approve && tofu apply --auto-approve
```

*if prefer, remove --auto-approve.*
Obs: Is importatnt to run first `--target=null_resource.minikube`, it will create the (k8s) cluster first, then will give us the k8s context, after that we can use this contexto to perform our k8s commands.

to delete, simply run 
```
tofu destroy
```

### Update the file plugins.txt
> docker/jenkins/plugins.txt

Add these plugins below:
* kubernetes
* workflow-aggregator
* git
* configuration-as-code
* golan
* dark-theme

# decisions

### is good to try
create and destroy everything by tofu file, everything. And, create tests to ensure the wholo ecossystem will created as should be and destroyed too.

### jenkins
try to use as a code, if it is possible, we can create and recreate our jenkins each time without lost any data or pipeline or any configurations.

to connect to jenkins:  
```
kubectl port-forward service/jenkins 8080:8080 -n infra
````

### namespaces
* dev, prod, infra

I guessing that dev and prod are self-explanatory, and I think to create infra namespace to couple that apps can be use in both context, like dev and prod or to produce outputs in both.

### k8s
always use `serviceType` as `portnode`, but why?
To understand I'll give more context, then:
* What's serviceType? 
K8S provide a network endpoint for a Pods, enabling communication both within and outside the cluster. The type property in a Service's specification determines how the service is exposed. 

    * Possibilities to setup: ClusterIP, NodePort, LoadBalancer, ExternalName, to clearify I'll explain each one bellow

        * ClusterIP -> it will expose the service with ip address within the cluster, limiting communication between current cluster context.
        * NodePort -> it will create one static port in the node, it will open one channel to receive communication outside the cluster from an static port.
        * LoadBalancer -> This will expose the service to the world, usually, will use cloud provider, but not necessarialy, this kind of service will provide a public ip address to be accessed, if you are using a cloud provider, probabbly you will have one DNS linked in your IPAddres but if your infra is  onpremise, I hope not, but, if is, cname no will linked automaticcaly like a cloud provider.
        * ExternalName -> will map your service (internal service) to one external DNS (cname), like github.com, it could be one service mapped on one k8s cluster with ExternalName.

### namespaces
* dev, prod, infra

I guessing that dev and prod are self-explanatory, and I think to create infra namespace to couple that apps can be use in both context, like dev and prod or to produce outputs in both.

### extras 
As I even lazy, I hate to write a lot of code, I mean, I always trying to create some scripts to improve or take my work more efficently, or if you prefer to tell, lazily, but a bit fast.
Knowing this, below I'll my extras tools and something else:

* https://github.com/ahmetb/kubectx
    * I like this one because it turn my comands more quickly and a bit small, with this, you can switch between your namespaces and context without effort
        * You'd like to use `kubens` or `kubectx`
            * these below are the kubectl fully commands
            * `kubectl config set-context --current --namespace=<your-namespace-name>`
            * `kubectl config use-context <context-name>`
* https://k9scli.io/
    * this is your bff, I really appreciate this one because is an interface built for terminal to work with you in your k8s cluster, more human-friendly.

### minikube
* run `eval $(minikube docker-env)` to use on my host terminal like a minikube docker
