#!make
.DEFAULT_GOAL := all
limit = ""

lint:
	ansible-lint --fix

deps:
	ansible-galaxy install --force-with-deps -r requirements.yml

nutscan:
	ansible-playbook ./playbooks/utils/nutscan.yml -i ./inventory -l ${limit} -v

%:
	ansible-playbook ./playbooks/$@.yml -i ./inventory -l ${limit} -v

