# Prometheus

Prometheus is a time series database that is the underlying datastore for [Grafana](../grafana). It operates on a "[pull model](https://prometheus.io/docs/introduction/faq/#why-do-you-pull-rather-than-push?)" in fetch metrics.

There are a few exporters in which I've configured Prometheus to pull from, they're defined below. My general rule of thumb of what services to put in Prometheus' `docker-compose.yml` is asking the question "Does this container make sense to run without Prometheus?". If the answer is yes, it belongs in its own `docker-compose.yml`.

## cAdvisor

[cAdvisor](https://github.com/google/cadvisor) is a tool that analyzes resource usage and performance characteristics of running containers.

![cadvisor](https://user-images.githubusercontent.com/934497/44185284-5e00da00-a0e1-11e8-9189-928306795ebe.png)

It ultimately powers a Grafana [dashboard](https://grafana.com/dashboards/193) that can tell me the impact each container is having on my NUC.

![grafana](https://user-images.githubusercontent.com/934497/44185320-8c7eb500-a0e1-11e8-8e92-5f93545edbe5.png)

## SNMP Exporter

The snmp\_exporter is a tool that extracts data from SNMP and offers it to Prometheus to monitor my EdgeRouter X and LiteBeam.

There is a configuration file that was created from [this generator](https://github.com/prometheus/snmp_exporter/blob/26b3c855fb72b64527881a5acb8597ef49b00f9f/generator/README.md), and boy was it a doozy. It required finding a variety of MIBs for the Ubiquiti devices (pro tip: the EdgeRouter's MIBs are available in `/usr/share/snmp/mibs/`). And then `snmpwalk`'ing the various devices to find OIDs that I found interesting. Once those OIDs were in hand, I could use them as starting points for the generator config.

### Generating the snmp.yml file

Start by building a local version of the image:

```
git clone https://github.com/prometheus/snmp_exporter
cd snmp_exporter/generator/
docker build -t snmp-generator .
```

Then `cd` back into this folder and:

```
docker run -ti \
  -v $PWD/mibs:/root/.snmp/mibs \
  -v $PWD/generator.yml:/opt/generator.yml:ro \
  -v $PWD/:/opt/ \
  snmp-generator generate
```

## Unifi

[Unifi](../unifi/) monitors my Unifi AP AC Pro.
