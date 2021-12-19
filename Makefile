.PHONY: help deps dev
IMAGES_TAG = ${shell git describe --tags --match '[0-9]*\.[0-9]*\.[0-9]*' 2> /dev/null || echo 'latest'}
GIT_SHA1:=$(shell git rev-parse --short HEAD)
REPO=jtbonhomme/html5template

help: ## Show this help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

deps: ## Install dependencies.
	which yarn || (brew install yarn)
	yarn add --dev parcel

dev: deps ## Start development server with hot reloading.
	yarn parcel src/index.html

build: deps ## Build project in 'dist' directory.
	yarn parcel build src/index.html



