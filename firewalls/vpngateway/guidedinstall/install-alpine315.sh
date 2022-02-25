# install ipset
echo "Installing ipset"
apk update
wait
apk upgrade
wait
apk add ipset
wait
sleep 2

echo "Installing Wireguard, press Ctrl + C to cancel..."
sleep 5
apk add wireguard-tools
wait
sleep 3

modprobe wireguard

echo "Done"

sleep 5

echo "Since the vpn and firewall will NOT automatically start when this script finishes,"
echo "your following entries can be changed before running them if needed...one moment"
sleep 5
ip a
echo "Enter the public interface name or press Ctrl C to stop. example:"
echo "eth0"

read newname

echo "Enter a public static ip address for remote management (this can be changed later). Example:"
echo "45.56.67.78"

read ownerip

echo "Finally, enter the public ip of this gateway (to automatically create the Endpoint in client configs). Example:"
echo "69.164.205.94"

read gatewayip

cat <<END >/etc/wireguard/vpnwall.sh
sysctl -w net.ipv6.conf.all.disable_ipv6=1 
sysctl -w net.ipv6.conf.default.disable_ipv6=1 
sysctl -w net.ipv6.conf.lo.disable_ipv6=1
sysctl -w net.ipv4.ipfrag_low_thresh=0
sysctl -w net.ipv4.ipfrag_high_thresh=0
sysctl -w net.ipv4.ipfrag_time=0
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.core.netdev_max_backlog=4000
wait
sleep 1
ipset create LEGIT hash:ip,port timeout 10
ipset create TEST2 hash:ip timeout 30
ipset create TEST1 hash:ip timeout 60
ipset create MDNS hash:ip
# ipset create CLIENTS hash:net
# ipset add CLIENTS 10.0.0.1/24
wait
ipset add MDNS 54.82.252.156
ipset add MDNS 34.197.71.170
ipset add MDNS $ownerip
# ipset add MDNS 1.1.1.1
# ipset add MDNS haloserverpublicip
wait
iptables -t raw -N ctest2
iptables -t raw -N pcheck
iptables -t raw -N madmins
iptables -t mangle -N reconnect
# iptables -t raw -A PREROUTING -i $newname -p udp --dport 51820 -m set --match-set MDNS src -j ACCEPT
iptables -t raw -A PREROUTING -i $newname -p udp --dport 51820 -j ACCEPT
iptables -t raw -A PREROUTING -i $newname -m set --match-set LEGIT src,src -j ACCEPT
iptables -t raw -A PREROUTING -i $newname -m set --match-set TEST1 src -j pcheck
iptables -t raw -A PREROUTING -i $newname -m set --match-set MDNS src -j madmins
iptables -t raw -A PREROUTING -i $newname -m length --length 48 -m u32 --u32 "42=0x1333360c" -j pcheck
iptables -t raw -A PREROUTING -i $newname -m length --length 67 -m u32 --u32 "28=0xfefe0100" -j ctest2
iptables -t raw -A PREROUTING -i $newname -m length ! --length 34 -j DROP
iptables -t raw -A PREROUTING -i $newname -m u32 ! --u32 "28=0x5C717565" -j DROP
iptables -t raw -A PREROUTING -i $newname -j ctest2
iptables -t raw -A pcheck -p udp --sport 0 -j DROP
iptables -t raw -A pcheck -m set --match-set MDNS src -p udp --dport 3389 -j ACCEPT
iptables -t raw -A pcheck -m set --match-set MDNS src -p tcp -j ACCEPT
iptables -t raw -A pcheck ! -p udp -j DROP
iptables -t raw -A pcheck -p udp ! --dport 2302:2502 -j DROP
iptables -t raw -A pcheck -p udp --sport 53 -j DROP
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
iptables -t raw -A pcheck -m u32 --u32 "42=0x1333360c" -j ACCEPT
iptables -t raw -A pcheck -m set --match-set TEST2 src -j ctest2
iptables -t raw -A pcheck -m u32 --u32 "28=0x5C717565" -j ctest2
iptables -t raw -A pcheck -m set --match-set LEGIT src,src -j ACCEPT
iptables -t raw -A pcheck -m u32 ! --u32 "34&0xFFFFFF=0xFFFFFF" -j DROP
iptables -t raw -A pcheck -j SET --exist --add-set TEST2 src
iptables -t raw -A pcheck -j ACCEPT
iptables -t raw -A ctest2 -p udp --sport 0 -j DROP
iptables -t raw -A ctest2 ! -p udp -j DROP
iptables -t raw -A ctest2 -p udp ! --dport 2302:2502 -j DROP
iptables -t raw -A ctest2 -p udp --sport 53 -j DROP
iptables -t raw -A ctest2 -s 224.0.0.0/3 -j DROP 
iptables -t raw -A ctest2 -s 169.254.0.0/16 -j DROP 
iptables -t raw -A ctest2 -s 172.16.0.0/12 -j DROP 
iptables -t raw -A ctest2 -s 192.0.2.0/24 -j DROP 
iptables -t raw -A ctest2 -s 192.168.0.0/16 -j DROP 
iptables -t raw -A ctest2 -s 10.0.0.0/8 -j DROP 
iptables -t raw -A ctest2 -s 0.0.0.0/8 -j DROP 
iptables -t raw -A ctest2 -s 240.0.0.0/5 -j DROP 
iptables -t raw -A ctest2 -s 127.0.0.0/8 -j DROP
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
iptables -t raw -A madmins -p udp --dport 3389 -j ACCEPT
iptables -t raw -A madmins -p udp -j pcheck
iptables -t mangle -A PREROUTING -i $newname -m set --match-set LEGIT src,src -j SET --exist --add-set LEGIT src,src
iptables -t mangle -A PREROUTING -i $newname -m length --length 31 -m set --match-set LEGIT src,src -m u32 --u32 "27&0x00FFFFFF=0x00fefe68" -j reconnect
iptables -t mangle -A reconnect -j SET --del-set TEST1 src
iptables -t mangle -A reconnect -j SET --del-set LEGIT src,src
iptables -t nat -A PREROUTING -i $newname -m udp -p udp --dport 2302 -j DNAT --to-destination 10.0.0.2:2302
iptables -t nat -A PREROUTING -i $newname -m udp -p udp --dport 2304:2504 -j DNAT --to-destination 10.0.0.4:2304-2504
iptables -t nat -A PREROUTING -i $newname -m tcp -p tcp --dport 3389 -j DNAT --to-destination 10.0.0.2:3389 
iptables -A FORWARD -m udp -p udp --dport 2302:2502 -j ACCEPT
iptables -A FORWARD -m udp -p udp --sport 2302:2502 -j ACCEPT
iptables -A FORWARD -m set --match-set MDNS src -m tcp -p tcp --dport 3389 -j ACCEPT
iptables -A FORWARD -m set --match-set MDNS dst -m tcp -p tcp --sport 3389 -j ACCEPT
iptables -A FORWARD -j DROP
iptables -A INPUT -i $newname -p udp --dport 51820 -j ACCEPT
iptables -A INPUT -i $newname -m set --match-set MDNS src -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -i $newname -j DROP
iptables -t nat -A POSTROUTING -o $newname -j MASQUERADE
END

