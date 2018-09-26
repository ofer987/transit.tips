.PHONY: default build install uninstall clean

default: install

install: build

build:
	bundle install
	rake db:migrate

clean: uninstall

uninstall:
	rm -rf vendor/bundle
