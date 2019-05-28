.PHONY: default install clean

default: install

install:
	echo;
	echo "Build client/restbus";
	make -C restbus -f Makefile install;
	echo;
	echo "Build client/ttc-trains";
	make -C ttc-trains -f Makefile install;
