bin        = $(shell npm bin)
lsc        = $(bin)/lsc
browserify = $(bin)/browserify
groc       = $(bin)/groc
uglify     = $(bin)/uglifyjs
VERSION    = $(shell node -e 'console.log(require("./package.json").version)')


lib: src/*.ls
	$(lsc) -o lib -c src/*.ls

dist:
	mkdir -p dist

dist/monads.maybe.umd.js: compile dist
	$(browserify) lib/index.js --standalone folktale.monads.Maybe > $@

dist/monads.maybe.umd.min.js: dist/monads.maybe.umd.js
	$(uglify) --mangle - < $^ > $@

# ----------------------------------------------------------------------
bundle: dist/monads.maybe.umd.js

minify: dist/monads.maybe.umd.min.js

compile: lib

documentation:
	$(groc) --index "README.md"                                              \
	        --out "docs/literate"                                            \
	        src/*.ls test/*.ls test/specs/**.ls README.md

clean:
	rm -rf dist build lib

test:
	$(lsc) test/tap.ls

package: compile documentation bundle minify
	mkdir -p dist/monads.maybe-$(VERSION)
	cp -r docs/literate dist/monads.maybe-$(VERSION)/docs
	cp -r lib dist/monads.maybe-$(VERSION)
	cp dist/*.js dist/monads.maybe-$(VERSION)
	cp package.json dist/monads.maybe-$(VERSION)
	cp README.md dist/monads.maybe-$(VERSION)
	cp LICENCE dist/monads.maybe-$(VERSION)
	cd dist && tar -czf monads.maybe-$(VERSION).tar.gz monads.maybe-$(VERSION)

publish: clean
	npm install
	npm publish

bump:
	node tools/bump-version.js $$VERSION_BUMP

bump-feature:
	VERSION_BUMP=FEATURE $(MAKE) bump

bump-major:
	VERSION_BUMP=MAJOR $(MAKE) bump

.PHONY: test
