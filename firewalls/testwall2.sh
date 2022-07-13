sysctl -w net.ipv6.conf.all.disable_ipv6=1 
sysctl -w net.ipv6.conf.default.disable_ipv6=1 
sysctl -w net.ipv6.conf.lo.disable_ipv6=1
sysctl -w net.ipv4.ipfrag_low_thresh=0
sysctl -w net.ipv4.ipfrag_high_thresh=0
sysctl -w net.ipv4.ipfrag_time=0
# sysctl -w net.ipv4.ip_forward=1
# sysctl -w net.core.netdev_max_backlog=4000
ipset create TEST1 hash:ip,port timeout 80
ipset create MDNS hash:ip
wait
ipset add MDNS 54.82.252.156
ipset add MDNS 34.197.71.170
wait
tc qdisc add dev eth0 ingress
tc filter add dev eth0 parent ffff: priority 1 basic match 'ipset(TEST1 src)' action pass
tc filter add dev eth0 parent ffff: priority 2 protocol ip u32 match u32 0x0103080a 0xffffffff at nexthdr+36 action pass
tc filter add dev eth0 parent ffff: priority 3 u32 match ip dport 2302 0xffff action drop
wait
sleep 1
iptables -t raw -N pcheck
iptables -t raw -A PREROUTING -j NOTRACK
iptables -t raw -A PREROUTING -i eth0 -m set --match-set TEST1 src,src -j ACCEPT
iptables -t raw -A PREROUTING -i eth0 -m length --length 48 -m u32 --u32 "42=0x1333360c" -j pcheck
iptables -t raw -A PREROUTING -i eth0 -j DROP
iptables -t raw -A pcheck -p udp --sport 53 -j DROP
iptables -t raw -A pcheck -p udp --sport 0 -j DROP
iptables -t raw -A pcheck ! -p udp -j DROP
iptables -t raw -A pcheck -p udp ! --dport 2302 -j DROP
iptables -t raw -A pcheck -j SET --exist --add-set TEST1 src
iptables -t raw -A pcheck -j ACCEPT
iptables -t mangle -A PREROUTING -i eth0 -j SET --exist --add-set TEST1 src,src
iptables -t mangle -A PREROUTING -i eth0 -m set --match-set TEST1 src,src -j ACCEPT
iptables -t mangle -A PREROUTING -i eth0 -m set --match-set MDNS src -j ACCEPT
iptables -t mangle -A PREROUTING -i eth0 -j DROP
