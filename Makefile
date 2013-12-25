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

dist/data.maybe.umd.js: compile dist
	$(browserify) lib/index.js --standalone folktale.data.Maybe > $@

dist/data.maybe.umd.min.js: dist/data.maybe.umd.js
	$(uglify) --mangle - < $^ > $@

# ----------------------------------------------------------------------
bundle: dist/data.maybe.umd.js

minify: dist/data.maybe.umd.min.js

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
	mkdir -p dist/data.maybe-$(VERSION)
	cp -r docs/literate dist/data.maybe-$(VERSION)/docs
	cp -r lib dist/data.maybe-$(VERSION)
	cp dist/*.js dist/data.maybe-$(VERSION)
	cp package.json dist/data.maybe-$(VERSION)
	cp README.md dist/data.maybe-$(VERSION)
	cp LICENCE dist/data.maybe-$(VERSION)
	cd dist && tar -czf data.maybe-$(VERSION).tar.gz data.maybe-$(VERSION)

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
