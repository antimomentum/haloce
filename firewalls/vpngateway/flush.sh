iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -t raw -F
iptables -t raw -X
ipset destroy LEGIT
ipset destroy TEST1
ipset destroy TEST2
ipset destroy MDNS
