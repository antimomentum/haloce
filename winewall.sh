
echo "sysctl -w net.ipv6.conf.all.disable_ipv6=1" | bash
echo "sysctl -w net.ipv6.conf.default.disable_ipv6=1" | bash
echo "sysctl -w net.ipv6.conf.lo.disable_ipv6=1" | bash
wait
tc qdisc replace dev eth0 root prio priomap 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
tc qdisc add dev eth0 ingress
tc filter add dev eth0 parent ffff: u32 match ip sport 53 0xffff action drop
wait
ipset create LEGIT hash:ip timeout 10
ipset create TEST2 hash:ip timeout 20
ipset create TEST1 hash:ip timeout 20
ipset create MDNS hash:ip
ipset add MDNS 54.82.252.156
ipset add MDNS 34.197.71.170
ipset create TESTS list:set
ipset add TESTS TEST1
ipset add TESTS MDNS
iptables -t raw -N ctest2
iptables -t raw -N pcheck
iptables -t raw -N legit
iptables -t raw -A PREROUTING ! -p udp -j DROP
iptables -t raw -A PREROUTING -i eth0 -p udp -m udp ! --dport 2302 -j DROP
iptables -t raw -A PREROUTING -i eth0 -p udp -m udp --dport 2302 -m set --match-set TESTS src -j pcheck
iptables -t raw -A PREROUTING -i eth0 -p udp -m udp --dport 2302 -m length ! --length 48 -j DROP
iptables -t raw -A PREROUTING -i eth0 -p udp -m udp --dport 2302 -m u32 ! --u32 "42=0x1333360c" -j DROP
iptables -t raw -A PREROUTING -i eth0 -p udp -m udp --dport 2302 -j SET --exist --add-set TEST1 src
iptables -t raw -A PREROUTING -i eth0 -p udp -m udp --dport 2302 -j ACCEPT
iptables -t raw -A PREROUTING -i eth0 -j DROP
iptables -t raw -A pcheck -j SET --exist --add-set TEST1 src
iptables -t raw -A pcheck -m set --match-set LEGIT src -j SET --exist --add-set LEGIT src
iptables -t raw -A pcheck -m set --match-set LEGIT src -j ACCEPT
iptables -t raw -A pcheck -m u32 --u32 "42=0x1333360c" -j ACCEPT
iptables -t raw -A pcheck -m set --match-set TEST2 src -j ctest2
iptables -t raw -A pcheck -s 34.197.71.170 -j ACCEPT
iptables -t raw -A pcheck -s 54.82.252.156 -j ACCEPT
iptables -t raw -A pcheck -m u32 --u32 "28=0x5C717565" -j ACCEPT
iptables -t raw -A pcheck -m u32 ! --u32 "34&0xFFFFFF=0xFFFFFF" -j DROP
iptables -t raw -A pcheck -j SET --exist --add-set TEST2 src
iptables -t raw -A pcheck -j ACCEPT
iptables -t raw -A ctest2 -m u32 --u32 "42=0x1333360c" -j ACCEPT
iptables -t raw -A ctest2 -m u32 --u32 "28=0xfefe0100" -j SET --exist --add-set LEGIT src
iptables -t raw -A ctest2 -m set --match-set LEGIT src -j ACCEPT
iptables -t raw -A ctest2 -m u32 --u32 "28=0x5C717565" -j ACCEPT
iptables -t raw -A ctest2 -m u32 --u32 "34&0xFFFFFF=0xFFFFFF" -j ACCEPT
iptables -t raw -A ctest2 -j DROP
iptables -A INPUT -i eth0 -p udp -m udp --dport 2302 -m set --match-set LEGIT src -j ACCEPT
iptables -A INPUT -i eth0 -p udp -m udp --dport 2302 -m set --match-set TEST2 src -j ACCEPT
iptables -A INPUT -i eth0 -p udp -m udp --dport 2302 -m set --match-set TEST1 src -j ACCEPT
iptables -A INPUT -i eth0 -m set --match-set MDNS src -j ACCEPT
iptables -A INPUT -j DROP
iptables -P FORWARD  DROP
