TOFU      ?= tofu
TERRAFORM ?= $(TOFU)

plan:
	$(TERRAFORM) plan

init:
	$(TERRAFORM) init

apply:
	$(TERRAFORM) apply

destroy:
	$(TERRAFORM) destroy

build:
	nix build .#

update:
	nix flake update

check lint:
	nix flake check

format fmt:
	nix fmt
