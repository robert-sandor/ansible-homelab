#!make

default: 
		ansible-playbook ./playbooks/main.yml -i ./inventory --diff

%:
		ansible-playbook ./playbooks/$@.yml -i ./inventory --diff

