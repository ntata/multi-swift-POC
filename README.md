Multi-Swift
===========

What is Multi-Swift
-------------------
Swift is designed to own the OS on which its installed. Swift
is typically installed on bare-metal servers with each server
participating in a single Swift cluster. This means that each
Swift cluster deployment would need dedicated servers.

Multi-Swift is the concept of running multiple Swift instances
(clusters) on shared hardware. This is analogous to
database servers or web servers that allow multiple instances to be run on
the same server.

Why
---
Why would anyone want to do this? To reduce costs -- for the same reasons that the
following support running multiple instances:
- relational databases
- web servers
- application servers

Who
---
This approach would likely be of interest to enterprises that are:
- deploying small to medium size Swift clusters
- highly sensitive to deployment costs (server hardware, per OS chargebacks)
- requiring some separation between different business units or departments

Alternatives
------------
- dedicated hardware deployments for each cluster
- virtualized servers running on common cluster hardware (separate OS instances)
- Docker/LXC containers per cluster running on shared host/parent
- multi-tenancy within Swift etc.

How
---
Each cluster must have its own ports, code base and configuration files. In the case of using
'tempauth' (default auth system for Swift), each cluster must be given its own
memcached server. Each cluster should also have some indicator to use for syslog
entries so that individual log messages can be associated with a specific cluster.

Assumptions/Limitations
-----------------------
- A single node (all in one) deployment with loopback devices
- Each cluster has dedicated storage devices for storing data
- Only tested with 'tempauth'
- Current implementation deploys two Swift clusters

Example
-------
- Marketing department needs to store blobs (audio, images, video clips) for various
advertising campaigns
- Finance department needs to store scanned images of invoices, receipts,
contracts, etc.
- Suppose marketing department files must be stored in separate cluster due to
legal or regulatory requirements
- 1 set of servers for shared infrastructure
- Set up 2 Swift clusters - a 'Marketing' Swift cluster and a 'Finance' Swift
cluster
- Each cluster gets their own disk drives for storing data
    - Marketing: /srv/swift-mkt-disk
    - Finance: /srv/swift-fin-disk
- Swift Configuration files path
    - /etc/swift-mkt/swift.conf
    - /etc/swift-fin/swift.conf
- Proxy Ports
    - Marketing: 8180
    - Finance: 8280
- Storage Ports
    - Marketing: port ranges 61** - 61**
    - Finance: port ranges 62** - 62**
- Memcached
    - Marketing memcached running on port 11212
    - Finance memcached running on port 11213
- Run Directory
    - Marketing: /var/run/swift-mkt
    - Finance: /var/run/swift-fin
- Cache Directory
    - Marketing: /var/cache/swift-mkt*
    - Finance: /var/cache/swift-fin*
- Logs
    - Marketing: /var/log/swift-mkt
    - Finance: /var/log/swift-fin

Installation Overview
---------------------
This project includes set of bash scripts with inline comments to install Multi-Swift. 
This setup mimics the layout of [SAIO - Swift All In One](http://docs.openstack.org/developer/swift/development_saio.html)

- The swift configuration directory must be specified using environment variable SWIFT_ROOT (exported in openrc).

- Similarly, swift run directory must be set using SWIFT_RUN_DIR (exported in openrc).

- openrc file contains crucial information regarding environment variables that need
to be exported into the environment before starting Swift services

- The "clusters.txt" file specifies the identifiers associated with each Swift cluster. 
These identifiers are important to distinguish one cluster from the other. In the example,
they are "mkt" (Marketing) and "fin" (Finance).

- The install scripts create a separate OS user per cluster. 
e.g. swift-mkt (Marketing) and swift-fin (Finance)

- Each user (i.e. swift-mkt/swift-fin) gets their own clone of 'swift'
and 'python-swiftclient' repositories

- Importantly, each user gets their own copy of openrc file with environment
variables specific to their respective profiles. These openrc files are created
in their home directory (e.g. /home/swift-mkt/openrc).

- start_swift and stop_swift scripts are copied into each users' (i.e. swift-mkt) home directory.

NOTE: These scripts are targeted and tested for Ubuntu 14.04

##Order of execution:

```bash
1. sudo ./sys_swift_check_users.sh
2. sudo ./sys_swift_install_deps.sh
3. sudo ./sys_swift_setup.sh
4. sudo ./make_openrc.sh
```

At this point, both Swift clusters are installed and configured. 

Start swift-mkt cluster:

```bash
1. sudo su - swift-mkt
2. source /home/swift-mkt/openrc
3. sh /home/swift-mkt/start_swift.sh
```

Start swift-fin cluster:

```bash
1. sudo su - swift-fin
2. source /home/swift-fin/openrc
3. sh /home/swift-fin/start_swift.sh
```

Stop swift-mkt cluster:

```bash
sudo sh /home/swift-mkt/stop_swift.sh
```

Stop swift-fin cluster:

```bash
sudo sh /home/swift-fin/stop_swift.sh
```

##Remove Swift:

```bash
1. sudo sh /home/swift-cluster-user-home/stop_swift.sh
2. sudo sh /path/to/cloned/multi-swift-poc-repo/sys_swift_remove.sh
```
