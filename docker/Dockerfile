FROM amazonlinux:2

LABEL this.os="Amazon Linux 2" \
      this.hostname="tf-executor"

RUN mkdir -p /tmp/kainosCerts
COPY "certs/*.crt" /tmp/kainosCerts
COPY "certs/*.pem" /tmp/kainosCerts
RUN cp /tmp/kainosCerts/*.crt /etc/pki/ca-trust/source/anchors/
RUN update-ca-trust extract
RUN echo "[global]" >> /etc/pip.conf
RUN echo "cert = /usr/local/share/ca-certificates/kainos-chain3.crt" >> etc/pip.conf
RUN yum update -y
RUN yum install -y wget unzip util-linux-ng epel-release nmap tree python-pip git-core which jq python3

RUN REQUESTS_CA_BUNDLE=/tmp/kainosCerts/kainos-chain.pem pip install --upgrade pip
RUN REQUESTS_CA_BUNDLE=/tmp/kainosCerts/kainos-chain.pem pip install --upgrade awscli

RUN git clone https://github.com/tfutils/tfenv.git /.tfenv

RUN ln -s /.tfenv/bin/* /usr/local/bin

ADD ./services /opt
