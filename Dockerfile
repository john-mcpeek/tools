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
		netcat \
		postgresql-client \
		ca-certificates \
		gnupg \
		lsb-release \
		openjdk-21-jdk &&\
	echo "############################################################ Docker" &&\
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &&\
	echo \
		"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
		$(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null &&\
	apt-get update &&\
	apt-get install -y docker-ce &&\
	apt-get clean

RUN cd /var/tmp &&\
	echo "############################################################ AWS CLI" &&\
	curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" &&\
    unzip -q awscliv2.zip &&\
    ./aws/install &&\
	aws --version &&\
	echo "############################################################ eksctl" &&\
	curl -s --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" -o eksctl.tag.gz &&\
	tar xz -f eksctl.tag.gz &&\
	install eksctl /usr/local/bin &&\
	echo "eksctl installed" &&\
	echo "############################################################ kubectl" &&\
	curl -s -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" &&\
	install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl &&\
	kubectl version --client &&\
	echo "############################################################ .bashrc" &&\
	echo 'source /usr/share/bash-completion/bash_completion' >>~/.bashrc &&\
	echo 'source <(kubectl completion bash)' >>~/.bashrc &&\
	echo 'complete -F __start_kubectl k' >>~/.bashrc &&\
	echo 'complete -C "/usr/local/bin/aws_completer" aws' >>~/.bashrc &&\
	echo 'alias k=kubectl' >>~/.bashrc &&\
	echo 'alias d=docker' >>~/.bashrc &&\
	echo 'alias l="ls -alh"' >>~/.bashrc &&\
	sed -i "s/^#force_color_prompt=/force_color_prompt=/" ~/.bashrc &&\
	sed -i 's/\\u@\\h/TOOLS/g' ~/.bashrc &&\
	echo "############################################################ Cleanup" &&\
	rm -rf /var/tmp/*

ENTRYPOINT ["/bin/bash"]
