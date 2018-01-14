.PHONY: default build clean uninstall

default: install

install: build clean

build: Update.elm main.js index.css

main.js: Update.elm Update/*.elm *.elm Model/*.elm Decoder/*.elm View/*.elm View/Alert/*.elm View/Route/*.elm View/Arrival/*.elm
	elm make Main.elm --output main.js --yes

index.css: Stylesheets.elm MyCss.elm
	elm css Stylesheets.elm

Update/Nearby.elm: Update/Nearby.elm.erb
	erb restbus_url="$(RESTBUS_URL)" Update/Nearby.elm.erb > Update/Nearby.elm;

clean:
	rm Update.elm 2> /dev/null

uninstall:
	rm -rf main.js index.css elm-stuff Update/Nearby.elm 2> /dev/null
