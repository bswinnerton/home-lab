# Grafana

The nyc instance of [Grafana](https://grafana.com/), mirroring the [cabin one](../../cabin/grafana/) but served at `graphs.nyc.brooks.network`. It expects the external `metrics` network (and a Prometheus feeding it) to exist on this host — the nyc Prometheus stack hasn't been ported into this repo yet.
