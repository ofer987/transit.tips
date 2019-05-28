.PHONY: default build uninstall

default: install

install: build

build: main.js

main.js: src/*.elm src/Json/*.elm
	elm make src/Main.elm --output main.js

uninstall:
	rm -rf main.js elm-stuff 2> /dev/null
