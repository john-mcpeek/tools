# Tools pod image and yaml

## Oh My Zsh with powerlevel10k is setup.

This will build and bake an image with powerlevel10k setup for `root` and the `tools` users.

```shell
 docker build . -t bake &&\
 docker run --rm -d -t --user 10001:10001 --name bake-commit bake &&\
 sleep 5 &&\
 docker commit bake-commit tools-bake &&\
 docker stop bake-commit &&\
 docker run --rm -d -t --user root --name bake-commit tools-bake &&\
 sleep 5 &&\
 docker commit bake-commit tools &&\
 docker stop bake-commit
```

| File name                 | Description                                                               |
|---------------------------|---------------------------------------------------------------------------|
| Dockerfile                | Builds an image with all the tools we need.                               |
| tools.yaml                | Kubernetes Pod yaml for use as a bastion server.                          |
| .p10k.zsh                 | powerlevel10k configuration.                                              |
| .zshrc                    | Z Shell configuration file.                                               |
| p10k-prompt-functions.zsh | Functions used for prompt segments  (ENVIRONMENT_NAME and CONTAINER_NAME) |