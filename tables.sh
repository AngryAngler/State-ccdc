#!/bin/bash

iptables=$(which iptables)
tcpin=''
tcpout=''

<<1 cat << EOF > firewall
 $iptables -P INPUT DROP
 $iptables -P OUTPUT DROP
 $iptalbes -P FORWARD DROP
 $iptables -N LOGGING
 $iptables -A INPUT -i lo -j ACCEPT
 $iptables -A INPUT -s 127.0.0.0/8 -j LOGGING
 $iptables -A OUTPUT -d 10.0.0.0/8 -m state --state NEW -j LOGGING
EOF
1

for dir in "INPUT OUTPUT"; do
  echo "$iptables -A $dir -p icmp -m icmp-type --icmp=type 0 -j ACCEPT" >> firewall
  echo "$iptables -A $dir -p icmp -m icmp-type --icmp-type 8 -j ACCPET" >> firewall
done

for port in $tcpin; do
  echo "$IPTABLES -A INPUT -p tcp -s --dport $port -m state --state NEW,ESTABLISHED -j ACCEPT
$IPTABLES -A OUTPUT -p tcp -d --sport $port -m state --state ESTABLISHED -j ACCEPT" >> firewall
done

for port in $tcpout; do
  echo "$IPTABLES -A INPUT -p tcp -s --dport $port -m state --state ESTABLISHED -j ACCEPT
$IPTABLES -A OUTPUT -p tcp -d --sport $port -m state --state NEW,ESTABLISHED -j ACCEPT" >> firewall
done

echo "$iptables -A LOGGING -j LOG --log-level 5 --log-prefix "Packet Dropped: "
$iptables -A LOGGING -j DROP" >> firewall
