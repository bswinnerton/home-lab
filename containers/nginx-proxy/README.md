# NGINX Reverse Proxy

I use NGINX as a reverse proxy to terminate SSL to various containers in my home lab. NGINX runs in a Docker container, powered by [JrCs/docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion). It's a very neat tool that listens for new docker containers, and if they have the [right environment variables](https://github.com/bswinnerton/home-lab/blob/3c835db2108622ccc015e8e6d658f4ffc117717e/grafana/docker-compose.yml#L14-L17), it automatically fetches an SSL certificate from Let's Encrypt.

The underlying container that runs nginx [exposes ports 80 and 443](https://github.com/bswinnerton/home-lab/blob/3c835db2108622ccc015e8e6d658f4ffc117717e/nginx-proxy/docker-compose.yml#L10-L11), and my [EdgeRouter](../README.md#the-home-lab) port forwards any incoming requests on my public IP to this container.

I stole most of the [`docker-compose.yml`](./docker-compose.yml) file from [this](https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion/blob/41485d673c0c1777cab271f6ca125a38ca835665/docker-compose.yml) repository.
