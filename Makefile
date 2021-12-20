.PHONY: help clean deps dev init
IMAGES_TAG := ${shell git describe --tags --match '[0-9]*\.[0-9]*\.[0-9]*' 2> /dev/null || echo 'latest'}
GIT_SHA1 := $(shell git rev-parse --short HEAD)
REPO=jtbonhomme/html5template

SRC_DIRECTORY = src
DIST_DIRECTORY = dist

help: ## Show this help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

deps: ## Install dependencies.
	@which minify > /dev/null || (npm install -g minify)
	@which css-minify > /dev/null || (npm install css-minify -g)
	@which uglifyjs > /dev/null || (npm install uglify-js -g)

dev: ## Start development server with hot reloading.
	@npx http-server src

clean: ## Clean built resources.
	@rm -rf ${DIST_DIRECTORY}

HTML_SOURCES := $(wildcard $(SRC_DIRECTORY)/*.html)
JS_SOURCES := $(wildcard $(SRC_DIRECTORY)/js/*.js)
CSS_SOURCES := $(wildcard $(SRC_DIRECTORY)/css/*.css)

HTML_DIST := $(subst $(SRC_DIRECTORY)/,$(DIST_DIRECTORY)/,$(HTML_SOURCES))
JS_DIST := $(subst $(SRC_DIRECTORY)/,$(DIST_DIRECTORY)/,$(JS_SOURCES))
CSS_DIST := $(subst $(SRC_DIRECTORY)/,$(DIST_DIRECTORY)/,$(CSS_SOURCES))

$(DIST_DIRECTORY)/js/%.js: $(SRC_DIRECTORY)/js/%.js
	uglifyjs $< --output $@

$(DIST_DIRECTORY)/%.html: $(SRC_DIRECTORY)/%.html
	minify $< > $@

$(DIST_DIRECTORY)/css/%.css: $(SRC_DIRECTORY)/css/%.css
	cp $< $@

init:
	@cp -r "${SRC_DIRECTORY}/" $(DIST_DIRECTORY)

build_html: $(HTML_DIST)
	@echo HTML_SOURCES: $(HTML_SOURCES)

build_js: $(JS_DIST)
	@echo JS_SOURCES: $(JS_SOURCES)

build_css: $(CSS_DIST)
	@echo CSS_SOURCES: $(CSS_SOURCES)

build: deps clean init build_html build_js build_css ## Build project.



