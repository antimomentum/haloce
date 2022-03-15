apt update
wait
sleep 1
apt install make -y
wait
sleep 2
apt install gcc -y
wait
sleep 1
apt install clang -y
wait
apt install llvm -y
wait
make
wait
sleep 1

# The next line would apply the xdp rules to eth0
# ip link set dev eth0 xdp obj xdp-drop-ebpf.o

# This line would remove them:
# ip link set dev eth0 xdp off
