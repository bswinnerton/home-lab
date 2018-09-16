# GlusterFS

[GlusterFS](https://www.gluster.org/) is a network based filesystem. In the
context of my home lab, it's the underlying shared filesystem that Kubernetes
relies on to create persistent volumes.

Most of the original configuration files for this setup were created using
[gluster-kubernetes](https://github.com/gluster/gluster-kubernetes)'
[`gk-deploy`](https://git.io/fA1ha) script.
