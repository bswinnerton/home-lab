# Ansible

Ansible is a tool for configuration management. If you want to apply the
configurations in this directory to the fleet, `cd` into this directory and run
the following.

```
ansible-galaxy install -r requirements.yml
ansible-playbook -i hosts.yml --ask-become-pass site.yml
```

Or if you want to first do a dry run:

```
ansible-playbook -i hosts.yml --ask-become-pass --check site.yml
```
