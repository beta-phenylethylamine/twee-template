NAME=template
FORMAT=sugarcube-2
SASSTYPE=scss

BROWSER=xdg-open
SASSC=sassc
ROLLUP=rollup
TWEEGO=tweego

all: $(NAME).html

build/:
	mkdir build/

build/main.css: src/style/main.$(SASSTYPE) build/
	$(SASSC) src/style/main.$(SASSTYPE) build/main.css

build/main.js: src/js/main.js build/
	$(ROLLUP) src/js/main.js -o build/main.js -f iife

ifid.twee:
	$(TWEEGO) build/ src/twee/ 2>&1 | tail -n 3 | head -n 2 > ifid.twee

$(NAME).html: build/main.css build/main.js src/twee/ ifid.twee
	$(TWEEGO) --format=$(FORMAT) --output=$(NAME).html build/ src/twee/ ifid.twee

test.html: build/main.css build/main.js src/twee/ ifid.twee
	$(TWEEGO) --test --format=$(FORMAT) --output=test.html build/ src/twee/ ifid.twee

run: $(NAME).html
	$(BROWSER) $(NAME).html
	
test: test.html
	$(BROWSER) test.html

clean:
	-rm -r build/
	-rm $(NAME).html
	-rm test.html

.PHONY: clean run test
