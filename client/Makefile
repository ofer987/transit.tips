.PHONY: default all build node_modules clean uninstall

default: all

all: node_modules build clean

build: Update.elm main.js index.css

node_modules:
	npm install elm
	npm install elm-css

main.js: Update.elm *.elm Model/*.elm RestBus/*.elm View/*.elm
	elm make Main.elm --output main.js

index.css: Stylesheets.elm MyCss.elm
	elm css Stylesheets.elm

Update.elm: Update.elm.erb
	erb restbus_url="$(RESTBUS_URL)" Update.elm.erb > Update.elm;

clean:
	rm Update.elm 2> /dev/null

uninstall:
	rm -rf main.js index.css node_modules elm-stuff Update.elm 2> /dev/null
