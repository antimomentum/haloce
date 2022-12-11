tc qdisc add dev eth0 ingress
tc filter add dev eth0 parent ffff: priority 1 basic match 'ipset(TEST1 src)' action pass
tc filter add dev eth0 parent ffff: priority 2 protocol ip u32 \
match u16 48 0xffff at 2 \
match u32 0x0103080a 0xffffffff at nexthdr+36 \
action pass
tc filter add dev eth0 parent ffff: priority 3 u32 match ip dport 2302 0xffff action drop
