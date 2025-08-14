FROM jenkins/jenkins:lts

USER root

RUN apt-get update && \
    apt-get install -y curl apt-transport-https ca-certificates gnupg2 software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
        > /etc/apt/sources.list.d/docker.list && \
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor -o /usr/share/keyrings/helm.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" \
        > /etc/apt/sources.list.d/helm-stable-debian.list && \
    apt-get update && apt-get install -y docker-ce-cli helm

ENV GO_VERSION=1.24.6
RUN curl -fsSL https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -o /tmp/go.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

RUN groupadd -f docker && usermod -aG docker jenkins

COPY plugins /usr/share/jenkins/ref/plugins
COPY plugins.txt /usr/share/jenkins/plugins.txt
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/

RUN chown -R jenkins:jenkins /var/jenkins_home
# For each .hpi plugin file, create a .jpi symbolic link pointing to it so Jenkins can recognize both extensions.
RUN chown -R jenkins:jenkins /usr/share/jenkins/ref/plugins && \
    find /usr/share/jenkins/ref/plugins -name "*.hpi" -exec bash -c 'f="{}"; ln -s "$(basename "$f")" "${f%.hpi}.jpi"' \;
RUN jenkins-plugin-cli \
  --plugin-file /usr/share/jenkins/plugins.txt 
 
COPY casc.yaml /var/jenkins_config/casc.yaml
ENV CASC_JENKINS_CONFIG=/var/jenkins_config/casc.yaml
ENV JAVA_OPTS=-Djenkins.install.runSetupWizard=false -Dio.jenkins.plugins.casc.ConfigurationAsCode.initialDelay=0 -Dio.jenkins.plugins.casc.ConfigurationAsCode.reload=true -Dio.jenkins.plugins.casc.ConfigurationAsCode.logLevel=FINE

USER jenkins