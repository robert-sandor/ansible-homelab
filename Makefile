#!make
.DEFAULT_GOAL := all
limit = ""

lint:
	ansible-lint --fix

deps:
	pip install --upgrade -r requirements.txt
	ansible-galaxy collection install --upgrade -r requirements.yml

nutscan:
	ansible-playbook ./playbooks/utils/nutscan.yml -i ./inventory -l ${limit} -v

%:
	ansible-playbook ./playbooks/$@.yml -i ./inventory -l ${limit} -v

