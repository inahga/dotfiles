all: build run

build:
	rm -f *.qcow2
	nix-build '<nixpkgs/nixos>' -A vm -I nixos-config=hosts/qemu-system-x86_64/default.nix

run:
	QEMU_OPTS="-vga cirrus -m 8192 -smp 4 -display gtk,grab-on-hover=on" result/bin/run-*-vm

.PHONY: all run build
