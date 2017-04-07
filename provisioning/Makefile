setup_atc:
	ansible-playbook \
		-i "$(SECRETS)/ansible_hosts/concourse/inventory" \
		--extra-vars 'tsa_keys=$(SECRETS)/ansible_hosts/concourse/tsa_keys' \
		setup_atc.yml

setup_linux_workers:
	ansible-playbook \
		-i "$(SECRETS)/ansible_hosts/concourse/inventory" \
		--extra-vars 'tsa_keys=$(SECRETS)/ansible_hosts/concourse/tsa_keys' \
		setup_linux_workers.yml

setup_darwin_workers:
	ansible-playbook \
		-i "$(SECRETS)/ansible_hosts/concourse/inventory" \
		--extra-vars 'tsa_keys=$(SECRETS)/ansible_hosts/concourse/tsa_keys' \
		setup_darwin_workers.yml

setup_all: setup_atc setup_linux_workers setup_darwin_workers

teardown_atc:
	ansible-playbook \
		-i "$(SECRETS)/ansible_hosts/concourse/inventory" \
		teardown_atc.yml

teardown_linux_workers:
	ansible-playbook \
		-i "$(SECRETS)/ansible_hosts/concourse/inventory" \
		teardown_linux_workers.yml

teardown_darwin_workers:
	ansible-playbook \
		-i "$(SECRETS)/ansible_hosts/concourse/inventory" \
		teardown_darwin_workers.yml

teardown_all: teardown_atc teardown_linux_workers teardown_darwin_workers
