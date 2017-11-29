default: build-production

build-js:
	elm make Main.elm --output main.js

build-css:
	elm css Stylesheets.elm

preprocess-local:
	erb restbus_url="http://localhost:3000" Update.elm.erb > Update.elm;

preprocess-production:
	erb restbus_url="https://restbus.transit.tips" Update.elm.erb > Update.elm;

postprocess:
	rm Update.elm 2> /dev/null

build-local: preprocess-local build-js build-css postprocess

build-production: preprocess-production build-js build-css postprocess
