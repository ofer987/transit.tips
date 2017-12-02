.PHONY: node_modules

default: all

all: node_modules build clean

build: Update.elm main.js index.css

node_modules:
	npm install elm
	npm install elm-css

main.js:
	elm make Main.elm --output main.js

index.css:
	elm css Stylesheets.elm

Update.elm:
	erb restbus_url="$(RESTBUS_URL)" Update.elm.erb > Update.elm;

clean:
	rm Update.elm 2> /dev/null
