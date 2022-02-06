iptables -t nat -D PREROUTING -i eth0 -m udp -p udp --dport 2302 -j DNAT --to-destination 10.0.0.2:2302
iptables -t nat -D PREROUTING -i eth0 -m udp -p udp --dport 2304 -j DNAT --to-destination 10.0.0.4:2304
# iptables -t nat -F
# iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -t raw -F
iptables -t raw -X
ipset destroy LEGIT
ipset destroy TEST1
ipset destroy TEST2
ipset destroy MDNS
