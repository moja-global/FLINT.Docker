DOCKER_REPO=mojaglobal
APP_NAME=baseimage
NUM_CPU=8


# HELP
# This will output the help for each task
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS
# Build the container
build: ## Build the container
	docker build --build-arg NUM_CPU=$(NUM_CPU) -t moja-global/$(APP_NAME):bionic .

build-nc: ## Build the container without caching
	docker build --no-cache --build-arg NUM_CPU=$(NUM_CPU) -t moja-global/$(APP_NAME):bionic .
	
release: build-nc publish ## Make a release by building and publishing the `bionic` and `latest` tagged containers to docker hub

# Docker publish
publish: publish-latest publish-version ## Publish the `bionic` and `latest` tagged containers to docker hub

publish-latest: tag-latest ## Publish the `latest` taged container to docker hub
	@echo 'publish latest to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):latest

publish-version: tag-version ## Publish the `bionic` taged containers to docker hub
	@echo 'publish bionic to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):bionic

# Docker tagging
tag: tag-latest tag-version ## Generate container tags for the `bionic`, and `latest` tags

tag-latest: ## Generate container `latest` tag
	@echo 'create tag latest'
	docker tag moja-global/$(APP_NAME):bionic $(DOCKER_REPO)/$(APP_NAME):latest

tag-version: ## Generate container `bionic` tags
	@echo 'create tags'
	docker tag moja-global/$(APP_NAME):bionic $(DOCKER_REPO)/$(APP_NAME):bionic
	