## Highly experimental 


This attempts to use xdp ebpf for packet filtering at the network driver before the OS kernel. Run at your own risk.



You can read more about xdp ebpf filtering here:



https://blog.cloudflare.com/how-to-drop-10-million-packets/



Currently drops udp packets except to port 2302 (default Halo port)
and tcp packets except (!) to port 22 (default ssh port).
Drops ICMP.



Rules do NOT apply to ipv6 packets for now
