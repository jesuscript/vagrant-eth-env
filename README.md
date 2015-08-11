# Vagrant/Ansible virtual box configs for dapp development

Ubuntu 14.04 with
* [geth](https://github.com/ethereum/go-ethereum)
* [pyethereum](https://github.com/ethereum/pyethereum)
* [embark](https://github.com/iurimatias/embark-framework)

Creates a synced `DAPPS` directory in the host's and guest's home directories. Any files and directories created inside the synced directory are shared between your virtual and host environments.

The system is fully configured for you to run geth and use Embark with full support for tests.

You can start building Dapps right now.

## Dependencies

* [Vagrant](http://docs.vagrantup.com/v2/installation/)
* [Ansible](http://docs.ansible.com/ansible/intro_installation.html)
* nfsd (pre-installed on OS X, typically a simple package install on Linux)

## Usage:

```bash
vagrant up # initialises the box. may take some time
vagrant ssh # ssh into the box
vagrant suspend # stop the guest machine
vagrant resume # resume from the point where the machine was last suspended
```

