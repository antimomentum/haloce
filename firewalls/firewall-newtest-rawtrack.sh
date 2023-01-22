interface=$1
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 
sysctl -w net.ipv6.conf.lo.disable_ipv6=1
sysctl -w net.ipv4.ipfrag_low_thresh=0
sysctl -w net.ipv4.ipfrag_high_thresh=0
sysctl -w net.ipv4.ipfrag_time=0
# sysctl -w net.ipv4.ip_forward=1
sysctl -w net.core.netdev_max_backlog=4000
ipset create BLOCK hash:ip timeout 300
ipset create WHITELIST hash:ip
ipset add WHITELIST 54.82.252.156
ipset create BAN hash:ip
ipset create BAN2 hash:ip
ipset create BANS list:set
ipset add BANS BAN
ipset add BANS BAN2
ipset create RAWTRACK hash:ip,port timeout 60
iptables -t mangle -N ctest2
iptables -t mangle -N reconnect
iptables -t mangle -N ban
iptables -t mangle -N ban2
iptables -t raw -A PREROUTING -i $interface -m set --match-set RAWTRACK src,dst -j ACCEPT
iptables -t raw -A PREROUTING -i $interface -m set --match-set WHITELIST src -j ACCEPT
iptables -t raw -A PREROUTING -i $interface -m length --length 48 -m u32 --u32 "42=0x1333360c" -j ACCEPT
iptables -t raw -A PREROUTING -i $interface -m length ! --length 67 -j DROP
iptables -t raw -A PREROUTING -i $interface -m u32 --u32 "28=0xfefe0100" -j ACCEPT
iptables -t raw -A PREROUTING -i $interface -j DROP
iptables -t mangle -A PREROUTING -i $interface -p udp -m hashlimit --hashlimit-name DOSBAN2 --hashlimit-mode srcip --hashlimit-srcmask 32 --hashlimit-above 900/second --hashlimit-burst 300 -j ban
iptables -t mangle -A PREROUTING -i $interface -p udp -m length --length 31 -m set --match-set RAWTRACK src,dst -m u32 --u32 "27&0x00FFFFFF=0x00fefe68" -j reconnect
iptables -t mangle -A PREROUTING -i $interface -m set --match-set RAWTRACK src,dst -j ACCEPT
iptables -t mangle -A PREROUTING -i $interface -m set --match-set WHITELIST src -j ACCEPT
iptables -t mangle -A PREROUTING -i $interface -m set --match-set BANS src -j DROP
iptables -t mangle -A PREROUTING -i $interface -j ctest2
iptables -t mangle -A ctest2 -m set --match-set BLOCK src -j DROP
iptables -t mangle -A ctest2 -s 34.197.71.170 -j ACCEPT
iptables -t mangle -A ctest2 -s 54.82.252.156 -j ACCEPT
iptables -t mangle -A ctest2 -p udp --sport 0 -j SET --exist --add-set BLOCK src
iptables -t mangle -A ctest2 ! -p udp -j SET --exist --add-set BLOCK src
iptables -t mangle -A ctest2 -m recent --name badguy3 --set
iptables -t mangle -A ctest2 -m recent --update --name badguy3 --seconds 5 --hitcount 15 -j SET --exist --add-set BLOCK src
iptables -t mangle -A ctest2 -m connlimit --connlimit-above 5 --connlimit-mask 32 -j DROP
iptables -t mangle -A ctest2 -p udp --sport 53 -j SET --exist --add-set BLOCK src
iptables -t mangle -A ctest2 -m set --match-set BLOCK src -j DROP
iptables -t mangle -A ctest2 -m u32 --u32 "28=0xfefe0100" -j ACCEPT
iptables -t mangle -A ctest2 -m length --length 34 -m u32 --u32 "28=0x5C717565" -j ACCEPT
iptables -t mangle -A ctest2 -m length --length 48 -m u32 --u32 "42=0x1333360c" -j ACCEPT
iptables -t mangle -A ctest2 -m u32 --u32 "34&0xFFFFFF=0xFFFFFF" -j ACCEPT
iptables -t mangle -A ctest2 -j DROP
iptables -t mangle -A reconnect -j SET --del-set RAWTRACK src,dst
iptables -t mangle -A reconnect -j ACCEPT
iptables -t mangle -A ban -j SET --del-set RAWTRACK src,dst
iptables -t mangle -A ban -j SET --exist --add-set BAN src
iptables -t mangle -A ban -j DROP
iptables -t mangle -A ban2 -j SET --exist --add-set BAN2 src
iptables -t mangle -A ban2 -j SET --del-set RAWTRACK src,dst
iptables -t mangle -A ban2 -j DROP
iptables -t mangle -A POSTROUTING -o $interface -j SET --exist --add-set RAWTRACK dst,src

# Only lasts for the RAWTRACK timeout, you might need to re-run this before actually starting the halo server:
# ipset add RAWTRACK 54.82.252.156,udp:49946
