#!make
.DEFAULT_GOAL := all
task = "deploy"
limit = ""

lint:
	ansible-lint

deps:
	pip install --upgrade -r requirements.txt
	ansible-galaxy collection install --upgrade -r requirements.yml

nutscan:
	ansible-playbook ./playbooks/utils/nutscan.yml -i ./inventory -l ${limit} -v

%:
	./scripts/run.sh -a $@ -t ${task} -l ${limit}

