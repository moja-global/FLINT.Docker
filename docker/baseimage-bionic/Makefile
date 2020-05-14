DOCKER_REPO=mojaglobal
APP_NAME=flint-baseimage
BRANCH=develop
TAGNAME=bionic
CPUNUM=8

# HELP
# This will output the help for each task
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS
# Build the container
build: ## Build the containers
	docker build --build-arg NUM_CPU=$(CPUNUM) -t moja/$(APP_NAME):$(TAGNAME) .

build-nc: ## Build the container without caching
	docker build --no-cache --build-arg NUM_CPU=$(CPUNUM) -t moja/$(APP_NAME):$(TAGNAME) .
	
release: build-nc publish ## Make a release by building and publishing the `$(TAGNAME)` and `latest` tagged containers to docker hub

# Docker publish
publish: publish-latest publish-version ## Publish the `$(TAGNAME)`and `latest` tagged containers to docker hub

publish-latest: tag-latest ## Publish the `latest` taged container to docker hub
	@echo 'publish latest to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):latest

publish-version: tag-version ## Publish the `$(TAGNAME)` taged containers to docker hub
	@echo 'publish $(TAGNAME) to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):$(TAGNAME)

# Docker tagging
tag: tag-latest tag-version ## Generate container tags for the `$(TAGNAME)` and `latest`

tag-latest: ## Generate container `latest` tag
	@echo 'create tag latest'
	docker tag moja/$(APP_NAME):$(TAGNAME) $(DOCKER_REPO)/$(APP_NAME):latest

tag-version: ## Generate container `$(TAGNAME)` tag
	@echo 'create tag $(TAGNAME)'
	docker tag moja/$(APP_NAME):$(TAGNAME) $(DOCKER_REPO)/$(APP_NAME):$(TAGNAME)
