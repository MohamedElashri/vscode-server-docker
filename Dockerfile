FROM ubuntu:23.10

ARG USER=vscode
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG WORKDIR=workspace
ENV DONT_PROMPT_WSL_INSTALL=1
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gpg apt-transport-https ca-certificates sudo \
    tzdata gnome-keyring python3-minimal git build-essential \
    && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list \
    && apt-get update && apt-get install -y --no-install-recommends code \
    && apt-get remove -y --autoremove --purge gpg apt-transport-https \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && groupadd -g ${GROUP_ID} ${USER} \
    && useradd -u ${USER_ID} -g ${GROUP_ID} -m -s /bin/bash ${USER} \
    && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USER}

RUN mkdir -p "/home/${USER}/.vscode" "/home/${USER}/.vscode-server" "/home/${USER}/.vscode-server/extensions" "/home/${USER}/.local/share/code-server" "/home/${USER}/${WORKDIR}"

COPY source/* /usr/local/bin/
RUN sudo chmod +x /usr/local/bin/*

ENV VSCODE_SERVE_MODE=local
ENV VSCODE_KEYRING_PASS=changeme
ENV VSCODE_SERVER_PORT=8000

EXPOSE 8000

HEALTHCHECK CMD curl --fail http://localhost:${VSCODE_SERVER_PORT} || exit 1

WORKDIR /home/${USER}/${WORKDIR}

ENTRYPOINT ["docker-entrypoint"]
CMD ["vscode-start"]