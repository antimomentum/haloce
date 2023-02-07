# Requirements:

iptables and ipset are both required for these firewalls (not including XDP). For example on Debian based distros:

    apt install ipset



# Details

Typically the firewall would be used on the public interface getting packets to and from the internet.

With the ip command you can find a list of interface names by doing:

    ip a
    
    
    
# Example usage

Assuming you aren't doing a gateway setup simply enter the interface name as an argument when running the script, like so:

    ./firewall-newtest-rawtrack.sh eth0
