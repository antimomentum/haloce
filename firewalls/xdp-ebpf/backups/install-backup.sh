cat <<END >firewall.sh
systemctl stop systemd-timesyncd
wait
systemctl stop systemd-resolved
wait
ip link set dev eth0 xdp obj xdp-drop-ebpf.o
wait
sleep 1
sysctl -w net.ipv6.conf.all.disable_ipv6=1 
sysctl -w net.ipv6.conf.default.disable_ipv6=1 
sysctl -w net.ipv6.conf.lo.disable_ipv6=1
sysctl -w net.ipv4.ipfrag_low_thresh=0
sysctl -w net.ipv4.ipfrag_high_thresh=0
sysctl -w net.ipv4.ipfrag_time=0
# sysctl -w net.ipv4.ip_forward=1
sysctl -w net.core.netdev_max_backlog=4000
wait
sleep 1
ipset create LEGIT hash:ip,port timeout 10
ipset create TEST2 hash:ip timeout 30
ipset create TEST1 hash:ip timeout 60
ipset create MDNS hash:ip
wait
ipset add MDNS 54.82.252.156
ipset add MDNS 34.197.71.170
ipset add MDNS api.linode.com
wait
iptables -t raw -N ctest2
iptables -t raw -N pcheck
iptables -t raw -N madmins
iptables -t mangle -N reconnect
iptables -t raw -A PREROUTING -i eth0 -m set --match-set LEGIT src,src -j ACCEPT
iptables -t raw -A PREROUTING -i eth0 -m set --match-set TEST1 src -j pcheck
iptables -t raw -A PREROUTING -i eth0 -m set --match-set MDNS src -j madmins
iptables -t raw -A PREROUTING -i eth0 ! -p udp -j DROP
iptables -t raw -A PREROUTING -i eth0 -m length --length 67 -m u32 --u32 "28=0xfefe0100" -j ctest2
iptables -t raw -A PREROUTING -i eth0 -m length ! --length 34:48 -j DROP
iptables -t raw -A PREROUTING -i eth0 -m length --length 48 -m u32 --u32 "35=0x0a010308" -j pcheck
iptables -t raw -A PREROUTING -i eth0 -m length ! --length 34 -j DROP
iptables -t raw -A PREROUTING -i eth0 -m u32 ! --u32 "28=0x5C717565" -j DROP
iptables -t raw -A PREROUTING -i eth0 -j ctest2
iptables -t raw -A pcheck -p udp --sport 0 -j DROP
iptables -t raw -A pcheck ! -p udp -j DROP
iptables -t raw -A pcheck -j SET --exist --add-set TEST1 src
iptables -t raw -A pcheck -m u32 --u32 "42=0x1333360c" -j ACCEPT
iptables -t raw -A pcheck -m set --match-set TEST2 src -j ctest2
iptables -t raw -A pcheck -m u32 --u32 "28=0x5C717565" -j ctest2
iptables -t raw -A pcheck -m u32 ! --u32 "34&0xFFFFFF=0xFFFFFF" -j DROP
iptables -t raw -A pcheck -j SET --exist --add-set TEST2 src
iptables -t raw -A pcheck -j ACCEPT
iptables -t raw -A ctest2 -p udp --sport 0 -j DROP
iptables -t raw -A ctest2 ! -p udp -j DROP
iptables -t raw -A ctest2 -j SET --exist --add-set TEST1 src
iptables -t raw -A ctest2 -j SET --exist --add-set TEST2 src
iptables -t raw -A ctest2 -m u32 --u32 "28=0xfefe0100" -j SET --exist --add-set LEGIT src,src
iptables -t raw -A ctest2 -m set --match-set LEGIT src,src -j ACCEPT
iptables -t raw -A ctest2 -m u32 --u32 "28=0x5C717565" -j ACCEPT
iptables -t raw -A ctest2 -m u32 --u32 "42=0x1333360c" -j ACCEPT
iptables -t raw -A ctest2 -m u32 --u32 "34&0xFFFFFF=0xFFFFFF" -j ACCEPT
iptables -t raw -A ctest2 -j DROP
iptables -t raw -A madmins -s 34.197.71.170 -j ACCEPT
iptables -t raw -A madmins -s 54.82.252.156 -j ACCEPT
iptables -t raw -A madmins -p tcp -j ACCEPT
iptables -t raw -A madmins -p udp -j pcheck
iptables -t mangle -A PREROUTING -i eth0 -m set --match-set LEGIT src,src -j SET --exist --add-set LEGIT src,src
iptables -t mangle -A PREROUTING -i eth0 -m length --length 31 -m set --match-set LEGIT src,src -m u32 --u32 "27&0x00FFFFFF=0x00fefe68" -j reconnect
iptables -t mangle -A reconnect -j SET --del-set TEST1 src
iptables -t mangle -A reconnect -j SET --del-set LEGIT src,src
END

chmod +x firewall.sh
wait

cat <<FLUSH >flush.sh
iptables -F
iptables -X
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
wait
ip link set dev eth0 xdp off
FLUSH

chmod +x flush.sh

cat <<XTTTNM >xdp-drop-ebpf.c
#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/in.h>
#include <linux/ip.h>
#include <linux/udp.h>
#include <stdint.h>

#define SEC(NAME) __attribute__((section(NAME), used))

#define htons(x) ((__be16)___constant_swab16((x)))
#define htonl(x) ((__be32)___constant_swab32((x)))

#define IP_FRAGMENTED 65343

