FROM jsii/superchain:1-buster-slim-node14

ARG AWS_CLI_V2_URL='https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip'
ARG TERRAFORM_URL='https://releases.hashicorp.com/terraform/1.1.0/terraform_1.1.0_linux_amd64.zip'

# Install custom tools, runtime, etc.
RUN brew install fzf


USER root:root
# install jq wget
RUN apt-get update && apt-get install -y jq wget

RUN mv $(which aws) /usr/local/bin/awscliv1 && \
  curl "${AWS_CLI_V2_URL}" -o "/tmp/awscliv2.zip" && \
  unzip /tmp/awscliv2.zip -d /tmp && \
  /tmp/aws/install

# install terraform
RUN curl -o terraform.zip "${TERRAFORM_URL}" && \
  unzip terraform.zip && \
  mv terraform /usr/local/bin/ && \
  rm -f terraform.zip

# install aws-sso-credential-process
RUN cd /usr/local/bin && \
  curl -o aws-sso-credential-process "${CRED_PROCESS_URL}" && \
  chmod +x aws-sso-credential-process

# install session-manager-plugin(required for aws ssm start-session)
RUN curl "${SESSION_MANAGER_PLUGIN}" -o "session-manager-plugin.deb" && \
  dpkg -i session-manager-plugin.deb && \
  rm -f session-manager-plugin.deb
#install zip 
RUN  apt-get update -y && \
     apt-get upgrade -y && \
     apt-get dist-upgrade -y && \
     apt-get -y autoremove && \
     apt-get clean
RUN apt-get install -y p7zip \
    p7zip-full \
    unace \
    zip \
    unzip \
    xz-utils \
    sharutils \
    uudeview \
    mpack \
    arj \
    cabextract \
    file-roller \
    && rm -rf /var/lib/apt/lists/*
CMD ["bash"]
USER superchain:superchain
