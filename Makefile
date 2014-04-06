bin        = $(shell npm bin)
lsc        = $(bin)/lsc
browserify = $(bin)/browserify
jsdoc      = $(bin)/jsdoc
uglify     = $(bin)/uglifyjs
VERSION    = $(shell node -e 'console.log(require("./package.json").version)')


dist:
	mkdir -p dist

dist/data.maybe.umd.js: dist
	$(browserify) lib/index.js --standalone folktale.data.Maybe > $@

dist/data.maybe.umd.min.js: dist/data.maybe.umd.js
	$(uglify) --mangle - < $^ > $@

# ----------------------------------------------------------------------
bundle: dist/data.maybe.umd.js

minify: dist/data.maybe.umd.min.js

dev-tools:
	npm install

documentation:
	$(jsdoc) --configure jsdoc.conf.json
	ABSPATH=$(shell cd "$(dirname "$0")"; pwd) $(MAKE) clean-docs

clean-docs:
	perl -pi -e "s?$$ABSPATH/??g" ./docs/*.html

clean:
	rm -rf dist build

test:
	$(lsc) test/tap.ls

package: documentation bundle minify
	mkdir -p dist/data.maybe-$(VERSION)
	cp -r docs dist/data.maybe-$(VERSION)
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


.PHONY: test bump bump-major bump-feature documentation publish clean
