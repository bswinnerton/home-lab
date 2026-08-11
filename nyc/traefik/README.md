# Traefik

The nyc instance of [Traefik](https://traefik.io/), mirroring the [cabin one](../../cabin/traefik/). It terminates SSL for the containers on this host — currently [Home Assistant](../homeassistant/) at `home.nyc.brooks.network` — and serves its own dashboard at `lb.nyc.brooks.network`.

Certificates come from Let's Encrypt via a Cloudflare DNS challenge, so copy `env.example` to `.env` and fill in the Cloudflare API key before starting. The shared `web` network must exist first: `sudo docker network create web`.
