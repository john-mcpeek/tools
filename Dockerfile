FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update &&\
    apt upgrade -y &&\
    apt install -y \
        ca-certificates \
        curl \
        dos2unix \
        git \
        gnupg \
        iproute2 \
        jq \
        lsb-release \
        netcat-openbsd \
        postgresql-client \
        unzip \
        wget \
        vim \
        zsh &&\
	apt clean

RUN echo "############################################################ oh-my-zsh / powerlevel10k" &&\
    chsh -s $(which zsh) &&\
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &&\
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

RUN echo "############################################################ kubectl" &&\
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" &&\
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl &&\
    kubectl version --client

COPY .zshrc /root
COPY .p10k.zsh /root
COPY tools.yaml /root
COPY p10k-prompt-functions.zsh /root
COPY aliases.zsh /root

RUN groupadd -g 10001 tools &&\
    useradd  -u 10001 -g 10001 -m tools &&\
    dos2unix /root/.zshrc &&\
    dos2unix /root/.p10k.zsh &&\
    dos2unix /root/p10k-prompt-functions.zsh &&\
    dos2unix /root/aliases.zsh &&\
    mv /root/aliases.zsh /root/.oh-my-zsh/custom &&\
    cp -R /root/.zshrc /root/.p10k.zsh /root/p10k-prompt-functions.zsh /root/.oh-my-zsh  /home/tools &&\
    chown -R 10001:10001 /home/tools

ENTRYPOINT ["/bin/zsh"]

# This creates the tools images and sets up oh-my-zsh with powerlever10k. (Currently comes out to ~695MB image size)
# Look in README.md for shell command to build the image
