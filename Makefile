bin        = $(shell npm bin)
lsc        = $(bin)/lsc
browserify = $(bin)/browserify
groc       = $(bin)/groc

lib: src/*.ls
	$(lsc) -o lib -c src/*.ls

dist:
	mkdir -p dist

dist/folktale.monads.maybe.umd.js: compile dist
	$(browserify) lib/index.js --standalone Maybe > $@	

# ----------------------------------------------------------------------
bundle: dist/folktale.monads.maybe.umd.js

compile: lib

documentation:
	$(groc) --index "README.md"                                              \
          --out "docs/literate"                                            \
          src/*.ls README.md

clean:
	rm -rf dist build lib

test:
	$(lsc) test/node.ls

.PHONY: test
