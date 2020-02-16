FROM ubuntu:latest

# Get the TLS CA certificates, they're not provided by busybox.
RUN apt-get update && apt-get install -y ca-certificates \
  curl \
  bash \
  jq

COPY entrypoint.sh /entrypoint.sh 

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
