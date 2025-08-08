# to build this image
```
export JENKINS_ADMIN_ID=<USERNAME> JENKINS_ADMIN_PASSWORD=<PASSWORD> && \
docker build -t jenkins:latest .
```
# to run this image
```
docker run --name jenkins -p 8080:8080 -p 50000:50000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v jenkins_home:/var/jenkins_home \
  -e JENKINS_ADMIN_ID=$JENKINS_ADMIN_ID \
  -e JENKINS_ADMIN_PASSWORD=$JENKINS_ADMIN_PASSWORD \
  jenkins:latest
```