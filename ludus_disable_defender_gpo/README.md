# DISCLAIMER 

THIS MODULE IS CREATED FOR MY HOMELAB. IT IS NOT TESTED AND WILL NOT WORK ON YOURS. 

# ludus_disable_defender_gpo  

Ansible role that really just executes a custom powershell script, which happens to create GPO that disables defender. 
This really should be done at the packer level when creating iso, but too lazy. 

## Usage 
```
git clone 
cd ./ludus_ansible_roles
ludus ansible role add -d ./ludus_disable_defender_gpo [--user <user>] 

# Modify or update, re-implement module 
ludus ansible role rm ludus_disable_defender_gpo [--user <user>]  
ludus ansible role add -d ./ludus_disable_defender_gpo [--user <user>]
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
      - ludus_disable_defender_gpo 
```

## Check 
```
nltest /domain_trusts
get-adtrust -filter * 
```