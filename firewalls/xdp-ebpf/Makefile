xdp-drop-ebpf.o: xdp-drop-ebpf.c
	clang -Wall -Wextra \
		-O2 -emit-llvm \
		-c $(subst .o,.c,$@) -S -o - \
	| llc -march=bpf -filetype=obj -o $@
