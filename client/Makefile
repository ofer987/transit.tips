.PHONY: default install clean

default: install

install: copy_css_to_restbus copy_css_to_ttc_trains build

copy_css_to_restbus: MyCss.elm
	echo;
	echo "Copy MyCss.elm to restbus/src"
	cp MyCss.elm restbus/src;

copy_css_to_ttc_trains: MyCss.elm
	echo;
	echo "Copy MyCss.elm to ttc-trains/src"
	cp MyCss.elm ttc-trains/src;

build: 
	echo;
	echo "Build client/restbus";
	make -C restbus -f Makefile install;
	echo;
	echo "Build client/ttc-trains";
	make -C ttc-trains -f Makefile install;
