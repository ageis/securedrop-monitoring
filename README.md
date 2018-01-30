# Monitoring for SecureDrop instances
Automation code for Prometheus, Alertmanager, Grafana and blackbox-exporter.

Configured to check for availability of Tor hidden services. The flow is like blackbox_exporter (HTTP requests over Tor, via Privoxy) → Prometheus (time series numerical metric database with querying and alerting capabilities) → Grafana (visualization) + Alertmanager (notification).

Prometheus is a pull-based monitoring system, it makes a periodic GET request to an HTTP metrics endpoint (which is termed scraping) hosted by blackbox_exporter (which can be configured to look for HTTP 2xx responses) in order to obtain the results of probes against certain targets.

As Tor can transparently proxy TCP, but is not an HTTP proxy, Privoxy is used since Prometheus's blackbox_exporter does not support SOCKS. DNS lookups for .onions are facilitated by enabling Tor's DNSPort+AutomapHostsOnResolve+VirtualAddrNetworkIPv4 options, which returns fake IPv4 addresses. dnsmasq is included for caching of DNS queries. 

Getting started
---------------

The configuration management is done with [Ansible](https://www.ansible.com/), which may be obtained via Python's [pip](https://bootstrap.pypa.io/get-pip.py).

We use Debian GNU/Linux (currently stretch or 9.x) for everything. Don't try running this code on another distribution and expect it to work.

All commands documented here are expected to be executed from root of this repository. Here's what one needs to have installed:

```
sudo pip install -U ansible
```

We recommend Ansible 2.4.2 or later.

Edit the hosts inventory at `inventory/hosts` and set the IP address for securedrop-monitoring. It's ideal to have some DNS subdomains pointing to that same server. I'd suggest the following pattern: Prometheus=monitoring, blackbox-exporter=metrics, Grafana=graphs, Alertmanager=alerts.

Then you may execute the playbook at `securedrop-monitoring.yml`.

There is some manual work involved to get the nginx frontend or reverse proxy for all services working. Edit `roles/securedrop-monitoring/defaults/main.yml` to put in some proper hostnames and then figure out what you need to do to obtain and use a Let's Encrypt cert; see `templates/nginx.conf.j2` in the same role for reference.

Extra tips for getting this to work
-----------------------------------

Edit /etc/resolv.conf and put `nameserver 127.0.0.1` at the top in order to enforce resolution through Tor (with caching provided by dnsmasq). The Go program will simply not know what to do without a fake virtual IP address provided by Tor's DNS server. You might also consider adding some iptables rules to direct outgoing DNS queries back to the machine.

Download and build Go from source and/or blackbox-exporter with the options `GODEBUG=netdns=cgo CGO_ENABLED=1`. Go seems to need the CGO resolver instead of its built-in one in order to process onion address correctly (this is why we also have `RES_OPTIONS` set).

If all else fails, try prepending `/usr/bin/torify` to the ExecStart command in blackbox-exporter's systemd service unit at `/lib/systemd/system/prometheus-blackbox-exporter.service`. 

Running locally in Vagrant
--------------------------

To try the role(s) out locally, use the following syntax:

```
vagrant up --provision securedrop-monitoring
```

We recommend Vagrant 2.0.1 or later.
