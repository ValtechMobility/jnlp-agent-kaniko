FROM gcr.io/kaniko-project/executor:debug as kaniko

FROM jenkins/inbound-agent:alpine

RUN apk add --no-cache openjdk8-jre git curl bash aws-cli

COPY --from=kaniko /kaniko /kaniko

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
