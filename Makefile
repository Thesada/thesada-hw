# SPDX-License-Identifier: CERN-OHL-P-2.0
# Repo gate. OpenSCAD runs in the pinned image, the same one locally and in CI.
.DEFAULT_GOAL := help
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c

# 2026.10.12, the nearest image to the 2026.10.11 build the committed STLs came from
OPENSCAD_IMAGE ?= openscad/openscad:dev.2026-10-12@sha256:4098a7c2c37d5a9110121635a568e6596b8619362ced5c84cc67f47d395e7fd0
DOCKER_USER ?= $(shell id -u):$(shell id -g)
OPENSCAD ?= docker run --rm --network none --user $(DOCKER_USER) -v $(CURDIR):$(CURDIR) -w $(CURDIR)/$(CASE) $(OPENSCAD_IMAGE) openscad
PYTHON ?= python3
CASE := enclosure/node
FRESH := $(CURDIR)/build/fresh
# Commits from BASE to HEAD get the DCO and sanitize checks. CI sets it to the PR base.
BASE ?= origin/main
DCO_EMAIL ?= 65317274+dhumpf@users.noreply.github.com
CASE_MAKE := $(MAKE) -C $(CASE) OPENSCAD='$(OPENSCAD)'

##@ General

.PHONY: help
help: ## List targets (changes nothing)
	@awk 'BEGIN {FS = ":.*##"; printf "usage: make <target>\n"} \
	  /^[a-zA-Z0-9_.-]+:.*##/ { printf "  %-12s %s\n", $$1, $$2 } \
	  /^##@/ { printf "\n%s\n", substr($$0, 5) }' $(MAKEFILE_LIST)

##@ Development

.PHONY: setup
setup: ## Pull the pinned OpenSCAD image
	docker pull -q $(OPENSCAD_IMAGE)

.PHONY: build
build: ## Export every STL and PNG of both case variants into the case folder
	$(CASE_MAKE) stl stl-freenove png png-freenove

.PHONY: test
test: lint selftest render overhang fresh ## Every check CI runs

.PHONY: render
render: ## Render both variants into build/fresh, every assert must hold
	rm -rf $(FRESH)
	$(CASE_MAKE) OUT=$(FRESH) stl stl-freenove

.PHONY: overhang
overhang: render ## Overhang check on the fresh renders
	$(CASE_MAKE) OUT=$(FRESH) test

.PHONY: fresh
fresh: render ## Committed STLs match the fresh renders
	$(CASE_MAKE) OUT=$(FRESH) fresh

.PHONY: lint
lint: dco sanitize ## DCO and sanitize on BASE..HEAD, script syntax
	bash -n $(wildcard tools/*.sh .*/*.sh)
	$(PYTHON) -m py_compile tools/*.py $(CASE)/*.py

.PHONY: dco
dco: ## Every commit since BASE is signed off and authored as DCO_EMAIL
	tools/check-dco.sh $(BASE) $(DCO_EMAIL)

.PHONY: sanitize
sanitize: ## No private IPs, internal hosts, local paths, secrets or unexpected trailers in lines added since BASE
	$(PYTHON) tools/sanitize.py $(BASE)

.PHONY: selftest
selftest: ## Prove each check fails on a seeded bad input
	OPENSCAD='$(OPENSCAD)' tools/selftest.sh

##@ Housekeeping

.PHONY: clean
clean: ## Remove build output (not the committed STLs)
	rm -rf build
