#!make
.DEFAULT_GOAL := all

lint:
	ansible-lint --fix

deps:
	ansible-galaxy install --force-with-deps -r requirements.yml

all:
	ansible-playbook ./playbooks/all.yml -i ./inventory --diff

%:
	ansible-playbook ./playbooks/$@.yml -i ./inventory --diff

