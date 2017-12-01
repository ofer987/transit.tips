default: all

all: build-client build-restbus

build-client:
	make -C client -f Makefile

build-restbus:
	make -C restbus -f Makefile

