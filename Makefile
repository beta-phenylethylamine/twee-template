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

$(NAME).html: build/main.css build/main.js src/twee/
	$(TWEEGO) --format=$(FORMAT) --output=$(NAME).html build/ src/twee/

test.html: build/main.css build/main.js src/twee/
	$(TWEEGO) --format=$(FORMAT) --output=test.html build/ src/twee/

run: $(NAME).html
	$(BROWSER) $(NAME).html
	
test: test.html
	$(BROWSER) test.html

clean:
	-rm -r build/
	-rm $(NAME).html

.PHONY: clean run test
