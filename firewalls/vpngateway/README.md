Each Wireguard host must have its own private key and public key.

Here is the Wireguard install page:

https://www.wireguard.com/install/


## Clients

All client public keys are given to the gateway's /etc/wireguard/wg0.conf file. An example of the file with two client peers is present with the name "wg0.conf"

Each of those two peers would need their PUBLIC key there in that file on the gateway.

These peers can be Windows, not just Linux, running halo! The public ip of both halo servers will be the public ip of the gateway and not their own public ips! They gain the protection of vpnwall.

Windows clients need only to install Wireguard, generate their private and public key pair, and import the client config. Each peer must have a unique tunnel ip (10.0.0.2/32, 10.0.0.4/32, 10.0.0.6/32, etc).

Windows clients will also need the master server ip in the hosts file. For Windows this file is at:
c:\windows\system32\drivers\etc\hosts

add these two lines to the bottom of hosts:

34.197.71.170 hosthpc.com

34.197.71.170 s1.master.hosthpc.com


## The Gateway

The gateway itself however MUST be Linux server with both Wireguard and ipset installed. I recommend Debian 9 or Ubuntu 18.04 LTS (or higher). On these ditros ipset should be easy to install, just apt update and apt install ipset

vpnwall.sh assumes the gateway's public interface name of eth0. Change vpnwall.sh to your gateway server's public interface name if not eth0.

All admin and management ips must be added to the MDNS table in vpnwall (ips can be added or removed without needing to flush the firewall). Example:

ipset add MDNS 45.56.67.78

Then the management port for the client server must be allowed through the firewall, for example:

iptables -t nat -A PREROUTING -i eth0 -m tcp -p tcp --dport 3389 -j DNAT --to-destination 10.0.0.2:3389

would allow RDP to the Windows halo client, put these rules under the nat rules for the halo port rules to keep player packets prioritized. For a Linux client replace port 3389 with 22 for ssh. Unlike ipset ip changes, changing iptables to a running firewall can disrupt other connections. It is recommended to TEST FIRST. And plan your rules to not require iptables changes to the live firewall.

Assuming a default Wireguard install on the gateway these files go in the /etc/wireguard directory:


wg0.conf 

flush.sh 

vpnwall.sh 

opentroubleshooter.sh (for troubleshooting if needed)

opentroubleshooter.sh is just a totally open and unprotected proxy forwarding without any firewall rules used ONLY for troubleshooting. In wg0.conf replace vpnwall.sh with open.sh to use it.

wg-quick down wg0 <--brings down the tunnel and runs flush.sh to flush the firewall rules 

wg-quick up wg0 <--- runs firewall.sh and brings up the tunnel interface connection. If everything is set up properly a Windows Client could click Activate in Wireguard and connect to the gateway.

Lastly, vpn client whitelisting:

vpn client ips should be whitelisted. vpnwall.sh actually leaves port 51820 (default wireguard port) open. This is to fast track vpn packets coming out from the halo servers back to players as quick as possible. The hosting provider of the gateway should have an outside/edge firewall you can use to only allow the public ip of the halo vpn clients to this port. But in case there is no outside firewall option available you can replace this rule:

iptables -t raw -A PREROUTING -i eth0 -p udp --dport 51820 -j ACCEPT

with this rule:

iptables -t raw -A PREROUTING -i eth0 -p udp --dport 51820 -m set --match-set MDNS src -j ACCEPT

and add the vpn client public ips to MDNS.
