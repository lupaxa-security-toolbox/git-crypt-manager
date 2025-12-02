# Makefile for git-crypt-manager
#
# Common workflows:
#   make docs-build      # build MkDocs documentation
#   make docs-serve      # serve docs locally with live reload
#   make version         # show current script version
#   make bump-patch      # bump patch version (X.Y.Z -> X.Y.(Z+1))
#   make bump-minor      # bump minor version (X.Y.Z -> X.(Y+1).0)
#   make bump-major      # bump major version (X.Y.Z -> (X+1).0.0)
#   make clean           # clean build artefacts

PROJECT_NAME := git-crypt-manager

BUMP   ?= bump-my-version
MKDOCS ?= mkdocs

SCRIPT := git-crypt-manager.sh

# Extract the current version from the script: VERSION="1.2.3"
PROJECT_VERSION := $(shell sed -n 's/^VERSION="\(.*\)"/\1/p' $(SCRIPT) | head -n1)

.PHONY: \
	help \
	docs-build \
	docs-serve \
	bump-patch \
	bump-minor \
	bump-major \
	version \
	clean

# ---------------------------------------------------------------------------
# Help
# ---------------------------------------------------------------------------

help:
	@echo "$(PROJECT_NAME) Makefile"
	@echo
	@echo "Targets:"
	@echo "  docs-build      Build MkDocs documentation"
	@echo "  docs-serve      Serve MkDocs documentation with live reload"
	@echo
	@echo "  bump-patch      Bump patch version (X.Y.Z -> X.Y.(Z+1))"
	@echo "  bump-minor      Bump minor version (X.Y.Z -> X.(Y+1).0)"
	@echo "  bump-major      Bump major version (X.Y.Z -> (X+1).0.0)"
	@echo
	@echo "  version         Show current script version"
	@echo "  clean           Remove build artefacts (site/, etc.)"

# ---------------------------------------------------------------------------
# Documentation (MkDocs)
# ---------------------------------------------------------------------------

docs-build:
	$(MKDOCS) build

docs-serve:
	$(MKDOCS) serve

# ---------------------------------------------------------------------------
# Versioning (bump-my-version)
# ---------------------------------------------------------------------------

bump-patch:
	@current="$(PROJECT_VERSION)"; \
	base="$${current%%-*}"; \
	major="$${base%%.*}"; \
	minor_patch="$${base#*.}"; \
	minor="$${minor_patch%%.*}"; \
	patch="$${minor_patch##*.}"; \
	new_patch=$$((patch + 1)); \
	new_version="$$major.$$minor.$$new_patch"; \
	echo "Bump patch: $$current -> $$new_version"; \
	$(BUMP) bump version --new-version "$$new_version"

bump-minor:
	@current="$(PROJECT_VERSION)"; \
	base="$${current%%-*}"; \
	major="$${base%%.*}"; \
	minor_patch="$${base#*.}"; \
	minor="$${minor_patch%%.*}"; \
	new_minor=$$((minor + 1)); \
	new_version="$$major.$$new_minor.0"; \
	echo "Bump minor: $$current -> $$new_version"; \
	$(BUMP) bump version --new-version "$$new_version"

bump-major:
	@current="$(PROJECT_VERSION)"; \
	base="$${current%%-*}"; \
	major="$${base%%.*}"; \
	new_major=$$((major + 1)); \
	new_version="$$new_major.0.0"; \
	echo "Bump major: $$current -> $$new_version"; \
	$(BUMP) bump version --new-version "$$new_version"

version:
	@echo "$(PROJECT_NAME) version: $(PROJECT_VERSION)"

# ---------------------------------------------------------------------------
# Cleanup
# ---------------------------------------------------------------------------

clean:
	rm -rf \
		site \
		.mkdocs-cache
