Multi-Swift
===========

What
----
What does it take to be able to run multiple Swift clusters on shared hardware?

Assumptions
-----------
(a) Each cluster would have dedicated disk drives for storing data
(b) Only testing with 'tmpauth' at this time

Why
---
Why would anyone want to do this? To reduce costs. For the same reasons that the
following support running multiple instances:
- relational databases
- web servers
- application servers

How
---
Each cluster must have its own ports and configuration files. In the case of using
'tmpauth' (default auth system for Swift), each cluster must be given it's own
memcached instance. Each cluster should also have some indicator to use for syslog
entries so that individual log messages can be associated with a specific cluster.

When
----
The work on this idea was carried at the beginning of the Newton release cycle.

Who
---
This approach would likely be of interest to enterprises that are:
(a) deploying small to medium size Swift clusters
(b) highly sensitive to deployment costs (server hardware, per OS chargebacks)
(c) requiring some separation between different business units or departments

Alternatives
------------
(a) dedicated hardware deployments for each cluster
(b) virtualized servers running on common cluster hardware (separate OS instances)
(c) Docker/LXC containers per cluster running on shared host/parent
(d) multi-tenancy within Swift

Example
-------
- Sales department needs to store blobs (audio, images, video clips) for various
advertising campaigns
- Accounting department needs to store scanned images of invoices, receipts,
contracts, etc.
- Suppose accounting department files must be stored in separate cluster due to
legal or regulatory requirements
- 1 set of servers for shared infrastructure
- Set up 2 Swift clusters - a 'sales' Swift cluster and an 'accounting' Swift
cluster
- Each cluster gets their own disk drives for storing data
	Sales: /dev/sdc, /dev/sdd, /dev/sde
	Accounting: /dev/sdf, /dev/sdg, /dev/sdh
- Paths
    /etc/swift-sales/swift.conf
    /etc/swift-acct/swift.conf
    ...
- Ports
    Sales: port ranges 61** - 61**
    Accounting: port ranges 62** - 62**
- Memcached
    Sales memcached running on port 11212
    Accounting memcached running on port 11213

Installation Process
-------------------
This project includes set of bash scripts with comments inline to install Swift All in One. This setup mimics the layout of [SAIO - Swift All In One](http://docs.openstack.org/developer/swift/development_saio.html)

These scripts as targeted and tested for Ubuntu 14.04

##Order of execution:

```bash
sudo ./sys_swift_check_users.sh
sudo ./sys_swift_install_deps.sh
sudo ./sys_swift_setup.sh
sudo ./make_openrc.sh
```

At this point, multiple Swift clusters are installed. To get started using multiple instances,

```bash
sudo su swift-<dept>
source openrc
./startmain.sh
```

##Remove Swift:

```bash
sudo ./stop_swift.sh
sudo ./sys_swift_remove.sh
```
