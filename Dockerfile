FROM gcr.io/kaniko-project/executor:debug as kaniko

FROM jenkins/inbound-agent:alpine as jnlp

FROM alpine:3.16.1

RUN apk add --no-cache openjdk8-jre git curl bash aws-cli

COPY --from=kaniko /kaniko /kaniko

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
