tc qdisc add dev eth0 ingress
tc filter add dev eth0 parent ffff: priority 1 basic match 'ipset(LEGIT src)' action pass

tc filter add dev eth0 parent ffff: priority 2 protocol ip u32 \
match u16 48 0xffff at 2 \
match u32 0x0103080a 0xffffffff at nexthdr+36 \
action pass
tc filter add dev eth0 parent ffff: priority 3 protocol ip u32 \
match u16 67 0xffff at 2 \
match u32 0xfefe0100 0xffffffff at nexthdr+28 \
action pass


tc filter add dev eth0 parent ffff: priority 4 protocol ip u32 \
match u8 0x11 0xff at 9 \
police rate 50kbit burst 20kbit drop
