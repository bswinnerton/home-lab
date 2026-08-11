# Home Assistant

[Home Assistant](https://www.home-assistant.io/) is the hub for everything smart-home in the lab. This directory runs it alongside the radios and services it depends on:

- **homeassistant**: Home Assistant itself, using host networking so device discovery works.
- **zwave**: [Z-Wave JS UI](https://github.com/zwave-js/zwave-js-ui), which drives the Z-Wave half of the HubZ (HUSBZB-1) combo stick. Home Assistant talks to it over the websocket server on port `3000`.
- **mosquitto**: [Eclipse Mosquitto](https://mosquitto.org/), the MQTT broker that Zigbee2MQTT and Home Assistant communicate through. It allows anonymous connections since it's only reachable from the home lab network.
- **zigbee2mqtt**: [Zigbee2MQTT](https://www.zigbee2mqtt.io/), which drives the Zigbee half of the HubZ stick and publishes devices to MQTT with [Home Assistant discovery](https://www.zigbee2mqtt.io/guide/usage/integration/home_assistant.html) enabled, so paired devices show up in Home Assistant automatically.

## Connecting Home Assistant to Zigbee2MQTT

Zigbee2MQTT is integrated with Home Assistant through the broker rather than directly:

1. Bring the stack up with `sudo docker-compose up -d`.
2. In Home Assistant, add the **MQTT** integration (Settings → Devices & Services) and point it at `localhost:1883` (Home Assistant uses host networking, so the published Mosquitto port is reachable on localhost). No username or password is required.
3. Pair devices through the Zigbee2MQTT frontend at port `8080`; they'll appear in Home Assistant via MQTT discovery.

## Things to watch out for

- The HubZ ships with pre-7.4 EmberZNet firmware, so Zigbee2MQTT is configured with the legacy `ezsp` serial driver. If the stick is ever flashed with firmware ≥ 7.4, switch `serial.adapter` to `ember` in [`zigbee2mqtt/configuration.yaml`](./zigbee2mqtt/configuration.yaml).
- Only one thing can hold the Zigbee serial port. The `homeassistant` container still maps `/dev/ttyUSB1` (the same Zigbee radio) — if the ZHA integration was ever set up in Home Assistant, remove it before starting Zigbee2MQTT, otherwise the two will fight over the port.
- Zigbee2MQTT writes runtime state (paired devices, the generated network key) back into `zigbee2mqtt/configuration.yaml`, so that file will drift from what's committed here. Don't lose the `network_key` — without it, every device has to be re-paired.
