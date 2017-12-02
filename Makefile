.PHONY: client restbus

default: all

all: client restbus

client:
	make -C client -f Makefile

restbus:
	make -C restbus -f Makefile

