## This script is experimental expect major changes to it any time


This script currently only supports Debian 9 however an alternate script will be made for Ubuntu 18.04 LTS (and probably higher) soon


This script is designed to make RDP accessible for a Windows vpn client. Linux clients are still fine. For RDP enter the gateway ip instead of the windows halo server's ip.


This script does not support filtering multiple public interfaces (but can be done) or multiple Wireguard interfaces on the gateway (multiple clients is fine, this script makes two clients).


This script will expect you to input three different pieces of information. However it will not start the firewall or tunnel so these can be changed manually after running the script.


## What this script will expect you to know:


1. You'll need to know the public interface name of your gateway server. This can usually be found by doing:

ip a


or 

ip a | less


Usually it will named something like eth0 or enp1s0 




2. A static ip to be whitelisted in the firewall for admin management. Whether it be for ssh to the gateway itself or RDP to the windows vpn client a static ip is required for this. However, if your gateway VPS host offers web UI console access to the server through an account on their website, then the admin ip(s) can be changed at any time with: ipset add MDNS newiphere




3. The public ip of the gateway you run this script on. This is simply to enter the ip into two client configs for automatic generation.


That's it! *fingers crossed*


## After the install finishes:


ipset and wireguard will be installed. The firewall and wireguard will not be enabled. If you entered any of those 3 things above incorrectly you can change them at this point.



## Host provider firewall


Port 51820 will still be open. The host provider for your gateway will likely have an outside/edge firewall you can use to only allow your windows/linux client public ip to the port. But in case there is not firewall for you to use, or it costs money, you can replace this line in /etc/wireguard/vpnwall.sh:


iptables -t raw -A PREROUTING -i eth0 -p udp --dport 51820 -j ACCEPT


with this line:

 
iptables -t raw -A PREROUTING -i eth0 -p udp --dport 51820 -m set --match-set MDNS src -j ACCEPT


assuming iface name eth0. Be sure to add the real public ip of your halo client to MDNS.



## Be careful-lockout

The Wireguard client on Windows MAY LOCK YOU OUT OF THE SERVER!!!!! If the host provider has web UI access or you have physical access to the server you don't have to worry about getting locked out.

It is important to have the correct admin ip entered. If you entered it incorrectly go to /etc/wireguard/vpnwall.sh and enter your ip into MDNS.

If everything was correct you can copy the client1.conf and client2.conf files off the gateway. They should be fully ready to use in Windows or Linux, but again expect to RDP to the gateway once you import the conf file and click Activate in Wireguard on Windows if you rely on RDP for access. 


## Start the firewall and tunnel


On the gateway this will run the firewall and start the tunnel:

wg-quick up wg0


## To bring down the tunnel:

wg-quick down wg0


Rebooting the gateway will also flush the firewall and bring down the tunnel on the gateway