SEC("prog")
int xdp_drop_benchmark_traffic(struct xdp_md *ctx)
{
    void *data_end = (void *)(long)ctx->data_end;
    void *data = (void *)(long)ctx->data;
    struct ethhdr *eth = data;

    uint64_t nh_off = sizeof(*eth);
    if (data + nh_off > data_end)
    {
        return XDP_PASS;
    }

    uint16_t h_proto = eth->h_proto;

    if (h_proto == htons(ETH_P_IP))
    {
        struct iphdr *iph = data + nh_off;
        struct udphdr *udph = data + nh_off + sizeof(struct iphdr);
        if (udph + 1 > (struct udphdr *)data_end)
        {
            return XDP_DROP;
        }
        if (iph->frag_off & IP_FRAGMENTED)
        {
            return XDP_DROP;
        }
        if (iph->protocol == IPPROTO_UDP)
        {
            if (udph->source == htons(53))
            {
                return XDP_DROP;
            }
            if (udph->dest != htons(2302))
            {
                return XDP_DROP;
            }
            if (iph->tos != 0x00)
            {
                return XDP_DROP;
            }
            {
            return XDP_PASS;
            }
        }
        if (iph->protocol == IPPROTO_TCP && (htonl(iph->saddr) & 0xFFFFFFFF) == 0x480EB4CB)
        {
        return XDP_PASS;
        }
    }
    if (h_proto == htons(ETH_P_ARP))
    {
         return XDP_PASS;
    }
    return XDP_DROP;
}

char _license[] SEC("license") = "GPL";
XTTTNM

cat <<CREATE >Makefile
xdp-drop-ebpf.o: xdp-drop-ebpf.c
	clang -Wall -Wextra \\
		-O2 -emit-llvm \\
		-c \$(subst .o,.c,\$@) -S -o - \\
	| llc -march=bpf -filetype=obj -o \$@
CREATE

cat <<UPAPI >update.sh
TOKEN=\$(cat t.txt)
ipset list LEGIT | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sed 's/^/"/; s/$/\/32",/' |tr '\n' ' ' | sed 's/.$//' > legit.txt
ipset list MDNS | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sed 's/^/"/; s/$/\/32",/' |tr '\n' ' ' | sed 's/.$//' | sed 's/.$//' > mdns.txt
MDNS=\$(cat mdns.txt)
IP2=\$(cat legit.txt)
IPs=\$(printf "\$IP1 \$IP2 \$MDNS")
curl -H "Content-Type: application/json" \\
    -H "Authorization: Bearer \$TOKEN" \\
    -X PUT -d '{
	"inbound_policy": "DROP",
        "inbound": [
          {
            "protocol": "UDP",
            "ports": "2302",
            "addresses": {
              "ipv4": [
               '"\$IPs"'
              ]
           },
         "action": "ACCEPT"
         }
 	],
	"outbound_policy": "ACCEPT"
    }' \\
    https://api.linode.com/v4beta/networking/firewalls/2502/rules &>/dev/null
UPAPI

chmod +x update.sh

cat <<DISAPI >disable.sh
TOKEN=\$(cat t.txt)
curl -H "Content-Type: application/json" \\
    -H "Authorization: Bearer \$TOKEN" \\
    -X PUT -d '{
	"inbound_policy": "DROP",
        "inbound": [
          {
            "protocol": "UDP",
            "ports": "2302",
            "addresses": {
              "ipv4": [
               "0.0.0.0/0"
              ]
           },
         "action": "ACCEPT"
         }
 	],
	"outbound_policy": "ACCEPT"
    }' \\
    https://api.linode.com/v4beta/networking/firewalls/2502/rules &>/dev/null
DISAPI

chmod +x disable.sh

cat <<TRIGAPI >trigger.sh
#!/bin/bash

while :
do
   R1=\$(cat /sys/class/net/eth0/statistics/rx_bytes)
   sleep 1
   R2=\$(cat /sys/class/net/eth0/statistics/rx_bytes)
   tot=\$(( R2 - R1 ))
   wait

   if [ "\$tot" -gt "500000" ]; then
      ./update.sh
      wait
      sleep 400
      ./disable.sh
      sleep 300
   fi
      sleep 300
done
TRIGAPI

chmod +x trigger.sh
wait

cat <<SPAPI >spark.sh
#!/bin/bash

R1=\$(cat /sys/class/net/eth0/statistics/rx_bytes)
sleep 1
R2=\$(cat /sys/class/net/eth0/statistics/rx_bytes)
tot=\$(( R2 - R1 ))
wait

until [ "\$tot" -gt "600000" ]; do
    sleep 300
    R1=\$(cat /sys/class/net/eth0/statistics/rx_bytes)
    wait
    sleep 1
    R2=\$(cat /sys/class/net/eth0/statistics/rx_bytes)
    wait
    tot=\$(( R2 - R1 ))
done

./update.sh
wait
echo "Flood!"
sleep 300
./disable.sh
SPAPI

chmod +x spark.sh

sleep 1

apt update
wait
sleep 1
apt install -y ipset make gcc clang llvm htop nload unzip tshark
wait
sleep 1
make
wait
sleep 2

wget https://opencarnage.net/applications/core/interface/file/attachment.php?id=1364 && mv attachment.php\?id\=1364 halopull.zip
wait
sleep 1
unzip halopull.zip
apt-get install -y wget && apt-get install -y && dpkg --add-architecture i386
wait
apt-get update
wait
apt install -y wine32 libwine:i386 fonts-wine
wait
sleep 2
apt autoremove
wait
apt remove -y unattended-upgrades make gcc clang llvm
wait
systemctl disable apt-daily-upgrade.timer
wait
systemctl disable apt-daily.timer
wait
echo "34.197.71.170 hosthpc.com" >> /etc/hosts
echo "34.197.71.170 s1.master.hosthpc.com" >> /etc/hosts
echo "72.14.180.203 api.linode.com" >> /etc/hosts
