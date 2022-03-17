## Highly experimental 


## Notes


This attempts to use xdp ebpf for packet filtering at the network driver before the OS kernel. Run at your own risk.



You can read more about xdp ebpf filtering here:



https://blog.cloudflare.com/how-to-drop-10-million-packets/



Currently drops udp packets except to port 2302 (default Halo port)
and tcp packets except (!) to port 22 (default ssh port).
Drops ICMP.
Drops udp packets with a source port of 53 (for filtering some dns floods)


Commented rules to drop ipv6 have been added to the xdp-drop-epbf.c file. The commented rules will NOT be applied to the interface.


C programs use /* to start a comment and */ to end the comment. Simply remove both of those to uncomment the rules. In the future it is likely more commented rules will be added to the file.


## Usage


The debian11-installs.sh script should install the tools to compile the xdp-drop-ebpf.c file. The install should work in some other Debian/Ubuntu distros as well. It will then attempt to compile the .c using make.


Makefile and xdp-drop-ebpf.c must be in the same directory when running make. This should compile xdp-drop-epbf into a .o object file. This is where the install script stops.


If make is successful:


ip a


should show your interface names. Assuming interface name eth0 as an example, the obj can be applied to an xdp compatible interface (and kernel) by doing:


 
ip link set dev eth0 xdp obj xdp-drop-ebpf.o


This would remove the rules from the interface:


ip link set dev eth0 xdp off



To add or remove specific rules this must be coded to the c file first and then re-compiled to an .o file again using make before using ip link to apply changes.
