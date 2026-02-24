# Usage

## Install dependencies
ansible-galaxy collection install ansible.posix

## Encrypt your vault file
ansible-vault encrypt group_vars/wireguard/vault.yml

## Full install (first time)
ansible-playbook -i inventory/hosts.yml wireguard.yml --ask-vault-pass

## Only update peers (no reinstall, no restart)
ansible-playbook -i inventory/hosts.yml add-peers.yml --ask-vault-pass

## Run only peer-tagged tasks
ansible-playbook -i inventory/hosts.yml wireguard.yml --tags peers --ask-vault-pass

## Dry run
ansible-playbook -i inventory/hosts.yml wireguard.yml --check --ask-vault-pass

## Check current WireGuard status on server
ansible wireguard -i inventory/hosts.yml -m shell -a "wg show" --become

### Adding a New Peer
Just append to ``peers/peers.yml`` and run the peers-only playbook:

  - name: "desktop-charlie"
    public_key: "NEW_PEER_PUBLIC_KEY"
    allowed_ips: "10.0.0.5/32"
    preshared_key: ""
    persistent_keepalive: 25
    enabled: true

```ansible-playbook -i inventory/hosts.yml add-peers.yml --ask-vault-pass```

The ```wg syncconf``` command applies changes live without dropping existing connections.
