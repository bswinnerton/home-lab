# Home Assistant

[Home Assistant](https://www.home-assistant.io/) is the hub for everything smart-home. It runs unprivileged on a bridge network and is served by [Traefik](../traefik/) at `https://home.nyc.brooks.network`. This directory runs it alongside the radios and services it depends on:

- **homeassistant**: Home Assistant itself, exposed on port `8123` behind Traefik.
- **mqtt**: [Eclipse Mosquitto](https://mosquitto.org/), the MQTT broker that Zigbee2MQTT and Home Assistant communicate through, addressable as `mqtt:1883` from any container on the compose network. It allows anonymous connections since it's only reachable from the home lab network.
- **zigbee2mqtt**: [Zigbee2MQTT](https://www.zigbee2mqtt.io/), which drives the Zigbee half of the HubZ (HUSBZB-1) combo stick and publishes devices to MQTT with [Home Assistant discovery](https://www.zigbee2mqtt.io/guide/usage/integration/home_assistant.html) enabled, so paired devices show up in Home Assistant automatically. Its frontend is served by Traefik at `https://zigbee.nyc.brooks.network`. The stick's Z-Wave radio is unused — there are no Z-Wave devices on this host.
- **avahi**: an [Avahi](https://avahi.org/) daemon in reflector mode on the host network, which repeats Home Assistant's mDNS announcements onto the LAN so HomeKit works — see below.

## HomeKit

Because Home Assistant runs on a Docker bridge network, its HomeKit mDNS advertisements can't reach the LAN on their own, and phones couldn't reach the announced container IP even if they did. Per the [HomeKit docs' considerations](https://www.home-assistant.io/integrations/homekit/#considerations), three pieces fix this and all are required:

1. the avahi reflector container (in this compose file),
2. host port `21063` published on the `homeassistant` container (also in this compose file), and
3. the `homekit:` block in [`config/configuration.yaml`](./config/configuration.yaml) with `advertise_ip` set to the host's LAN IP, so phones connect to the host's published port instead of the unroutable container address.

Configure HomeKit through that YAML block rather than the UI — `advertise_ip` is YAML-only — and pair from the Home app using the QR code in Home Assistant's notifications panel.

## Setup

1. Create the shared proxy network if it doesn't exist yet: `sudo docker network create web`.
2. Bring up [Traefik](../traefik/) first, then this stack with `sudo docker compose up -d`.
3. In Home Assistant, add the **MQTT** integration (Settings → Devices & Services) pointed at host `mqtt`, port `1883`. No credentials are required.
4. Pair Zigbee devices through the Zigbee2MQTT frontend; they'll appear in Home Assistant via MQTT discovery.

## Things to watch out for

- The HubZ ships with pre-7.4 EmberZNet firmware, so Zigbee2MQTT is configured with the legacy `ezsp` serial driver. If the stick is ever flashed with firmware ≥ 7.4, switch `serial.adapter` to `ember` in [`zigbee2mqtt/configuration.yaml`](./zigbee2mqtt/configuration.yaml).
- Zigbee2MQTT writes runtime state (paired devices, the generated network key) back into `zigbee2mqtt/configuration.yaml`, so that file will drift from what's committed here. Don't lose the `network_key` — without it, every device has to be re-paired.
- Discovery-reliant integrations other than HomeKit (Chromecast, Sonos, ESPHome, etc.) also depend on the avahi reflector; anything it can't reflect can still be configured manually by IP.
