# DISCLAIMER 

THIS MODULE IS CREATED FOR MY HOMELAB. IT IS NOT TESTED AND WILL NOT WORK ON YOURS. 

# ludus_child_domain

Uses https://docs.ansible.com/ansible/11/collections/microsoft/ad/domain_child_module.html to create child domain and domain controller 

## Installation  
- This module requries `microsoft.ad.child_domain` module, which was released on 1.6. Since ludus uses 1.4.0, we need to update/insteall the newer version of `microsoft.ad` collection first. 
```
ludus ansible collections add microsoft.ad --version 1.8.1
```

- Then, install this role:
```
git clone 
cd ./ludus_ansible_roles
ludus ansible role add -d ./ludus_child_domain
```

## Example 
- Parent Domain: example.local 
- Child Domain: kr.example.local

```yaml
ludus: 
  - vm_name: "dc01-example-local"
    hostname: "dc01"
    template: win2022-rapt
    vlan: 10 
    ip_last_octet: 10 
    ram_gb: 2
    cpus: 1
    windows:
      sysprep: true
    domain:
      fqdn: example.local
      role: primary-dc 

  - vm_name: "kdc01-kr-example-local"
    hostname: "kdc01"
    template: win2022-rapt
    vlan: 20 
    ip_last_octet: 10 
    ram_gb: 2
    cpus: 1
    windows:
      sysprep: true
    roles:
      - ludus_child_domain_reborn
    role_vars:
      dns_domain_name: kr.example.local
      domain_admin_user: domainadmin@example.local
      domain_admin_password: password
      safe_mode_password: password
      create_dns_delegation: true 
      parent_dc_ip: "10.2.10.10"
      current_host_ip: "10.2.20.10"
      reboot: true
```
