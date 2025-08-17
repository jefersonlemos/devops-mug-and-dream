# tecnologies

* https://opentofu.org/
* https://helm.sh/
* https://grafana.com/
* https://prometheus.io/

# requirements

* Minikube
* Helm
* OpenTofu
* Docker


# to run and destroy
to create run
```
tofu destroy
tofu init
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
* job-dsl

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

### outputs

#### running the tests
```
➜  open-to-fu git:(master) tofu test -filter=minikube.tftest.hcl
minikube.tftest.hcl... pass
  run "minikube_apply"... pass

Success! 1 passed, 0 failed.
```

#### running the plan to create minikube cluster
```
➜  open-to-fu git:(master) tofu apply -target=null_resource.minikube

OpenTofu used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

OpenTofu will perform the following actions:

  # null_resource.minikube will be created
  + resource "null_resource" "minikube" {
      + id = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

#### creating all resources
```
➜  open-to-fu git:(master) tofu apply -target=null_resource.minikube --auto-approve && tofu apply --auto-approve

OpenTofu used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

OpenTofu will perform the following actions:

  # null_resource.minikube will be created
  + resource "null_resource" "minikube" {
      + id = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.
null_resource.minikube: Creating...
null_resource.minikube: Provisioning with 'local-exec'...
null_resource.minikube (local-exec): Executing: ["/bin/sh" "-c" "./data/minikube_create.sh"]
null_resource.minikube (local-exec): * minikube v1.36.0 on Darwin 15.6
null_resource.minikube (local-exec): * Using the docker driver based on user configuration
null_resource.minikube (local-exec): * Using Docker Desktop driver with root privileges
null_resource.minikube (local-exec): * Starting "minikube" primary control-plane node in "minikube" cluster
null_resource.minikube (local-exec): * Pulling base image v0.0.47 ...
null_resource.minikube: Still creating... [10s elapsed]
null_resource.minikube (local-exec): * Creating docker container (CPUs=6, Memory=8192MB) ...
null_resource.minikube: Still creating... [20s elapsed]
null_resource.minikube (local-exec): * Preparing Kubernetes v1.33.1 on Docker 28.1.1 ...
null_resource.minikube (local-exec):   - Generating certificates and keys ...
null_resource.minikube (local-exec):   - Booting up control plane ...
null_resource.minikube: Still creating... [30s elapsed]
null_resource.minikube (local-exec):   - Configuring RBAC rules ...
null_resource.minikube (local-exec): * Configuring bridge CNI (Container Networking Interface) ...
null_resource.minikube (local-exec): * Verifying Kubernetes components...
null_resource.minikube (local-exec):   - Using image gcr.io/k8s-minikube/storage-provisioner:v5
null_resource.minikube (local-exec): * Enabled addons: storage-provisioner, default-storageclass
null_resource.minikube (local-exec): * Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
null_resource.minikube (local-exec): * registry is an addon maintained by minikube. For any concerns contact minikube on GitHub.
null_resource.minikube (local-exec): You can view the list of minikube maintainers at: https://github.com/kubernetes/minikube/blob/master/OWNERS
null_resource.minikube (local-exec): ╭──────────────────────────────────────────────────────────────────────────────────────────────────────╮
null_resource.minikube (local-exec): │                                                                                                      │
null_resource.minikube (local-exec): │    Registry addon with docker driver uses port 63867 please use that instead of default port 5000    │
null_resource.minikube (local-exec): │                                                                                                      │
null_resource.minikube (local-exec): ╰──────────────────────────────────────────────────────────────────────────────────────────────────────╯
null_resource.minikube (local-exec): * For more information see: https://minikube.sigs.k8s.io/docs/drivers/docker
null_resource.minikube (local-exec):   - Using image gcr.io/k8s-minikube/kube-registry-proxy:0.0.9
null_resource.minikube (local-exec):   - Using image docker.io/registry:3.0.0
null_resource.minikube (local-exec): * Verifying registry addon...
null_resource.minikube: Still creating... [40s elapsed]
null_resource.minikube: Still creating... [50s elapsed]
null_resource.minikube (local-exec): * The 'registry' addon is enabled
null_resource.minikube (local-exec): ! registry-aliases is a 3rd party addon and is not maintained or verified by minikube maintainers, enable at your own risk.
null_resource.minikube (local-exec): ! registry-aliases does not currently have an associated maintainer.
null_resource.minikube (local-exec):   - Using image quay.io/rhdevelopers/core-dns-patcher
null_resource.minikube (local-exec):   - Using image docker.io/alpine:3.11
null_resource.minikube (local-exec):   - Using image gcr.io/google_containers/pause:3.1
null_resource.minikube (local-exec): * The 'registry-aliases' addon is enabled
null_resource.minikube (local-exec): Switched to context "minikube".
null_resource.minikube: Creation complete after 57s [id=208504688424415455]
╷
│ Warning: Resource targeting is in effect
│
│ You are creating a plan with either the -target option or the -exclude option, which means that the result of this plan may not represent all of the changes requested by the current configuration.
│
│ The -target and -exclude options are not for routine use, and are provided only for exceptional situations such as recovering from errors or mistakes, or when OpenTofu specifically suggests to use it as part of an error message.
╵
╷
│ Warning: Applied changes may be incomplete
│
│ The plan was created with the -target or the -exclude option in effect, so some changes requested in the configuration may have been ignored and the output values may not be fully updated. Run the following command to verify that no other changes are pending:
│     tofu plan
│
│ Note that the -target and -exclude options are not suitable for routine use, and are provided only for exceptional situations such as recovering from errors or mistakes, or when OpenTofu specifically suggests to use it as part of an error message.
╵

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
null_resource.minikube: Refreshing state... [id=208504688424415455]

OpenTofu used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

OpenTofu will perform the following actions:

  # data.kubernetes_service.jenkins will be read during apply
  # (depends on a resource or a module with changes pending)
 <= data "kubernetes_service" "jenkins" {
      + id     = (known after apply)
      + spec   = (known after apply)
      + status = (known after apply)

      + metadata {
          + generation       = (known after apply)
          + name             = "jenkins"
          + namespace        = "infra"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }
    }

  # kubernetes_namespace.dev will be created
  + resource "kubernetes_namespace" "dev" {
      + id                               = (known after apply)
      + wait_for_default_service_account = false

      + metadata {
          + annotations      = {
              + "description" = "development ecossystem"
            }
          + generation       = (known after apply)
          + labels           = {
              + "mylabel" = "dev"
            }
          + name             = "dev"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }
    }

  # kubernetes_namespace.infra will be created
  + resource "kubernetes_namespace" "infra" {
      + id                               = (known after apply)
      + wait_for_default_service_account = false

      + metadata {
          + annotations      = {
              + "description" = "this namespace should be used for infra applications"
            }
          + generation       = (known after apply)
          + labels           = {
              + "mylabel" = "infra"
            }
          + name             = "infra"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }
    }

  # kubernetes_namespace.prod will be created
  + resource "kubernetes_namespace" "prod" {
      + id                               = (known after apply)
      + wait_for_default_service_account = false

      + metadata {
          + annotations      = {
              + "description" = "release apps"
            }
          + generation       = (known after apply)
          + labels           = {
              + "mylabel" = "prod"
            }
          + name             = "prod"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }
    }

  # null_resource.grafana will be created
  + resource "null_resource" "grafana" {
      + id = (known after apply)
    }

  # null_resource.jenkins will be created
  + resource "null_resource" "jenkins" {
      + id = (known after apply)
    }

  # null_resource.kube-state-metrics will be created
  + resource "null_resource" "kube-state-metrics" {
      + id = (known after apply)
    }

  # null_resource.prometheus will be created
  + resource "null_resource" "prometheus" {
      + id = (known after apply)
    }

Plan: 7 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + jenkins_service_id = (known after apply)
kubernetes_namespace.prod: Creating...
kubernetes_namespace.dev: Creating...
kubernetes_namespace.infra: Creating...
kubernetes_namespace.infra: Creation complete after 0s [id=infra]
kubernetes_namespace.dev: Creation complete after 0s [id=dev]
kubernetes_namespace.prod: Creation complete after 0s [id=prod]
null_resource.kube-state-metrics: Creating...
null_resource.jenkins: Creating...
null_resource.prometheus: Creating...
null_resource.grafana: Creating...
null_resource.prometheus: Provisioning with 'local-exec'...
null_resource.jenkins: Provisioning with 'local-exec'...
null_resource.kube-state-metrics: Provisioning with 'local-exec'...
null_resource.grafana: Provisioning with 'local-exec'...
null_resource.kube-state-metrics (local-exec): Executing: ["/bin/sh" "-c" "      helm upgrade --install kube-state-metrics ../helm/kube-state-metrics --namespace infra\n"]
null_resource.prometheus (local-exec): Executing: ["/bin/sh" "-c" "      helm upgrade --install prometheus ../helm/prometheus --namespace infra\n"]
null_resource.grafana (local-exec): Executing: ["/bin/sh" "-c" "      helm upgrade --install grafana ../helm/grafana --namespace infra\n"]
null_resource.jenkins (local-exec): Executing: ["/bin/sh" "-c" "      docker build -t custom-jenkins:custom -f ../docker/jenkins/Dockerfile ../docker/jenkins\n      minikube image load custom-jenkins:custom\n      helm install jenkins ../helm/jenkins --namespace infra\n"]
null_resource.kube-state-metrics (local-exec): Release "kube-state-metrics" does not exist. Installing it now.
null_resource.grafana (local-exec): Release "grafana" does not exist. Installing it now.
null_resource.prometheus (local-exec): Release "prometheus" does not exist. Installing it now.
null_resource.kube-state-metrics (local-exec): NAME: kube-state-metrics
null_resource.kube-state-metrics (local-exec): LAST DEPLOYED: Sun Aug 17 17:38:46 2025
null_resource.kube-state-metrics (local-exec): NAMESPACE: infra
null_resource.kube-state-metrics (local-exec): STATUS: deployed
null_resource.kube-state-metrics (local-exec): REVISION: 1
null_resource.kube-state-metrics (local-exec): TEST SUITE: None
null_resource.kube-state-metrics: Creation complete after 1s [id=4305790957824081836]
null_resource.prometheus (local-exec): NAME: prometheus
null_resource.prometheus (local-exec): LAST DEPLOYED: Sun Aug 17 17:38:46 2025
null_resource.prometheus (local-exec): NAMESPACE: infra
null_resource.prometheus (local-exec): STATUS: deployed
null_resource.prometheus (local-exec): REVISION: 1
null_resource.prometheus (local-exec): TEST SUITE: None
null_resource.prometheus: Creation complete after 1s [id=4442778422174144647]
null_resource.grafana (local-exec): NAME: grafana
null_resource.grafana (local-exec): LAST DEPLOYED: Sun Aug 17 17:38:46 2025
null_resource.grafana (local-exec): NAMESPACE: infra
null_resource.grafana (local-exec): STATUS: deployed
null_resource.grafana (local-exec): REVISION: 1
null_resource.grafana (local-exec): TEST SUITE: None
null_resource.grafana: Creation complete after 1s [id=6266721244943338209]
null_resource.jenkins (local-exec): #0 building with "desktop-linux" instance using docker driver

null_resource.jenkins (local-exec): #1 [internal] load build definition from Dockerfile
null_resource.jenkins (local-exec): #1 transferring dockerfile: 2.10kB done
null_resource.jenkins (local-exec): #1 DONE 0.0s

null_resource.jenkins (local-exec): #2 [auth] jenkins/jenkins:pull token for registry-1.docker.io
null_resource.jenkins (local-exec): #2 DONE 0.0s

null_resource.jenkins (local-exec): #3 [internal] load metadata for docker.io/jenkins/jenkins:lts
null_resource.jenkins (local-exec): #3 DONE 1.1s

null_resource.jenkins (local-exec): #4 [internal] load .dockerignore
null_resource.jenkins (local-exec): #4 transferring context: 2B done
null_resource.jenkins (local-exec): #4 DONE 0.0s

null_resource.jenkins (local-exec): #5 [ 1/11] FROM docker.io/jenkins/jenkins:lts@sha256:0e66af38c9272490ba18757d5d4d41e4ac2160278ae40b69d6da9b5adbe98794
null_resource.jenkins (local-exec): #5 resolve docker.io/jenkins/jenkins:lts@sha256:0e66af38c9272490ba18757d5d4d41e4ac2160278ae40b69d6da9b5adbe98794 0.0s done
null_resource.jenkins (local-exec): #5 DONE 0.0s

null_resource.jenkins (local-exec): #6 [internal] load build context
null_resource.jenkins (local-exec): #6 transferring context: 148.51kB 0.2s done
null_resource.jenkins (local-exec): #6 DONE 0.2s

null_resource.jenkins (local-exec): #7 [ 8/11] RUN chown -R jenkins:jenkins /var/jenkins_home
null_resource.jenkins (local-exec): #7 CACHED

null_resource.jenkins (local-exec): #8 [ 3/11] RUN curl -fsSL https://go.dev/dl/go1.24.6.linux-amd64.tar.gz -o /tmp/go.tar.gz &&     tar -C /usr/local -xzf /tmp/go.tar.gz &&     rm /tmp/go.tar.gz
null_resource.jenkins (local-exec): #8 CACHED

null_resource.jenkins (local-exec): #9 [ 9/11] RUN chown -R jenkins:jenkins /usr/share/jenkins/ref/plugins &&     find /usr/share/jenkins/ref/plugins -name "*.hpi" -exec bash -c 'f="{}"; ln -s "$(basename "$f")" "${f%.hpi}.jpi"' ;
null_resource.jenkins (local-exec): #9 CACHED

null_resource.jenkins (local-exec): #10 [ 2/11] RUN apt-get update &&     apt-get install -y curl apt-transport-https ca-certificates gnupg2 software-properties-common &&     curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &&     echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable"         > /etc/apt/sources.list.d/docker.list &&     curl https://baltocdn.com/helm/signing.asc | gpg --dearmor -o /usr/share/keyrings/helm.gpg &&     echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main"         > /etc/apt/sources.list.d/helm-stable-debian.list &&     apt-get update && apt-get install -y docker-ce-cli helm
null_resource.jenkins (local-exec): #10 CACHED

null_resource.jenkins (local-exec): #11 [ 5/11] COPY plugins /usr/share/jenkins/ref/plugins
null_resource.jenkins (local-exec): #11 CACHED

null_resource.jenkins (local-exec): #12 [ 6/11] COPY plugins.txt /usr/share/jenkins/plugins.txt
null_resource.jenkins (local-exec): #12 CACHED

null_resource.jenkins (local-exec): #13 [10/11] RUN jenkins-plugin-cli   --plugin-file /usr/share/jenkins/plugins.txt
null_resource.jenkins (local-exec): #13 CACHED

null_resource.jenkins (local-exec): #14 [ 4/11] RUN groupadd -f docker && usermod -aG docker jenkins
null_resource.jenkins (local-exec): #14 CACHED

null_resource.jenkins (local-exec): #15 [ 7/11] COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/
null_resource.jenkins (local-exec): #15 CACHED

null_resource.jenkins (local-exec): #16 [11/11] COPY casc.yaml /var/jenkins_config/casc.yaml
null_resource.jenkins (local-exec): #16 CACHED

null_resource.jenkins (local-exec): #17 exporting to image
null_resource.jenkins (local-exec): #17 exporting layers done
null_resource.jenkins (local-exec): #17 exporting manifest sha256:83fdc393d3ca5472bcd5e686ac7141fa52260465b1192baa8dd7bac025e4bed0 done
null_resource.jenkins (local-exec): #17 exporting config sha256:dd318a89ba79dbcd48075d0e9e41655e589ac91927c81392f955121417b3ee4a done
null_resource.jenkins (local-exec): #17 exporting attestation manifest sha256:27f5a36c9c22bd8675a1e395f3678520b787acc1b5b6eecc9ed28c658e04e516 0.0s done
null_resource.jenkins (local-exec): #17 exporting manifest list sha256:0bc7c82c09fe72c29917683002b635a26d98d0ba7f8a99a4e33523fb718c1eff done
null_resource.jenkins (local-exec): #17 naming to docker.io/library/custom-jenkins:custom done
null_resource.jenkins (local-exec): #17 unpacking to docker.io/library/custom-jenkins:custom 0.0s done
null_resource.jenkins (local-exec): #17 DONE 0.1s
null_resource.jenkins: Still creating... [10s elapsed]
null_resource.jenkins: Still creating... [20s elapsed]
null_resource.jenkins: Still creating... [30s elapsed]
null_resource.jenkins: Still creating... [40s elapsed]
null_resource.jenkins: Still creating... [50s elapsed]
null_resource.jenkins: Still creating... [1m0s elapsed]
null_resource.jenkins: Still creating... [1m10s elapsed]
null_resource.jenkins: Still creating... [1m20s elapsed]
null_resource.jenkins (local-exec): NAME: jenkins
null_resource.jenkins (local-exec): LAST DEPLOYED: Sun Aug 17 17:40:13 2025
null_resource.jenkins (local-exec): NAMESPACE: infra
null_resource.jenkins (local-exec): STATUS: deployed
null_resource.jenkins (local-exec): REVISION: 1
null_resource.jenkins (local-exec): TEST SUITE: None
null_resource.jenkins: Creation complete after 1m28s [id=8407905704801859944]
data.kubernetes_service.jenkins: Reading...
data.kubernetes_service.jenkins: Read complete after 0s [id=infra/jenkins]

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

jenkins_service_id = "infra/jenkins"
```

#### destroying all resources
```
➜  open-to-fu git:(master) tofu destroy
null_resource.minikube: Refreshing state... [id=208504688424415455]
kubernetes_namespace.dev: Refreshing state... [id=dev]
kubernetes_namespace.infra: Refreshing state... [id=infra]
kubernetes_namespace.prod: Refreshing state... [id=prod]
null_resource.kube-state-metrics: Refreshing state... [id=4305790957824081836]
null_resource.prometheus: Refreshing state... [id=4442778422174144647]
null_resource.jenkins: Refreshing state... [id=8407905704801859944]
null_resource.grafana: Refreshing state... [id=6266721244943338209]
data.kubernetes_service.jenkins: Reading...
data.kubernetes_service.jenkins: Read complete after 0s [id=infra/jenkins]

OpenTofu used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

OpenTofu will perform the following actions:

  # kubernetes_namespace.dev will be destroyed
  - resource "kubernetes_namespace" "dev" {
      - id                               = "dev" -> null
      - wait_for_default_service_account = false -> null

      - metadata {
          - annotations      = {
              - "description" = "development ecossystem"
            } -> null
          - generation       = 0 -> null
          - labels           = {
              - "mylabel" = "dev"
            } -> null
          - name             = "dev" -> null
          - resource_version = "488" -> null
          - uid              = "0f035fda-c9d7-45af-b902-4fb698ef1d52" -> null
        }
    }

  # kubernetes_namespace.infra will be destroyed
  - resource "kubernetes_namespace" "infra" {
      - id                               = "infra" -> null
      - wait_for_default_service_account = false -> null

      - metadata {
          - annotations      = {
              - "description" = "this namespace should be used for infra applications"
            } -> null
          - generation       = 0 -> null
          - labels           = {
              - "mylabel" = "infra"
            } -> null
          - name             = "infra" -> null
          - resource_version = "487" -> null
          - uid              = "f8967346-56c3-4d63-9b7d-4ca73db68a77" -> null
        }
    }

  # kubernetes_namespace.prod will be destroyed
  - resource "kubernetes_namespace" "prod" {
      - id                               = "prod" -> null
      - wait_for_default_service_account = false -> null

      - metadata {
          - annotations      = {
              - "description" = "release apps"
            } -> null
          - generation       = 0 -> null
          - labels           = {
              - "mylabel" = "prod"
            } -> null
          - name             = "prod" -> null
          - resource_version = "486" -> null
          - uid              = "885f9a4c-f2a1-4edb-9630-465cbd9f025c" -> null
        }
    }

  # null_resource.grafana will be destroyed
  - resource "null_resource" "grafana" {
      - id = "6266721244943338209" -> null
    }

  # null_resource.jenkins will be destroyed
  - resource "null_resource" "jenkins" {
      - id = "8407905704801859944" -> null
    }

  # null_resource.kube-state-metrics will be destroyed
  - resource "null_resource" "kube-state-metrics" {
      - id = "4305790957824081836" -> null
    }

  # null_resource.minikube will be destroyed
  - resource "null_resource" "minikube" {
      - id = "208504688424415455" -> null
    }

  # null_resource.prometheus will be destroyed
  - resource "null_resource" "prometheus" {
      - id = "4442778422174144647" -> null
    }

Plan: 0 to add, 0 to change, 8 to destroy.

Changes to Outputs:
  - jenkins_service_id = "infra/jenkins" -> null

Do you really want to destroy all resources?
  OpenTofu will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

null_resource.kube-state-metrics: Destroying... [id=4305790957824081836]
null_resource.jenkins: Destroying... [id=8407905704801859944]
null_resource.grafana: Destroying... [id=6266721244943338209]
null_resource.prometheus: Destroying... [id=4442778422174144647]
null_resource.kube-state-metrics: Provisioning with 'local-exec'...
null_resource.jenkins: Provisioning with 'local-exec'...
null_resource.grafana: Provisioning with 'local-exec'...
null_resource.jenkins (local-exec): Executing: ["/bin/sh" "-c" "helm uninstall jenkins --namespace infra"]
null_resource.prometheus: Provisioning with 'local-exec'...
null_resource.grafana (local-exec): Executing: ["/bin/sh" "-c" "      helm uninstall grafana --namespace infra\n"]
null_resource.kube-state-metrics (local-exec): Executing: ["/bin/sh" "-c" "      helm uninstall kube-state-metrics --namespace infra\n"]
null_resource.prometheus (local-exec): Executing: ["/bin/sh" "-c" "      helm uninstall prometheus --namespace infra\n"]
kubernetes_namespace.prod: Destroying... [id=prod]
kubernetes_namespace.dev: Destroying... [id=dev]
null_resource.kube-state-metrics (local-exec): release "kube-state-metrics" uninstalled
null_resource.kube-state-metrics: Destruction complete after 0s
null_resource.grafana (local-exec): release "grafana" uninstalled
null_resource.grafana: Destruction complete after 0s
null_resource.prometheus (local-exec): release "prometheus" uninstalled
null_resource.prometheus: Destruction complete after 0s
null_resource.jenkins (local-exec): release "jenkins" uninstalled
null_resource.jenkins: Destruction complete after 0s
kubernetes_namespace.infra: Destroying... [id=infra]
kubernetes_namespace.infra: Destruction complete after 7s
kubernetes_namespace.dev: Still destroying... [id=dev, 10s elapsed]
kubernetes_namespace.prod: Still destroying... [id=prod, 10s elapsed]
kubernetes_namespace.dev: Destruction complete after 13s
kubernetes_namespace.prod: Destruction complete after 13s
null_resource.minikube: Destroying... [id=208504688424415455]
null_resource.minikube: Provisioning with 'local-exec'...
null_resource.minikube (local-exec): Executing: ["/bin/sh" "-c" "./data/minikube_destroy.sh"]
null_resource.minikube (local-exec): Deleting Minikube...
null_resource.minikube (local-exec): * Deleting "minikube" in docker ...
null_resource.minikube (local-exec): * Deleting container "minikube" ...
null_resource.minikube (local-exec): * Removing /Users/anderson/.minikube/machines/minikube ...
null_resource.minikube (local-exec): * Removed all traces of the "minikube" cluster.
null_resource.minikube: Destruction complete after 5s

Destroy complete! Resources: 8 destroyed.
```
