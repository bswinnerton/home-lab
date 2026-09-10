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

The filter is deliberately narrow. Contact sensors are matched by the `binary_sensor.*_contact` glob rather than by including the whole `binary_sensor` domain, because HomeKit falls back to advertising an occupancy sensor for any device class it doesn't map — so a domain-wide include turns the `tamper` entity Zigbee2MQTT pairs alongside a contact sensor into a phantom motion sensor in the Home app. Zigbee2MQTT names a contact sensor's entity `binary_sensor.<device>_contact`, so the glob catches new door and window sensors as they're paired; a sensor renamed in Home Assistant needs its entity listed explicitly.

## Setup

1. Create the shared proxy network if it doesn't exist yet: `sudo docker network create web`.
2. Bring up [Traefik](../traefik/) first, then this stack with `sudo docker compose up -d`.
3. In Home Assistant, add the **MQTT** integration (Settings → Devices & Services) pointed at host `mqtt`, port `1883`. No credentials are required.
4. Pair Zigbee devices through the Zigbee2MQTT frontend; they'll appear in Home Assistant via MQTT discovery.

## Migrating off the `config` volume

Home Assistant's config directory used to be a named `config` volume with the four tracked YAML files bind mounted in over the top of it, one file at a time. That broke every save from the UI automation, scene and script editors: those editors write a temp file and rename it into place, and the kernel won't rename over a mount point, so each save failed with `OSError: [Errno 16] Resource busy: '/config/tmpXXXXXXXX' -> '/config/automations.yaml'`. The whole directory is bind mounted now, which makes those files ordinary files inside the mount and lets the rename succeed.

An existing install has to copy the old volume's contents across first — `.storage/` holds the auth tokens, the entity registry, the HomeKit pairing and every integration's config entry, and the recorder database holds the history. Skipping this starts Home Assistant at the onboarding wizard with all of that gone:

1. Stop the container: `sudo docker compose stop homeassistant`.
2. Confirm the volume's name with `sudo docker volume ls` — Compose prefixes it with the project, so it's `homeassistant_config` unless this directory was renamed.
3. Copy it into `config/`: `sudo docker run --rm -v homeassistant_config:/from -v "$PWD/config:/to" alpine sh -c 'cp -a /from/. /to/'`.
4. Restore the tracked YAML with `git checkout -- config/`. The old volume holds empty placeholder copies of the four files at the paths the single-file mounts covered, and step 3 copies those over the real ones.
5. Bring it back up with `sudo docker compose up -d`, check the logs, and save an automation from the UI to confirm the write works.
6. Once it's healthy, drop the old volume: `sudo docker volume rm homeassistant_config`.

## Things to watch out for

- The HubZ ships with pre-7.4 EmberZNet firmware, so Zigbee2MQTT is configured with the legacy `ezsp` serial driver. If the stick is ever flashed with firmware ≥ 7.4, switch `serial.adapter` to `ember` in [`zigbee2mqtt/configuration.yaml`](./zigbee2mqtt/configuration.yaml).
- Zigbee2MQTT writes runtime state (paired devices, the generated network key) back into `zigbee2mqtt/configuration.yaml`, so that file will drift from what's committed here. Don't lose the `network_key` — without it, every device has to be re-paired.
- Bind mount `config/` as a directory, never the individual YAML files inside it. Mounting a single file makes that path a mount point, and anything that replaces the file by renaming a temp file over it — which is how Home Assistant's UI editors save `automations.yaml`, `scenes.yaml` and `scripts.yaml` — fails with `Errno 16 Resource busy`. The editors write to those exact paths under `/config`, so moving the files into a subdirectory doesn't help either.
- Home Assistant writes its database, logs and `.storage/` into `config/` now that the directory is mounted whole. [`config/.gitignore`](./config/.gitignore) ignores everything and allows the four tracked YAML files back in, so leave it in place — `.storage/` holds auth tokens.
- Discovery-reliant integrations other than HomeKit (Chromecast, Sonos, ESPHome, etc.) also depend on the avahi reflector; anything it can't reflect can still be configured manually by IP.
