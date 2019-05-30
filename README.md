# Monitoring for SecureDrop instances
Automation code for Prometheus, Alertmanager, Grafana and blackbox-exporter.

Configured to check for availability of Tor hidden services. The flow is like blackbox_exporter (HTTP requests over Tor, via Privoxy) → Prometheus (time series numerical metric database with querying and alerting capabilities) → Grafana (visualization) + Alertmanager (notification).

Prometheus is a pull-based monitoring system, it makes a periodic GET request to an HTTP metrics endpoint (which is termed scraping) hosted by blackbox_exporter (which can be configured to look for HTTP 2xx responses) in order to obtain the results of probes against certain targets. blackbox_exporter utilizes Privoxy's HTTP proxy which in turn uses Tor's SOCKS port.

Make sure intra-container network communication is possible. Recommended `DOCKER_OPTS`:
    
    --ip-forward=true --iptables=true --userland-proxy=true --log-level=debug --icc=true

Getting started
---------------

The configuration management is done with [Ansible](https://www.ansible.com/), which may be obtained via Python's [pip](https://bootstrap.pypa.io/get-pip.py). 

We're also leveraging Docker and docker-compose, yet it's managed through the Ansible Docker modules. This playbook expects you to have a working docker, which your user is able to access either through the default Docker Unix socket or a TLS-enabled DOCKER_HOST. Because of recent features and changes in those modules, we require Ansible 2.8.0 or later. 

Once you have all the requirements in `requirements.txt` (feel free to bootstrap a virtualenv if needed) installed, then one may execute the playbook at `securedrop-monitoring.yml`.

Subsequently, you should have sites for each component available at:

* http://localhost/prometheus
* http://localhost/grafana
* http://localhost/alertmanager