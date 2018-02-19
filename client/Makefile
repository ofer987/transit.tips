.PHONY: default build clean uninstall

default: install

install: build clean

build: Constants.elm main.js index.css

main.js: *.elm Update/*.elm Model/*.elm View/*.elm View/Alert/*.elm View/Search/*.elm Json/*.elm Json/Convert/*.elm Json/Decode/*.elm
	elm make Main.elm --output main.js --yes

index.css: Stylesheets.elm MyCss.elm
	elm css Stylesheets.elm

Constants.elm: Constants.elm.erb
	erb restbus_url="$(RESTBUS_URL)" Constants.elm.erb > Constants.elm;

clean:
	rm Constants.elm 2> /dev/null

uninstall:
	rm -rf main.js index.css elm-stuff Constants.elm 2> /dev/null
