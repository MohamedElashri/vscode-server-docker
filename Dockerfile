FROM ubuntu:22.04
ARG USER=vscode
ARG USER_ID=1000
ARG GROUP_ID=1000
ENV WORKDIR=workspace
ENV DONT_PROMPT_WSL_INSTALL=1

# Update and install basic packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gpg \
    apt-transport-https \
    ca-certificates \
    sudo \
    tzdata \
    gnome-keyring \
    python3-minimal \
    git \
    build-essential

# Add Microsoft GPG key and repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list

# Install VS Code
RUN apt-get update && apt-get install -y --no-install-recommends code

# Clean up
RUN apt-get remove -y --autoremove --purge gpg apt-transport-https \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create user and group with error handling
RUN groupadd -f -g ${GROUP_ID} ${USER} || groupadd -f ${USER} \
    && useradd -m -u ${USER_ID} -g ${GROUP_ID} -G sudo -s /bin/bash ${USER} 2>/dev/null \
    || useradd -m -g ${USER} -G sudo -s /bin/bash ${USER} \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to the created user
USER ${USER}

# Create necessary directories
RUN mkdir -p "/home/${USER}/.vscode" "/home/${USER}/.vscode-server" "/home/${USER}/${WORKDIR}"

# Copy scripts and make them executable
COPY source/* /usr/local/bin/
RUN sudo chmod +x /usr/local/bin/*

# Environment variables and exposed port
ENV VSCODE_SERVE_MODE=local
ENV VSCODE_KEYRING_PASS=changeme
ENV VSCODE_SERVER_PORT=8000
EXPOSE 8000

# Healthcheck
HEALTHCHECK CMD curl --fail http://localhost:${VSCODE_SERVER_PORT} || exit 1

# Set the working directory and entrypoint
WORKDIR /home/${USER}/${WORKDIR}
ENTRYPOINT ["docker-entrypoint"]
CMD ["vscode-start"]