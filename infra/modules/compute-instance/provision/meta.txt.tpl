#cloud-config
users:
  - name: ${ssh_user}
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - ${ssh_key_default}
%{ for ssh_key in ssh_keys_additional ~}
      - ${ssh_key}
%{ endfor ~}
