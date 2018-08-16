# Prometheus

Prometheus is a time series database that is the underlying datastore for [Grafana](../grafana). It operates on a "[pull model](https://prometheus.io/docs/introduction/faq/#why-do-you-pull-rather-than-push?)" in fetch metrics.

There are a few exporters in which I've configured Prometheus to pull from:

1. [SNMP](../snmp_exporter/) - Which monitors my EdgeRouter X and LiteBeam
2. [Unifi](../unifi_exporter/) - Which monitors my Unifi AP AC Pro
