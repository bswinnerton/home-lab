# SNMP exporter

The snmp\_exporter is a tool that extracts data from SNMP and offers it to [Prometheus](../prometheus/).

There is a configuration file that was created from [this generator](https://github.com/prometheus/snmp_exporter/blob/26b3c855fb72b64527881a5acb8597ef49b00f9f/generator/README.md), and boy was it a doozy. It required finding a variety of MIBs for the Ubiquiti devices (pro tip: the EdgeRouter's MIBs are available in `/usr/share/snmp/mibs/`). And then `snmpwalk`'ing the various devices to find OIDs that I found interesting. Once those OIDs were in hand, I could use them as starting points for the generator config.
