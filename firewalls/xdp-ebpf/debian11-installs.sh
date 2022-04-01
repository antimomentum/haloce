apt update
wait
sleep 1
apt install -y make gcc clang llvm
wait
sleep 1
make
wait
sleep 1

# The next line would apply the xdp rules to eth0
# ip link set dev eth0 xdp obj xdp-drop-ebpf.o

# This line would remove them:
# ip link set dev eth0 xdp off
