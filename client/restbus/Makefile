.PHONY: default build clean uninstall

default: install

install: clean build

build: src/Constants.elm main.js

main.js: src/*.elm src/Workflow/*.elm src/Model/*.elm src/View/*.elm src/View/Alert/*.elm src/Json/*.elm src/Json/Convert/*.elm src/Json/Decode/*.elm
	elm make src/Main.elm --output main.js

# index.css: Stylesheets.elm MyCss.elm
# 	elm css Stylesheets.elm

src/Constants.elm: src/Constants.elm.erb
	erb restbus_url="$(RESTBUS_URL)" src/Constants.elm.erb > src/Constants.elm;

clean:
	rm src/Constants.elm 2> /dev/null

uninstall:
	rm -rf main.js elm-stuff src/Constants.elm 2> /dev/null
