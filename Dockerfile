FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN echo "############################################################ install apt packages" &&\
	apt-get update &&\
      apt-get install -y \
		unzip \
		less \
		jq \
		bash-completion \
		apt-transport-https \
		curl \
		wget \
		netcat-openbsd \
		postgresql-client \
		ca-certificates \
		gnupg \
		lsb-release \
		openjdk-21-jdk &&\
   apt-get clean

RUN echo "############################################################ Docker" &&\
	install -m 0755 -d /etc/apt/keyrings &&\
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc &&\
	chmod a+r /etc/apt/keyrings/docker.asc &&\
	echo \
		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
		$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null &&\
	apt-get update &&\
	apt-get install -y docker-ce &&\
	apt-get clean

RUN cd /var/tmp &&\
	echo "############################################################ AWS CLI" &&\
	curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" &&\
    unzip -q awscliv2.zip &&\
    ./aws/install &&\
	aws --version

RUN echo "############################################################ eksctl" &&\
	curl -s --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" -o eksctl.tag.gz &&\
	tar xz -f eksctl.tag.gz &&\
	install eksctl /usr/local/bin &&\
	echo "eksctl installed"

RUN echo "############################################################ kubectl" &&\
	curl -s -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" &&\
	install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl &&\
	kubectl version --client

RUN echo "############################################################ .bashrc" &&\
	echo 'source /etc/profile.d/bash_completion.sh' >>~/.bashrc &&\
	echo 'source <(kubectl completion bash)' >>~/.bashrc &&\
	echo 'complete -F __start_kubectl k' >>~/.bashrc &&\
	echo 'complete -C "/usr/local/bin/aws_completer" aws' >>~/.bashrc &&\
	echo 'alias k=kubectl' >>~/.bashrc &&\
	echo 'alias d=docker' >>~/.bashrc &&\
	echo 'alias l="ls -alh"' >>~/.bashrc &&\
	sed -i "s/^#force_color_prompt=/force_color_prompt=/" ~/.bashrc &&\
	sed -i 's/\\u@\\h/TOOLS/g' ~/.bashrc

RUN echo "############################################################ Cleanup" &&\
	rm -rf /var/tmp/*

ENTRYPOINT ["/bin/bash"]
