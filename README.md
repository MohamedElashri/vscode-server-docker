# VSCode Server in Docker Container

This project provides a containerized VSCode server environment, allowing you to run VSCode in a web browser. It's designed to be secure, customizable, and easy to set up.

## Features

- VSCode server running in a Docker container
- Secure access with password protection
- Customizable user, workspace, and environment settings
- Persistent storage for VSCode settings and workspace data
- Easy deployment with Docker Compose

## Prerequisites

- Docker
- Docker Compose

## Quick Start

1. Clone this repository:
   ```
   git clone https://github.com/MohamedElashri/vscode-server-docker.git
   cd vscode-server-docker
   ```

2. Copy the example `sample.env` file and modify it as needed:
   ```
   cp example.env .env
   ```

3. Build and start the container:
   ```
   docker-compose up -d
   ```

4.  Accessing the Server

Access VSCode in your web browser at `http://localhost:8000/?tkn=YOUR_CONNECTION_TOKEN` (replace `YOUR_CONNECTION_TOKEN` with the value you set in the `.env` file).

NOTE: This will not work if you are not using `localhost` or `127.0.0.1`. According for this [issue](https://github.com/microsoft/vscode/issues/191276), The CLI does not support running serve-web with a TLS certificate, requiring an additional proxy layer like nginx. This is a limitation of browsers, 

## Configuration

### Environment Variables

You can customize the setup by modifying the following variables in the `.env` file:

- `USER`: The username for the VSCode user (default: vscode)
- `USER_ID`: The user ID for the VSCode user (default: 1000)
- `GROUP_ID`: The group ID for the VSCode user (default: 1000)
- `WORKDIR`: The name of the workspace directory (default: workspace)
- `VSCODE_SERVE_MODE`: The serve mode for VSCode (default: local)
- `VSCODE_KEYRING_PASS`: The password for the VSCode keyring
- `VSCODE_SERVER_PORT`: The port to access VSCode (default: 8000)
- `CONNECTION_TOKEN`: A secure token for authenticating access to the VSCode server
- `TAG`: The tag for the Docker image (default: latest)

### Persistent Storage

The Docker Compose configuration uses named volumes to persist data:

- `vscode_data`: Stores VSCode settings
- `vscode_server_data`: Stores VSCode server-specific data
- `workdir_data`: Stores your workspace files

## Usage

### Starting the Server

```
docker-compose up -d
```

### Stopping the Server

```
docker-compose down
```

### Updating the Server

1. Pull the latest changes from the repository:
   ```
   git pull https://github.com/MohamedElashri/vscode-server-docker.git
   ```

2. Rebuild and restart the container:
   ```
   docker-compose up -d --build
   ```

### Accessing Logs

```
docker-compose logs
```

## Security Considerations

- Always use a strong `CONNECTION_TOKEN` in the `.env` file.
- Consider using HTTPS for production deployments.
- Regularly update the Docker image and dependencies.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file.