# QIIME 2 CI/Build System Setup/Notes

**Disclaimer**: This is a work in progress.

## Getting Started

This ansible playbook is for orchestrating deployment of Concourse CI.

### Setting up agent machine (e.g. dev laptop)

- install ansible 2.2
- `git clone https://github.com/qiime2/busywork`
- `cd busywork/provisioning`
- Define your inventory and host vars as necessary

### Setting up linux hosts

This playbook assumes that the linux host as already been provisioned with
docker and nginx. For an example of this, please see
https://github.com/caporaso-lab/powertrip-provisioning

### Setting up mac hosts

- Ensure SSH access is enabled on the mac host
- Set up a keypair to use for access
- From agent machine: `scp bin/bootstrap-mac-host.sh USER@MACHOST:~/`
- On mac host:
    - `chmod +x bootstrap-mac-host.sh`
    - `./bootstrap-mac-host.sh`
    - Follow the prompts

## Provisioning

- Linux main hosts:

    ```bash
    $ ansible-playbook -i /path/to/inventory -K --extra-vars 'tsa_keys=/path/to/keys' atc.yml
    ```

- Linux worker hosts:

    ```bash
    $ ansible-playbook -i /path/to/inventory -K --extra-vars 'tsa_keys=/path/to/keys' linux_workers.yml
    ```

- Mac worker hosts:

    ```bash
    $ ansible-playbook -i /path/to/inventory -K --extra-vars 'tsa_keys=/path/to/keys' mac_workers.yml
    ```
