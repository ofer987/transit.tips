.PHONY: client restbus default build install uninstall clean

default: install

install: build

build: restbus client

client:
	make -C client -f Makefile

restbus:
	make -C restbus -f Makefile

uninstall:
	make -C client -f Makefile uninstall
	make -C restbus -f Makefile uninstall

clean:
	make -C client -f Makefile clean
	make -C restbus -f Makefile clean
