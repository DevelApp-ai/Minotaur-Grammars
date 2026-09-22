# Vagrantfile

Grammar for Vagrantfiles: machine definitions with providers and provisioners, box settings, networking, synced folders and shared variables.

## Syntax sketch

```
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
end
```

## AST validation goals

- Box name format
- Forwarded port uniqueness and range
- Provider option validity
- Provisioner type/option validity
- Machine define name uniqueness

Implements issue #42.

## Coverage completion

Completes coverage with other providers (hyperv/vmware/aws), winrm communicator, post-up messages, push definitions, box_check_update, and disk customization.
