.PHONY: client restbus ttc_notices default build install uninstall clean

default: install

install: build

build: restbus client ttc_notices

client:
	make -C client -f Makefile

restbus:
	make -C restbus -f Makefile

ttc_notices:
	make -C ttc_notices -f Makefile

uninstall:
	make -C client -f Makefile uninstall
	make -C restbus -f Makefile uninstall
	make -C ttc_notices -f Makefile uninstall

clean:
	make -C client -f Makefile clean
	make -C restbus -f Makefile clean
	make -C ttc_notices -f Makefile clean
