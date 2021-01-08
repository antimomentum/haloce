#!/bin/bash



# Function to create default configuration depending on path
create_default_firewall()
{
    echo "Troubleshooter WARNING:"
    echo "This install is for Linode/DigitalOcean. This will block SSH and DNS"
    echo "You can reboot to flush these changes" 
    sleep 5
    wait
    echo "Installing ipset and kernel rules"
    sleep 2
    echo "apt-get install ipset -y" | bash
    wait
    sleep 2
    echo "sysctl -w kernel.pid_max=65535" | bash
    echo "sysctl -w kernel.msgmnb=65535" | bash
    echo "sysctl -w kernel.shmall=1294967296" | bash
    echo "sysctl -w kernel.shmmax=68719476736" | bash
    echo "sysctl -w fs.suid_dumpable=0" | bash
    echo "sysctl -w vm.min_free_kbytes=65535" | bash
    echo "sysctl -w net.ipv4.conf.all.send_redirects=0" | bash
    echo "sysctl -w net.ipv4.conf.default.send_redirects=0" | bash
    echo "sysctl -w net.ipv4.conf.all.accept_source_route=0" | bash
    echo "sysctl -w net.ipv4.conf.default.accept_source_route=0" | bash
    echo "sysctl -w net.ipv4.conf.all.proxy_arp=0" | bash
    echo "sysctl -w net.ipv4.conf.all.bootp_relay=0" | bash
    echo "sysctl -w net.ipv4.udp_rmem_min=16384" | bash
    echo "sysctl -w net.core.rmem_default=262144" | bash
    echo "sysctl -w net.core.rmem_max=67108864" | bash
    echo "sysctl -w net.ipv4.udp_wmem_min=16384" | bash
    echo "sysctl -w net.core.wmem_default=262144" | bash
    echo "sysctl -w net.core.wmem_max=67108864" | bash
    echo "sysctl -w net.core.optmem_max=65535" | bash
    echo "sysctl -w kernel.sysrq=0" | bash
    wait
    sleep 1
    echo "ipset create LEGIT hash:ip timeout 300" | bash
    wait
    echo "ipset create DDOS hash:ip timeout 300" | bash
    wait
    echo "ipset create TEST2 hash:ip timeout 300" | bash
    wait
    echo "ipset create TEST1 hash:ip timeout 300" | bash
    wait
    echo "ipset add LEGIT 54.82.252.156 timeout 0" | bash
    wait
    echo "ipset add LEGIT 34.197.71.170 timeout 0" | bash
    wait
    sleep 1
    echo "iptables -t mangle -N ctest1" | bash
    wait
    echo "iptables -t mangle -N ctest2" | bash
    wait
    echo "iptables -t mangle -N legit" | bash
    wait
    echo "iptables -t mangle -N pcheck" | bash
    wait
    echo "iptables -t mangle -A PREROUTING -i eth0 -p udp --dport 2302 -j pcheck" | bash
    wait
    echo "iptables -t mangle -A PREROUTING ! -p udp -j DROP" | bash
    wait
    echo "iptables -t mangle -A PREROUTING -m set --match-set DDOS src -j DROP" | bash
    wait
    echo "iptables -t mangle -A PREROUTING -i eth0 -p udp --dport 53 -j DROP" | bash
    wait
    echo "iptables -t mangle -A pcheck -m set --match-set LEGIT src -j legit" | bash
    wait
    echo "iptables -t mangle -A pcheck -m set --match-set TEST2 src -j ctest2" | bash
    wait
    echo "iptables -t mangle -A pcheck -m set --match-set TEST1 src -j ctest1" | bash
    wait
    echo "$(iptables -t mangle -A pcheck -m u32 ! --u32 "42=0x1333360c" -j DROP)" | bash
    wait
    echo "iptables -t mangle -A pcheck -m set --match-set DDOS src -j DROP" | bash
    wait
    echo "$(iptables -t mangle -A pcheck -m u32 --u32 "42=0x1333360c" -j SET --add-set TEST1 src)" | bash
    wait
    echo "$(iptables -t mangle -A pcheck -m u32 --u32 "42=0x1333360c" -j ACCEPT)" | bash
    wait
    echo "iptables -t mangle -A legit -j SET --exist --add-set LEGIT src" | bash
    wait
    echo "iptables -t mangle -A legit -j ACCEPT" | bash
    wait
    echo "iptables -t mangle -A ctest1 -m set --match-set DDOS src -j DROP" | bash
    wait
    echo "$(iptables -t mangle -A ctest1 -m u32 --u32 "28=0x5C717565" -j ACCEPT)" | bash
    wait
    echo "$(iptables -t mangle -A ctest1 -m u32 --u32 "42=0x1333360c" -j ACCEPT)" | bash
    wait
    echo "$(iptables -t mangle -A ctest1 -m u32 --u32 "27&0xFFFFFF=0xFEFD00 && 34&0xFFFFFF=0xFFFFFF" -j SET --add-set TEST2 src)" | bash
    wait
    echo "$(iptables -t mangle -A ctest1 -m u32 --u32 "27&0xFFFFFF=0xFEFD00 && 34&0xFFFFFF=0xFFFFFF" -j ACCEPT)" | bash
    wait
    echo "iptables -t mangle -A ctest1 -j SET --add-set DDOS src" | bash
    wait
    echo "iptables -t mangle -A ctest1 -j DROP" | bash
    wait
    echo "iptables -t mangle -A ctest2 -m set --match-set DDOS src -j DROP" | bash
    wait
    echo "$(iptables -t mangle -A ctest2 -m u32 --u32 "28=0xfefe0100" -j SET --add-set LEGIT src)" | bash
    wait
    echo "$(iptables -t mangle -A ctest2 -m u32 --u32 "28=0xfefe0100" -j ACCEPT)" | bash
    wait
    echo "$(iptables -t mangle -A ctest2 -m u32 --u32 "28=0x5C717565" -j ACCEPT)" | bash
    wait
    echo "$(iptables -t mangle -A ctest2 -m u32 --u32 "42=0x1333360c" -j ACCEPT)" | bash
    wait
    echo "$(iptables -t mangle -A ctest2 -m u32 --u32 "27&0xFFFFFF=0xFEFD00 && 34&0xFFFFFF=0xFFFFFF" -j ACCEPT)" | bash
    wait
    echo "iptables -t mangle -A ctest2 -j SET --add-set DDOS src" | bash
    wait
    echo "iptables -t mangle -A ctest2 -j DROP" | bash
    wait
    sleep 1
    echo "iptables -t mangle -A PREROUTING -s 169.254.0.0/16 -j DROP" | bash
    wait
    echo "iptables -t mangle -A PREROUTING -s 192.0.2.0/24 -j DROP" | bash
    wait
    echo "iptables -t mangle -A PREROUTING -s 192.168.0.0/16 -j DROP" | bash
    wait
    echo "iptables -t mangle -A PREROUTING -s 10.0.0.0/8 -j DROP" | bash
    wait
    echo "iptables -t mangle -A PREROUTING -s 0.0.0.0/8 -j DROP" | bash
    wait
    echo "iptables -t mangle -A PREROUTING -s 240.0.0.0/5 -j DROP" | bash
    wait
    echo "iptables -t mangle -A PREROUTING -s 127.0.0.0/8 ! -i lo,docker0 -j DROP" | bash
    wait
    echo "iptables -t mangle -A PREROUTING -s 224.0.0.0/3 -j DROP" | bash
    wait
    echo "iptables -A INPUT -j DROP" | bash
    wait
    echo "$(iptables -P FORWARD DROP)" | bash
    wait
    sleep 1


}

create_default_firewall


exit 0
