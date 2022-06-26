#!/bin/bash
sudo modprobe br_netfilter
sudo sed -i 's/net.ipv4.conf.all.rp_filter=0/net.ipv4.conf.all.rp_filter=1/g' /etc/sysctl.conf
sudo sed -i 's/net.ipv4.ip_forward=0/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sudo set -i 's/net.ipv4.conf.default.rp_filter=0/net.ipv4.conf.default.rp_filter=1/g' /etc/sysctl.conf
sudo sysctl -p
