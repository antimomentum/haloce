# This will flush most of the firewalls in my repo.
# If you have custom nat PREROUTING rules or FORWARD in one of my firewalls you must remove those, this will not flush them. 
# If you do have such rules be especially careful when flushing them if you have Docker installed. 
# The rules destroyed by this flusher do NOT flush rules Docker creates.
# Regardless of which ever one of my firewalls you use this flusher will generate errors 
# since it attempts to flush all versions and some of the following ipset tables will not exist in any given firewall.

iptables -t mangle -F
iptables -t mangle -X
iptables -t raw -F
iptables -t raw -X
ipset destroy TESTS
ipset destroy MDNS
ipset destroy WHITELIST
ipset destroy RAWTRACK
ipset destroy BANS
ipset destroy BAN
ipset destroy BAN2
ipset destroy BLOCK
ipset destroy TEST1
ipset destroy TEST2
ipset destroy LEGIT
