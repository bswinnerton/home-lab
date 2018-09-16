# Ansible

Ansible is a tool for configuration management. If you want to apply the
configurations in this directory to the fleet, `cd` into this directory and run
the following.

```
ansible-playbook -i hosts --ask-become-pass site.yml
```
