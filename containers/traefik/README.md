# Traefik

I use Traefik as a reverse proxy to terminate SSL to various containers in my home lab. Traefik runs in a Docker container. It's a very neat tool that listens for new docker containers, and if they have the [right labels](https://github.com/bswinnerton/home-lab/blob/02f00af9580b441f0ff2b79c84d5711333a8d507/containers/grafana/docker-compose.yml#L16-L19), it automatically fetches an SSL certificate from Let's Encrypt.

The underlying container that runs Traefik [exposes ports 80 and 443](https://github.com/bswinnerton/home-lab/blob/02f00af9580b441f0ff2b79c84d5711333a8d507/containers/traefik/docker-compose.yml#L9-L10), and my [EdgeRouter](../README.md#the-home-lab) port forwards any incoming requests on my public IP to this container.
