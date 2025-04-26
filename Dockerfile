FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update &&\
    apt upgrade -y &&\
    apt install -y \
    	zsh \
    	git \
    	jq \
		vim \
		wget \
    	curl \
		unzip \
		gnupg \
        dos2unix \
		lsb-release \
		ca-certificates \
		postgresql-client \
    	netcat-openbsd &&\
    apt clean

RUN echo "############################################################ oh-my-zsh / powerlevel10k" &&\chsh -s $(which zsh) &&\
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &&\
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

RUN	echo "############################################################ kubectl" &&\
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" &&\
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl &&\
    kubectl version --client

COPY .zshrc /root
COPY .p10k.zsh /root
COPY tools.yaml /root

RUN groupadd -g 10001 tools &&\
    useradd  -u 10001 -g 10001 -m tools &&\
    dos2unix /root/.zshrc &&\
    dos2unix /root/.p10k.zsh

ENTRYPOINT ["/bin/zsh"]

# This creates the tools images and sets up oh-my-zsh with powerlever10k. (Currently comes out to ~566MB image size)
# docker build . -t bake && docker run --rm -d -t --name bake-commit bake && sleep 5 && docker commit bake-commit tools && docker stop bake-commit