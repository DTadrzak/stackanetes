FROM ubuntu:16.04

RUN apt-get -y update

RUN apt-get install -y python-pip python-dev git wget

RUN wget https://storage.googleapis.com/kubernetes-release/release/v1.3.0-beta.1/bin/linux/amd64/kubectl && chmod +x kubectl && mv kubectl /usr/bin/kubectl

ENV REPO_NAME=stackanetes
ENV BRANCH_NAME=master
ENV DOCKER_IMAGE_TAG=test
ENV DOCKER_REGISTRY=10.91.96.87:5000
ENV INTERFACE_NAME=eno2
ENV OS_USERNAME=admin
ENV OS_PASSWORD=password
ENV OS_TENANT_NAME=admin
ENV OS_AUTH_URL=http://keystone-api:5000/v2.0

RUN pip install python-openstackclient

COPY coreos.iso /root/

COPY start.sh /root/

RUN chmod +x /root/start.sh

CMD /root/start.sh