wait

chmod +x /etc/wireguard/vpnwall.sh

echo "Done"


echo "Create Gateway key pair"
wg genkey | tee ~/wg-private.key | wg pubkey > ~/wg-public.key
wait
PRIVATEKEY=`cat ~/wg-private.key`
PUBLICKEY=`cat ~/wg-public.key`



echo "Create two client key pairs"

wg genkey | tee ~/c1-private.key | wg pubkey > ~/c1-public.key
wait
C1KEY=`cat ~/c1-public.key`
C1PKEY=`cat ~/c1-private.key`


wg genkey | tee ~/c2-private.key | wg pubkey > ~/c2-public.key
wait
C2KEY=`cat ~/c2-public.key`
C2PKEY=`cat ~/c2-private.key`
wait

echo "Done"

echo "Create firewall flusher"

cat <<FLUSH >/etc/wireguard/flush.sh
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
FLUSH

wait

chmod +x /etc/wireguard/flush.sh

echo "Done"

echo "Create config files"

cat <<WEND >/etc/wireguard/wg0.conf
[Interface]
PrivateKey = $PRIVATEKEY
Address = 10.0.0.1/24
PostUp = /etc/wireguard/vpnwall.sh
PostDown = /etc/wireguard/flush.sh
ListenPort = 51820
[Peer]
PublicKey = $C1KEY
AllowedIPs = 10.0.0.2/32
[Peer]
PublicKey = $C2KEY
AllowedIPs = 10.0.0.4/32
WEND

wait



cat <<CLIENTS1 >client1.conf
[Interface]
Address = 10.0.0.2/32
PrivateKey = $C1PKEY
[Peer]
PublicKey = $PUBLICKEY
AllowedIPs = 0.0.0.0/0
Endpoint = $gatewayip:51820
PersistentKeepalive = 10
CLIENTS1

wait

cat <<CLIENTS2 >client2.conf
[Interface]
Address = 10.0.0.4/32
PrivateKey = $C2PKEY
[Peer]
PublicKey = $PUBLICKEY
AllowedIPs = 0.0.0.0/0
Endpoint = $gatewayip:51820
PersistentKeepalive = 10
CLIENTS2

wait

cat <<START >start.sh
systemctl stop systemd-timesyncd
systemctl stop systemd-resolved
wg-quick up wg0
START

chmod +x start.sh

cat <<STOP >stop.sh
wg-quick down wg0
systemctl start systemd-timesyncd
systemctl start systemd-resolved
STOP

chmod +x stop.sh

echo "Done!"
rm c*-*.key
echo "Copy the client.conf files to use on other Wireguard peers that are NOT the gateway:"
ls
echo "do this command to start the tunnel on this gateway:"
echo "wg-quick up wg0"
