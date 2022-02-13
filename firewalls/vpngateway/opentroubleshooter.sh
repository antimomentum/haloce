iptables -t nat -I PREROUTING -i eth0 -j DNAT --to-destination 10.0.0.2
iptables -A FORWARD -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
