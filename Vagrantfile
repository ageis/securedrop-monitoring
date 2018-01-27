# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "debian/stretch64"

  config.vm.define 'securedrop-monitoring', autostart: true do |sdmonitoring|
    sdmonitoring.vm.hostname = "securedrop.monitoring"
    sdmonitoring.vm.network "private_network", type: "dhcp"
    sdmonitoring.vm.network "forwarded_port", guest: 80, host: 80, auto_correct: true
    sdmonitoring.vm.network "forwarded_port", guest: 443, host: 443, auto_correct: true
    sdmonitoring.vm.network "forwarded_port", guest: 53, host: 53, auto_correct: true
    sdmonitoring.vm.network "forwarded_port", guest: 5353, host: 5353, auto_correct: true
    sdmonitoring.vm.network "forwarded_port", guest: 3000, host: 3000, auto_correct: true
    sdmonitoring.vm.network "forwarded_port", guest: 8118, host: 8118, auto_correct: true
    sdmonitoring.vm.network "forwarded_port", guest: 9090, host: 9090, auto_correct: true
    sdmonitoring.vm.network "forwarded_port", guest: 9093, host: 9093, auto_correct: true
    sdmonitoring.vm.network "forwarded_port", guest: 9115, host: 9115, auto_correct: true
    sdmonitoring.vm.provision :ansible do |ansible|
      ansible.raw_arguments = Shellwords.shellsplit(ENV['ANSIBLE_ARGS']) if ENV['ANSIBLE_ARGS']
      ansible.playbook = "securedrop-monitoring.yml"
      ansible.verbose = "v"
    end
    sdmonitoring.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 1
    end
  end 

end
