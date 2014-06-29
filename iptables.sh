#!/bin/sh
# simple fasting script
# blocks everything external, except during the free-for-all slot

# reset everything
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F
iptables -X

# behave nicely
iptables -A INPUT -p icmp -j ACCEPT
#iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# the chain that does not imprison, but free your mind
iptables -N open
iptables -A INPUT -j open
iptables -A OUTPUT -j open

# accept all local traffic
iptables -A open -i lo -j ACCEPT
iptables -A open -s 192.168.1.0/24 -j ACCEPT
iptables -A open -s 127.0.0.1 -j ACCEPT

# block the rest, in a not-so-rude way :)
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# save
/etc/init.d/iptables save
