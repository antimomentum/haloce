# Expermental firewall that leverages the tc ingress filter in the Linux kernel to drop flood packets faster than iptables (ideally)

# Also currently only works for halo's default port 2302

# Assumes interface name eth0

# Disables conntrack in the kernel, currently functions with wine on the host (vlans/vpn/etc) won't work with this firewall.


sysctl -w net.ipv6.conf.all.disable_ipv6=1 
sysctl -w net.ipv6.conf.default.disable_ipv6=1 
sysctl -w net.ipv6.conf.lo.disable_ipv6=1
sysctl -w net.ipv4.ipfrag_low_thresh=0
sysctl -w net.ipv4.ipfrag_high_thresh=0
sysctl -w net.ipv4.ipfrag_time=0
# sysctl -w net.ipv4.ip_forward=1
sysctl -w net.core.netdev_max_backlog=4000
ipset create LEGIT hash:ip,port timeout 10
ipset create TEST1 hash:ip timeout 80
ipset create MDNS hash:ip
wait
ipset add MDNS 54.82.252.156
ipset add MDNS 34.197.71.170
ipset add TEST1 54.82.252.156
ipset add TEST1 34.197.71.170
wait
tc qdisc add dev eth0 ingress
tc filter add dev eth0 parent ffff: priority 1 basic match 'ipset(TEST1 src)' action pass
tc filter add dev eth0 parent ffff: priority 2 protocol ip u32 match u32 0x0103080a 0xffffffff at nexthdr+36 action pass
tc filter add dev eth0 parent ffff: priority 3 u32 match ip dport 2302 0xffff action drop
wait
sleep 1
iptables -t raw -N pcheck
iptables -t mangle -N ctest2
iptables -t raw -A PREROUTING -j NOTRACK
iptables -t raw -A PREROUTING -i eth0 -m set --match-set TEST1 src -j ACCEPT
iptables -t raw -A PREROUTING -i eth0 -m length --length 48 -m u32 --u32 "42=0x1333360c" -j pcheck
iptables -t raw -A PREROUTING -i eth0 -j DROP
iptables -t raw -A pcheck -p udp --sport 53 -j DROP
iptables -t raw -A pcheck -p udp --sport 0 -j DROP
iptables -t raw -A pcheck ! -p udp -j DROP
iptables -t raw -A pcheck -p udp ! --dport 2302:2502 -j DROP
iptables -t raw -A pcheck -s 224.0.0.0/3 -j DROP 
iptables -t raw -A pcheck -s 169.254.0.0/16 -j DROP 
iptables -t raw -A pcheck -s 172.16.0.0/12 -j DROP 
iptables -t raw -A pcheck -s 192.0.2.0/24 -j DROP 
iptables -t raw -A pcheck -s 192.168.0.0/16 -j DROP 
iptables -t raw -A pcheck -s 10.0.0.0/8 -j DROP 
iptables -t raw -A pcheck -s 0.0.0.0/8 -j DROP 
iptables -t raw -A pcheck -s 240.0.0.0/5 -j DROP 
iptables -t raw -A pcheck -s 127.0.0.0/8 -j DROP
iptables -t raw -A pcheck -j SET --exist --add-set TEST1 src
iptables -t raw -A pcheck -j ACCEPT
iptables -t mangle -A PREROUTING -i eth0 -j SET --exist --add-set TEST1 src
iptables -t mangle -A PREROUTING -i eth0 -m set --match-set LEGIT src,src -j SET --exist --add-set LEGIT src,src
iptables -t mangle -A PREROUTING -i eth0 -m set --match-set LEGIT src,src -j ACCEPT
iptables -t mangle -A PREROUTING -i eth0 -m set --match-set MDNS src -j ACCEPT
iptables -t mangle -A PREROUTING -i eth0 -m set --match-set TEST1 src -j ctest2
iptables -t mangle -A PREROUTING -i eth0 -j DROP
iptables -t mangle -A ctest2 -p udp --sport 0 -j DROP
iptables -t mangle -A ctest2 ! -p udp -j DROP
iptables -t mangle -A ctest2 -p udp ! --dport 2302:2502 -j DROP
iptables -t mangle -A ctest2 -p udp --sport 53 -j DROP
iptables -t mangle -A ctest2 -s 224.0.0.0/3 -j DROP 
iptables -t mangle -A ctest2 -s 169.254.0.0/16 -j DROP 
iptables -t mangle -A ctest2 -s 172.16.0.0/12 -j DROP 
iptables -t mangle -A ctest2 -s 192.0.2.0/24 -j DROP 
iptables -t mangle -A ctest2 -s 192.168.0.0/16 -j DROP 
iptables -t mangle -A ctest2 -s 10.0.0.0/8 -j DROP 
iptables -t mangle -A ctest2 -s 0.0.0.0/8 -j DROP 
iptables -t mangle -A ctest2 -s 240.0.0.0/5 -j DROP 
iptables -t mangle -A ctest2 -s 127.0.0.0/8 -j DROP
iptables -t mangle -A ctest2 -m u32 --u32 "28=0xfefe0100" -j SET --exist --add-set LEGIT src,src
iptables -t mangle -A ctest2 -m set --match-set LEGIT src,src -j ACCEPT
iptables -t mangle -A ctest2 -m length --length 34 -m u32 --u32 "28=0x5C717565" -j ACCEPT
iptables -t mangle -A ctest2 -m length --length 48 -m u32 --u32 "42=0x1333360c" -j ACCEPT
iptables -t mangle -A ctest2 -m u32 --u32 "34&0xFFFFFF=0xFFFFFF" -j ACCEPT
iptables -t mangle -A ctest2 -j DROP
