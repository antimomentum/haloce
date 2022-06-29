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
ipset create BLOCK hash:ip timeout 300
ipset create MDNS hash:ip
wait
ipset add MDNS 54.82.252.156
ipset add MDNS 34.197.71.170
# ipset add MDNS api.linode.com
ipset create TESTS list:set
ipset add TESTS TEST1
ipset add TESTS MDNS
wait
iptables -t raw -N pcheck
iptables -t mangle -N ctest2
iptables -t raw -A PREROUTING -j NOTRACK
iptables -t raw -A PREROUTING -i eth0 -m set --match-set TESTS src -j ACCEPT
iptables -t raw -A PREROUTING -i eth0 -m length --length 48  -j pcheck
iptables -t raw -A PREROUTING -i eth0 -m length ! --length 67 -j DROP
iptables -t raw -A PREROUTING -i eth0 -m u32 --u32 "28=0xfefe0100" -j pcheck
iptables -t raw -A PREROUTING -i eth0 -j DROP
iptables -t raw -A pcheck -p udp --sport 53 -j DROP
iptables -t raw -A pcheck -m set --match-set BLOCK src -j DROP
iptables -t raw -A pcheck -p udp --sport 0 -j SET --exist --add-set BLOCK src
iptables -t raw -A pcheck -m set --match-set BLOCK src -j DROP
iptables -t raw -A pcheck ! -p udp -j SET --exist --add-set BLOCK src
iptables -t raw -A pcheck -p udp ! --dport 2302:2502 -j SET --exist --add-set BLOCK src
iptables -t raw -A pcheck -m length --length 48 -m u32 --u32 "42=0x1333360c" -j SET --exist --add-set TEST1 src
iptables -t raw -A pcheck -m length --length 67 -m u32 --u32 "28=0xfefe0100" -j SET --exist --add-set TEST1 src
iptables -t raw -A pcheck -m set --match-set TEST1 src -j ACCEPT
iptables -t raw -A pcheck -j DROP
iptables -t mangle -A PREROUTING -i eth0 -j SET --exist --add-set TEST1 src
iptables -t mangle -A PREROUTING -i eth0 -m set --match-set LEGIT src,src -j SET --exist --add-set LEGIT src,src
iptables -t mangle -A PREROUTING -i eth0 -m set --match-set LEGIT src,src -j ACCEPT
iptables -t mangle -A PREROUTING -i eth0 -m set --match-set BLOCK src -j DROP
iptables -t mangle -A PREROUTING -i eth0 -m set --match-set MDNS src -j ACCEPT
iptables -t mangle -A PREROUTING -i eth0 -m set --match-set TEST1 src -j ctest2
iptables -t mangle -A PREROUTING -i eth0 -j DROP
iptables -t mangle -A ctest2 -m recent --name badguy3 --set
iptables -t mangle -A ctest2 -m recent --update --name badguy3 --seconds 60 --hitcount 15 -j SET --exist --add-set BLOCK src
iptables -t mangle -A ctest2 -p udp --sport 0 -j SET --exist --add-set BLOCK src
iptables -t mangle -A ctest2 ! -p udp -j SET --exist --add-set BLOCK src
iptables -t mangle -A ctest2 -p udp ! --dport 2302:2502 -j SET --exist --add-set BLOCK src
iptables -t mangle -A ctest2 -p udp --sport 53 -j SET --exist --add-set BLOCK src
iptables -t mangle -A ctest2 -m set --match-set BLOCK src -j DROP
iptables -t mangle -A ctest2 -m length --length 31 -m u32 --u32 "27&0x00FFFFFF=0x00fefe68" -j ACCEPT
iptables -t mangle -A ctest2 -m u32 --u32 "28=0xfefe0100" -j SET --exist --add-set LEGIT src,src
iptables -t mangle -A ctest2 -m set --match-set LEGIT src,src -j ACCEPT
iptables -t mangle -A ctest2 -m length --length 34 -m u32 --u32 "28=0x5C717565" -j ACCEPT
iptables -t mangle -A ctest2 -m length --length 48 -m u32 --u32 "42=0x1333360c" -j ACCEPT
iptables -t mangle -A ctest2 -m u32 --u32 "34&0xFFFFFF=0xFFFFFF" -j ACCEPT
iptables -t mangle -A ctest2 -j DROP
