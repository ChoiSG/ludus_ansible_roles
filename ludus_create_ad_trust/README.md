# DISCLAIMER 

THIS MODULE IS CREATED FOR MY HOMELAB. IT IS NOT TESTED AND WILL NOT WORK ON YOURS. 

# ludus_create_ad_trust 

Ansible role to create AD trust relationship between two domains. Create Bidirectional, inbound, or outbound trust relationship. 

(a.k.a rawdogging powershell into ansible because i'm too lazy to convert GOAD's ad-trust ansible module)

## WARNING 
This role has been only tested on `primary-dc` created with ludus. Domain controllers created with `child_domain` and `child_domain_join` won't have DNS forwarder zone configured, so some errors might occur. For example, the local DC will have forwarder configured with this role, but the remote DC won't, so you'll have to manually configure it. I tried `invoke-command` to configure forwarder on the remote DC via winrm, but got winrm errors. 

## Usage 
```
git clone 
cd ./ludus_ansible_roles
ludus ansible role add -d ./ludus_create_ad_trust [--user <user>] 

# Modify or update, re-implement module 
ludus ansible role rm ludus_create_ad_trust [--user <user>]  
ludus ansible role add -d ./ludus_create_ad_trust [--user <user>]
ludus range config set -f <ludusconfig.yml>
ludus range deploy
```

## Example 
```yaml
ludus:
  - vm_name: "{{ range_id }}-test1"
    hostname: "pdc01"
    template: win2019-server-x64-template
    vlan: 10 
    ip_last_octet: 10 
    ram_gb: 2
    cpus: 1
    windows:
      sysprep: true
    domain:
      fqdn: choi.lab
      role: primary-dc 
    roles:
      - ludus_create_ad_trust                       # Running on 1 source/target DC is enough 
    role_vars:
      local_domain: "choi.lab"
      remote_domain: "factory.line"
      local_dns_server: "10.3.10.10"
      remote_dns_server: "10.3.20.10"
      local_admin_user: "domainadmin@choi.lab"
      local_admin_password: "password"
      remote_admin_user: "domainadmin@factory.line"
      remote_admin_password: "password"
      trust_direction: "Bidirectional"              # Bidirectional by default. Bidirectional, Inbound, Outbound 
      replication_scope: "Forest"                   # Forest by default. Forest, Domain 

  - vm_name: "{{ range_id }}-test2"
    hostname: "tdc01"
    template: win2019-server-x64-template
    vlan: 20 
    ip_last_octet: 10 
    ram_gb: 2
    cpus: 1
    windows:
      sysprep: true
    domain:
      fqdn: factory.line
      role: primary-dc 
```

## Check 
```
nltest /domain_trusts
get-adtrust -filter * 
```