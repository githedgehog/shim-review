SHELL := bash
.SHELLFLAGS := -e -c
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MKFILE_DIR := $(shell echo $(dir $(abspath $(lastword $(MAKEFILE_LIST)))) | sed 'sA/$$AA')
DOCKER_BUILDX_FLAGS ?=

all: docker

.PHONY: docker
docker: docker-x86_64 docker-arm64

.PHONY: docker-x86_64
docker-x86_64:
	docker buildx build \
		-t ghcr.io/githedgehog/shim-review:latest \
		--no-cache --progress=plain \
		--platform=linux/amd64 \
		--build-arg EFIARCH=x64 $(DOCKER_BUILDX_FLAGS) . 2>&1 | tee build-x86_64.log
	docker rm shim-review &>/dev/null || true
	docker create --name shim-review ghcr.io/githedgehog/shim-review:latest
	docker cp shim-review:/boot/efi/EFI/hedgehog/shimx64.efi $(MKFILE_DIR)/artifacts/
	docker cp shim-review:/boot/efi/EFI/hedgehog/mmx64.efi $(MKFILE_DIR)/artifacts/
	docker cp shim-review:/boot/efi/EFI/BOOT/fbx64.efi $(MKFILE_DIR)/artifacts/
	docker rm shim-review
	
.PHONY: docker-arm64
docker-arm64:
	docker buildx build \
		-t ghcr.io/githedgehog/shim-review:latest \
		--no-cache \
		--progress=plain \
		--platform=linux/arm64 \
		--build-arg EFIARCH=aa64 $(DOCKER_BUILDX_FLAGS) . 2>&1 | tee build-arm64.log
	docker rm shim-review &>/dev/null || true
	docker create --name shim-review ghcr.io/githedgehog/shim-review:latest
	docker cp shim-review:/boot/efi/EFI/hedgehog/shimaa64.efi $(MKFILE_DIR)/artifacts/
	docker cp shim-review:/boot/efi/EFI/hedgehog/mmaa64.efi $(MKFILE_DIR)/artifacts/
	docker cp shim-review:/boot/efi/EFI/BOOT/fbaa64.efi $(MKFILE_DIR)/artifacts/
	docker rm shim-review

ci: DOCKER_BUILDX_FLAGS = --load
ci: docker