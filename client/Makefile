default: all

all: tools build

tools:
	npm install elm
	npm install elm-css

build-js:
	elm make Main.elm --output main.js

build-css:
	elm css Stylesheets.elm

preprocess:
	erb restbus_url="$(RESTBUS_URL)" Update.elm.erb > Update.elm;

postprocess:
	rm Update.elm 2> /dev/null

build: preprocess build-js build-css postprocess
