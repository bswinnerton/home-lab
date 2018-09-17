# The brooks.network Home Lab

This repository is a collection of configuration files for my home lab.

Each subdirectory has a `README.md` outlining what the service is, how you can find out more information, and any notes of things to watch out for if you're looking to set it up yourself.

## Installation

The [`docker/`](./docker) directory assumes that you use Docker Compose. Each directory has a `docker-compose.yml` file that will spin up the appropriate containers for you.

Installation is as simple as:

```
cd <project directory>
sudo docker-compose up -d
```

Some `docker-compose.yml` files are made for specific architectures (x86-64, arm64, etc), so keep an eye out for any configurations that you may need to change to run on your infrastructure.

Previous to this repostiory, I had each of these configurations stored in a multi-file Gist as the `docker run` commands. I've found that Docker Compose is a straight forward, declaritive way to manage these configurations.

## The Home Lab

I run two [Intel NUC7 i5](https://www.intel.com/content/www/us/en/products/boards-kits/nuc/kits/nuc7i5bnk.html)s. Each has 32GB of RAM, and one has 1TB of disk space, and the other has 256GB. They both run Clear Linux, an incredibly lightweight distribution of Linux that has support for downtimeless updates and a great community on IRC. My motivation towards using it was based heavily on Sophie Haskin's [blog article](https://blog.sophaskins.net/blog/setting-up-a-home-hypervisor/) on setting up a home hypervisor. On each NUC, there are three [VMs](./kvms/); one Kubernetes master and two worker nodes. Outside of Kubernetes, there are a few [Docker containers](./docker/) that run on the host(s).

If you're interested in setting up KVM on Clear Linux, I've blogged about it over [here](https://brooks.sh/2017/12/22/configuring-kvm-on-clear-linux/).

In addition to the NUC, I have a Ubiquiti [EdgeRouter X](https://www.ubnt.com/edgemax/edgerouter-x/), and my ISP is the community-owned, net-neutral [NYC Mesh](https://nycmesh.net/). A Ubiquiti UAP-AC-Pro is the access point for my apartment.

This is all monitored by [Grafana](./containers/grafana/):

![grafana](https://user-images.githubusercontent.com/934497/44185068-2a718000-a0e0-11e8-8201-b33aabf922e0.png)
