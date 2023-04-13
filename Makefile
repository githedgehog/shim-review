all: docker

.PHONY: docker
docker: docker-x86_64 docker-arm64

.PHONY: docker-x86_64
docker-x86_64:
	docker buildx build -t ghcr.io/githedgehog/shim-review:latest --platform=linux/amd64 --build-arg EFIARCH=x64
	
.PHONY: docker-arm64
docker-arm64:
	docker buildx build -t ghcr.io/githedgehog/shim-review:latest --platform=linux/arm64 --build-arg EFIARCH=aa64
