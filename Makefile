#!make

playbook := main
default:
		ansible-playbook ./playbooks/${playbook}.yml -i ./inventory --diff


