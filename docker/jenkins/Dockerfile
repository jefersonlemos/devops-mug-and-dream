FROM jenkins/jenkins:lts

USER root

RUN apt-get update && \
    apt-get install -y curl gnupg2 apt-transport-https ca-certificates software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
      > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    apt-get clean

RUN groupadd -f docker && usermod -aG docker jenkins

COPY plugins /usr/share/jenkins/ref/plugins
COPY plugins.txt /usr/share/jenkins/plugins.txt
COPY jobs/ /var/jenkins_home/jobs/

RUN chown -R jenkins:jenkins /var/jenkins_home/jobs
RUN chown -R jenkins:jenkins /usr/share/jenkins/ref/plugins && \
    find /usr/share/jenkins/ref/plugins -name "*.hpi" -exec bash -c 'f="{}"; ln -s "$(basename "$f")" "${f%.hpi}.jpi"' \;
RUN jenkins-plugin-cli \
  --plugin-file /usr/share/jenkins/plugins.txt 

COPY casc.yaml /var/jenkins_config/casc.yaml
ENV CASC_JENKINS_CONFIG=/var/jenkins_config/casc.yaml
ENV JAVA_OPTS=-Djenkins.install.runSetupWizard=false -Dio.jenkins.plugins.casc.ConfigurationAsCode.initialDelay=0 -Dio.jenkins.plugins.casc.ConfigurationAsCode.reload=true -Dio.jenkins.plugins.casc.ConfigurationAsCode.logLevel=FINE

USER jenkins