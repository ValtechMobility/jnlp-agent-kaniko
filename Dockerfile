FROM gcr.io/kaniko-project/executor:debug as kaniko

FROM jenkins/inbound-agent:alpine as jnlp

FROM alpine:3.16.1

RUN apk add --no-cache openjdk11-jre git curl bash aws-cli

COPY --from=kaniko /kaniko /kaniko
RUN mkdir -p /kaniko/.docker
RUN chmod 777 /kaniko

ENV HOME /root
ENV USER root
ENV PATH /kaniko:$PATH
ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG /kaniko/.docker/
ENV DOCKER_CREDENTIAL_GCR_CONFIG /kaniko/.config/gcloud/docker_credential_gcr_config.json
WORKDIR /workspace

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
