# Assumes public interface name eth0
# Uncomment the BOTTOM lines for a NAT gateway, 10.0.0.2 is a VLAN ip example. Also uncomment the sysctl ip_forward setting.
# Requires ipset: apt install ipset -y
# Add your ip to MDNS for ssh
# Compatible with Wine-only and Docker
# If using wine-only the master server ips must be in hosts if NOT using gateway:
# echo "34.197.71.170 hosthpc.com" >> /etc/hosts
# echo "34.197.71.170 s1.master.hosthpc.com" >> /etc/hosts

# If using Docker, the master ips can be added in the docker run command:
# docker run -e INTERNAL_PORT=2302 -it -p 2302:2302/udp --add-host=s1.master.hosthpc.com:34.197.71.170 --add-host=hosthpc.com:34.197.71.170 antimomentum/halo
# docker-compose already has the hosts in the example yml file.

# Rebooting will flush ALL rules/changes below
wait
sysctl -w net.ipv4.ipfrag_low_thresh=0
sysctl -w net.ipv4.ipfrag_high_thresh=0
sysctl -w net.ipv4.ipfrag_time=0
sysctl -w net.ipv6.conf.all.disable_ipv6=1 
sysctl -w net.ipv6.conf.default.disable_ipv6=1 
sysctl -w net.ipv6.conf.lo.disable_ipv6=1 
# sysctl -w net.ipv4.ip_forward=1
sysctl -w net.core.netdev_max_backlog=4000
wait
sleep 1
ipset create LEGIT hash:ip timeout 10
ipset create TEST2 hash:ip timeout 30
ipset create TEST1 hash:ip timeout 80
ipset create MDNS hash:ip
ipset create TESTS list:set
ipset add TESTS LEGIT
ipset add TESTS MDNS
wait
ipset add MDNS 54.82.252.156
ipset add MDNS 34.197.71.170
wait
iptables -t raw -N ctest2
iptables -t raw -N pcheck
iptables -t raw -I PREROUTING -i eth0 -p udp --sport 0 -j DROP
iptables -t raw -A PREROUTING -i eth0 -m set --match-set TESTS src -j ACCEPT
iptables -t raw -A PREROUTING -i eth0 -m length --length 48 -m u32 --u32 "35=0x0a010308" -j pcheck
iptables -t raw -A PREROUTING -i eth0 -m set --match-set TEST1 src -j pcheck
iptables -t raw -A PREROUTING -i eth0 -m length ! --length 34 -j DROP
iptables -t raw -A PREROUTING -i eth0 -m u32 ! --u32 "28=0x5C717565" -j DROP
iptables -t raw -A PREROUTING -i eth0 -j ctest2
iptables -t raw -A pcheck -j SET --exist --add-set TEST1 src
iptables -t raw -A pcheck -m u32 --u32 "42=0x1333360c" -j ACCEPT
iptables -t raw -A pcheck -m set --match-set TEST2 src -j ctest2
iptables -t raw -A pcheck -m u32 --u32 "28=0x5C717565" -j ACCEPT
iptables -t raw -A pcheck -m u32 ! --u32 "34&0xFFFFFF=0xFFFFFF" -j DROP
iptables -t raw -A pcheck -j SET --exist --add-set TEST2 src
iptables -t raw -A pcheck -j ACCEPT
iptables -t raw -A ctest2 -j SET --exist --add-set TEST1 src
iptables -t raw -A ctest2 -j SET --exist --add-set TEST2 src
iptables -t raw -A ctest2 -m u32 --u32 "28=0xfefe0100" -j SET --exist --add-set LEGIT src
iptables -t raw -A ctest2 -m set --match-set LEGIT src -j ACCEPT
iptables -t raw -A ctest2 -m u32 --u32 "28=0x5C717565" -j ACCEPT
iptables -t raw -A ctest2 -m u32 --u32 "42=0x1333360c" -j ACCEPT
iptables -t raw -A ctest2 -m u32 --u32 "34&0xFFFFFF=0xFFFFFF" -j ACCEPT
iptables -t raw -A ctest2 -j DROP
iptables -t mangle -A PREROUTING -i eth0 -m set --match-set LEGIT src -j SET --exist --add-set LEGIT src
# iptables -t nat -A PREROUTING -i eth0 -m udp -p udp --dport 2302 -j DNAT --to-destination 10.0.0.2:2302
# iptables -t nat -A PREROUTING -i eth0 -m udp -p udp --dport 2304 -j DNAT --to-destination 10.0.0.2:2304
# iptables -I FORWARD -j ACCEPT
# iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
