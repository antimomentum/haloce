tc filter add dev eth0 parent ffff: u32 match ip sport 53 0xffff action drop
iptables -t raw -D PREROUTING -i eth0 -m set --match-set DNS src -j ACCEPT
ipset destroy DNS
