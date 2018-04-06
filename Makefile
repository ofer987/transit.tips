.PHONY: client restbus default build install uninstall clean

default: install

install: build

build: client restbus

client:
	make -C client -f Makefile -d

restbus:
	make -C restbus -f Makefile -d

uninstall:
	make -C client -f Makefile uninstall
	make -C restbus -f Makefile uninstall

clean:
	make -C client -f Makefile clean
	make -C restbus -f Makefile clean
