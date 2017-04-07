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

### Setting up darwin hosts

- Ensure SSH access is enabled on the mac host (copy `authorized_keys` from secrets)
- From agent machine: `scp bin/bootstrap-darwin-host.sh USER@MACHOST:~/`
- On darwin host:
    - `./bootstrap-darwin-host.sh`
    - Follow the prompts

## Setting Up Hosts

- Set up all machines:

    ```bash
    $ SECRETS=/absolute/path/to/secrets_repo make setup_all
    ```

- Linux main hosts:

    ```bash
    $ SECRETS=/absolute/path/to/secrets_repo make setup_atc
    ```

- Linux worker hosts:

    ```bash
    $ SECRETS=/absolute/path/to/secrets_repo make setup_linux_workers
    ```

- Darwin worker hosts:

    ```bash
    $ SECRETS=/absolute/path/to/secrets_repo make setup_darwin_workers
    ```

## Tearing Down Hosts

- Tear down all machines:

    ```bash
    $ SECRETS=/absolute/path/to/secrets_repo make teardown_all
    ```

- Linux main hosts:

    ```bash
    $ SECRETS=/absolute/path/to/secrets_repo make teardown_atc
    ```

- Linux worker hosts:

    ```bash
    $ SECRETS=/absolute/path/to/secrets_repo make teardown_linux_workers
    ```

- Darwin worker hosts:

    ```bash
    $ SECRETS=/absolute/path/to/secrets_repo make teardown_darwin_workers
    ```
