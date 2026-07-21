# requires ipset (apt install ipset)

# This firewall assumes you are already blocking TCP, ICMP, and IPv6 with a cloud/host firewall (some rules and settings are left in perhaps commented)

# The firewall expects you to supply the public interface name, for example: ./firewall.sh eth0

# This is not meant to replace ufw enable but is compatible with it

# It will probably lock you out of ssh, try adding an ssh client ip to WHITELIST before running

interface=$1
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 
sysctl -w net.ipv6.conf.lo.disable_ipv6=1
sysctl -w net.ipv4.ipfrag_low_thresh=0
sysctl -w net.ipv4.ipfrag_high_thresh=0
sysctl -w net.ipv4.ipfrag_time=0
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
sysctl -w fs.suid_dumpable=0
sysctl -w kernel.core_uses_pid=1
sysctl -w kernel.printk="4 4 1 7" 
sysctl -w kernel.panic=10 
sysctl -w kernel.sysrq=0 
sysctl -w kernel.shmmax=4294967296 
sysctl -w kernel.shmall=4194304 
sysctl -w kernel.core_uses_pid=1 
sysctl -w kernel.msgmnb=65536 
sysctl -w kernel.msgmax=65536 
sysctl -w vm.swappiness=20 
sysctl -w vm.dirty_ratio=80 
sysctl -w vm.dirty_background_ratio=5 
sysctl -w fs.file-max=2097152 
sysctl -w net.core.netdev_max_backlog=262144 
sysctl -w net.core.rmem_default=31457280 
sysctl -w net.core.rmem_max=67108864 
sysctl -w net.core.wmem_default=31457280 
sysctl -w net.core.wmem_max=67108864 
sysctl -w net.core.somaxconn=65535 
sysctl -w net.core.optmem_max=25165824 
sysctl -w net.ipv4.neigh.default.gc_thresh1=4096 
sysctl -w net.ipv4.neigh.default.gc_thresh2=8192 
sysctl -w net.ipv4.neigh.default.gc_thresh3=16384 
sysctl -w net.ipv4.neigh.default.gc_interval=5 
sysctl -w net.ipv4.neigh.default.gc_stale_time=120 
sysctl -w net.netfilter.nf_conntrack_max=10000000 
sysctl -w net.ipv4.ip_local_port_range="1024 65000"
sysctl -w net.ipv4.ip_no_pmtu_disc=1 
sysctl -w net.ipv4.route.flush=1 
sysctl -w net.ipv4.route.max_size=8048576 
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1 
sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1 
sysctl -w net.ipv4.udp_mem="65536 131072 262144"
sysctl -w net.ipv4.tcp_rmem="4096 87380 33554432"
sysctl -w net.ipv4.udp_rmem_min=16384
sysctl -w net.ipv4.udp_wmem_min=16384 
sysctl -w net.ipv4.ip_forward=0 
sysctl -w net.ipv4.conf.all.accept_redirects=0 
sysctl -w net.ipv4.conf.all.send_redirects=0 
sysctl -w net.ipv4.conf.all.accept_source_route=0 
sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w net.ipv4.ipfrag_low_thresh=0
sysctl -w net.ipv4.ipfrag_high_thresh=0
sysctl -w net.ipv4.ipfrag_time=0 
# sysctl -w net.ipv4.ip_forward=1
sysctl -w net.core.netdev_max_backlog=4000
ipset create BLOCK hash:ip timeout 300
ipset create WHITELIST hash:ip
ipset create BANNED hash:ip timeout 150
ipset add WHITELIST 54.82.252.156
ipset add WHITELIST 34.197.71.170
ipset create LEGIT hash:ip,port timeout 13
ipset create TEST1 hash:ip timeout 80
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
iptables -t mangle -N legitcheck
iptables -t mangle -N ban3
iptables -t raw -A PREROUTING -p udp -m udp -m length --length 60:60 -j DROP
iptables -t raw -A PREROUTING -p udp -m hashlimit --hashlimit-above 96/sec --hashlimit-burst 56 --hashlimit-mode srcip --hashlimit-name DOSBANLVL1 --hashlimit-htable-expire 600000 -j DROP
iptables -t raw -A PREROUTING -p udp -m hashlimit --hashlimit-above 112/sec --hashlimit-burst 56 --hashlimit-mode srcip --hashlimit-name DOSBANLVL2 --hashlimit-htable-expire 1200000 -j DROP
iptables -t raw -A PREROUTING -i $interface -p udp -m set --match-set BANNED src -j DROP
iptables -t raw -A PREROUTING -i $interface -j NOTRACK
iptables -t raw -A PREROUTING -i $interface -p udp -m set --match-set RAWTRACK src,dst -j ACCEPT
iptables -t raw -A PREROUTING -i $interface -m set --match-set WHITELIST src -j ACCEPT
#iptables -t raw -A PREROUTING -i $interface -p tcp -j DROP
iptables -t raw -A PREROUTING -i $interface -p udp -m length --length 48 -m u32 --u32 "42=0x1333360c" -j ACCEPT
iptables -t raw -A PREROUTING -i $interface -p udp -m length --length 34 -m u32 --u32 "28=0x5C717565" -j ACCEPT
iptables -t raw -A PREROUTING -i $interface -p udp -m length --length 37 -m u32 --u32 "29=0x73746174" -j ACCEPT
iptables -t raw -A PREROUTING -i $interface -p udp -m length ! --length 67 -j DROP
iptables -t raw -A PREROUTING -i $interface -p udp -m u32 --u32 "28=0xfefe0100" -j ACCEPT
iptables -t raw -A PREROUTING -i $interface -j DROP
iptables -t raw -A PREROUTING -i lo -j DROP
iptables -t mangle -A PREROUTING -i $interface -m length --length 31 -m set --match-set RAWTRACK src,dst -m u32 --u32 "27&0x00FFFF00=0x00fefe00" -j reconnect
iptables -t mangle -A PREROUTING -i $interface -m u32 --u32 "27&0x00FFFFFF=0x00fefd00" -j ctest2
iptables -t mangle -A PREROUTING -i $interface -m set --match-set LEGIT src,src -j SET --exist --add-set LEGIT src,src
iptables -t mangle -A PREROUTING -i $interface -m set --match-set RAWTRACK src,dst -m set --match-set LEGIT src,src -j ACCEPT
iptables -t mangle -A PREROUTING -i $interface -m set --match-set TEST1 src -j ctest2
# iptables -t mangle -A PREROUTING -i $interface -p tcp -m hashlimit --hashlimit-name DOSBAN2 --hashlimit-mode srcip --hashlimit-srcmask 32 --hashlimit-above 900/second --hashlimit-burst 300 -j ban
iptables -t mangle -A PREROUTING -i $interface -m set --match-set WHITELIST src -j ACCEPT
iptables -t mangle -A PREROUTING -i $interface -m set --match-set BANS src -j DROP
iptables -t mangle -A PREROUTING -i $interface -m set --match-set RAWTRACK src,dst -j ban3
iptables -t mangle -A PREROUTING -i $interface -j ctest2
iptables -t mangle -A ctest2 -m set --match-set BANNED src -j DROP
iptables -t mangle -A ctest2 -m set --match-set BLOCK src -j DROP
iptables -t mangle -A ctest2 -m set --match-set BANS src -j DROP
iptables -t mangle -A ctest2 -s 34.197.71.170 -j ACCEPT
iptables -t mangle -A ctest2 -s 54.82.252.156 -j ACCEPT
iptables -t mangle -A ctest2 -p udp --sport 0 -j SET --exist --add-set BLOCK src
iptables -t mangle -A ctest2 -m recent --name badguy3 --set
iptables -t mangle -A ctest2 -m recent --update --name badguy3 --seconds 1 --hitcount 15 -j ban2
#iptables -t mangle -A ctest2 -m connlimit --connlimit-above 5 --connlimit-mask 32 -j LOG --log-prefix "CONNLIMIT: "
#iptables -t mangle -A ctest2 -m connlimit --connlimit-above 5 --connlimit-mask 32 -j DROP
iptables -t mangle -A ctest2 -p udp --sport 53 -j SET --exist --add-set BLOCK src
iptables -t mangle -A ctest2 -p udp --dport 53 -j SET --exist --add-set BLOCK src
iptables -t mangle -A ctest2 -m set --match-set BLOCK src -j DROP
iptables -t mangle -A ctest2 -m length --length 67 -m u32 --u32 "28=0xfefe0100" -j legitcheck
iptables -t mangle -A ctest2 -m length --length 34 -m u32 --u32 "28=0x5C717565" -j SET --exist --add-set TEST1 src
iptables -t mangle -A ctest2 -m length --length 34 -m u32 --u32 "28=0x5C717565" -j ACCEPT
iptables -t mangle -A ctest2 -m length --length 48 -m u32 --u32 "42=0x1333360c" -j SET --exist --add-set TEST1 src
iptables -t mangle -A ctest2 -m length --length 48 -m u32 --u32 "42=0x1333360c" -j ACCEPT
iptables -t mangle -A ctest2 -m length --length 38 -m u32 --u32 "34&0xFFFFFF=0xFFFFFF" -j SET --exist --add-set TEST1 src
iptables -t mangle -A ctest2 -m length --length 38 -m u32 --u32 "34&0xFFFFFF=0xFFFFFF" -j ACCEPT
iptables -t mangle -A ctest2 -m length --length 37 -m u32 --u32 "29=0x73746174" -j SET --exist --add-set TEST1 src
iptables -t mangle -A ctest2 -m length --length 37 -m u32 --u32 "29=0x73746174" -j ACCEPT
#iptables -t mangle -A ctest2 -j TEE --gateway 127.0.0.1
iptables -t mangle -A ctest2 -j DROP
iptables -t mangle -A legitcheck -m set --match-set WHITELIST src -j SET --exist --add-set LEGIT src,src
iptables -t mangle -A legitcheck -m set --match-set WHITELIST src -j ACCEPT
iptables -t mangle -A legitcheck -m set --match-set LEGIT src,src -j SET --exist --add-set BANNED src
iptables -t mangle -A legitcheck -m set --match-set BANNED src -j DROP
iptables -t mangle -A legitcheck -j SET --exist --add-set LEGIT src,src
iptables -t mangle -A legitcheck -j ACCEPT
iptables -t mangle -A reconnect -j SET --del-set RAWTRACK src,dst
iptables -t mangle -A reconnect -j SET --del-set LEGIT src,src
iptables -t mangle -A reconnect -j SET --del-set TEST1 src
iptables -t mangle -A reconnect -j ACCEPT
# iptables -t mangle -A ban -j LOG --log-prefix "BANNED: " --log-level 4
iptables -t mangle -A ban -j SET --del-set RAWTRACK src,dst
iptables -t mangle -A ban -j SET --exist --add-set BANNED src
iptables -t mangle -A ban -j SET --exist --add-set BAN src
iptables -t mangle -A ban -j DROP
iptables -t mangle -A ban2 -j SET --exist --add-set BANNED src
iptables -t mangle -A ban2 -j SET --del-set RAWTRACK src,dst
# iptables -t mangle -A ban2 -j LOG --log-prefix "BAN2: " --log-level 4
iptables -t mangle -A ban2 -j SET --exist --add-set BAN2 src
iptables -t mangle -A ban2 -j SET --exist --add-set BLOCK src
iptables -t mangle -A ban2 -j DROP
iptables -t mangle -A ban3 -m set --match-set BANNED src -j DROP
iptables -t mangle -A ban3 -m set --match-set LEGIT src,src -j SET --exist --add-set BANNED src
iptables -t mangle -A ban3 -m set --match-set BANNED src -j DROP
iptables -t mangle -A POSTROUTING -o $interface -j SET --exist --add-set RAWTRACK dst,src
