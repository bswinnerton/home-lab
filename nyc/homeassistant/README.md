# Home Assistant

[Home Assistant](https://www.home-assistant.io/) is the hub for everything smart-home. It runs unprivileged on a bridge network and is served by [Traefik](../traefik/) at `https://home.nyc.brooks.network`. This directory runs it alongside the radios and services it depends on:

- **homeassistant**: Home Assistant itself, exposed on port `8123` behind Traefik.
- **mqtt**: [Eclipse Mosquitto](https://mosquitto.org/), the MQTT broker that Zigbee2MQTT and Home Assistant communicate through, addressable as `mqtt:1883` from any container on the compose network. It allows anonymous connections since it's only reachable from the home lab network.
- **zigbee2mqtt**: [Zigbee2MQTT](https://www.zigbee2mqtt.io/), which drives the Zigbee half of the HubZ (HUSBZB-1) combo stick and publishes devices to MQTT with [Home Assistant discovery](https://www.zigbee2mqtt.io/guide/usage/integration/home_assistant.html) enabled, so paired devices show up in Home Assistant automatically. Its frontend is on port `8080`. The stick's Z-Wave radio is unused — there are no Z-Wave devices on this host.

## Setup

1. Create the shared proxy network if it doesn't exist yet: `sudo docker network create web`.
2. Bring up [Traefik](../traefik/) first, then this stack with `sudo docker compose up -d`.
3. In Home Assistant, add the **MQTT** integration (Settings → Devices & Services) pointed at host `mqtt`, port `1883`. No credentials are required.
4. Pair Zigbee devices through the Zigbee2MQTT frontend; they'll appear in Home Assistant via MQTT discovery.

## Things to watch out for

- The HubZ ships with pre-7.4 EmberZNet firmware, so Zigbee2MQTT is configured with the legacy `ezsp` serial driver. If the stick is ever flashed with firmware ≥ 7.4, switch `serial.adapter` to `ember` in [`zigbee2mqtt/configuration.yaml`](./zigbee2mqtt/configuration.yaml).
- Zigbee2MQTT writes runtime state (paired devices, the generated network key) back into `zigbee2mqtt/configuration.yaml`, so that file will drift from what's committed here. Don't lose the `network_key` — without it, every device has to be re-paired.
- Because Home Assistant runs on a bridge network, its mDNS traffic (HomeKit advertisements, Chromecast/ESPHome discovery) is multicast onto Docker's internal bridge and doesn't reach the LAN on its own — router-side mDNS reflection can't help, since the router never sees packets that stay inside the host. If HomeKit discovery fails, add an mDNS reflector on the host (e.g. an Avahi container in reflector mode); anything else that relies on discovery can be configured manually by IP.
