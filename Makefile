SHA=$(shell git rev-parse --short HEAD)

.PHONY: build
build:
	docker build  -f docker/Dockerfile.wordpress .
