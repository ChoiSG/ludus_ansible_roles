# Ludus_Child_Domain_Join 

Ansible role to join a machine to the child domain created from the `ludus_child_domain` ansible role. 

## WARNING 
Child domains created with the `ludus_child_domain` module in this GitHub repository will by default NOT create the `domainadmin` user account. Make sure to specify `administrator` as the domain administrator username when using this module to domain join into the child domain.


## Example 

```yaml
ludus: 

  # Create parent domain using ludus's primary-dc role...

  # Child domain/controller created with ludus_child_domain 
  - vm_name: "{{ range_id }}-Internal-VLAN30-devdc01"
    hostname: "devdc01"
    template: win2016-server-x64-template
    vlan: 30
    ip_last_octet: 10
    ram_gb: 4
    cpus: 1
    windows:
      sysprep: true 
    roles:
      - ludus_child_domain
    role_vars:
      parent_domain_name: "test.local"
      new_domain_name: "dev"
      parent_ea_user: "test.local\\domainadmin" # ludus default domainadmin user account  
      parent_ea_password: "password"
      parent_dc_ip: "10.2.20.20"
      current_host_ip: "10.2.30.10"

  # Ludus_Child_Domain_Join to the child domain controller from above
  - vm_name: "{{ range_id }}-Internal-VLAN30-fs01"
    hostname: "fs01"
    template: win2016-server-x64-template
    vlan: 30
    ip_last_octet: 20
    ram_gb: 2
    cpus: 1
    windows:
      sysprep: true
    roles:
      - ludus_child_domain_join
    role_vars:
      dc_ip: "10.2.30.10"
      dns_domain_name: "dev.test.local"
      domain_admin_user: "administrator@dev.test.local"  # <user>@<domain> format. Use `administrator`, since ludus's domainadmin default user is not created with ludus_child_domain 
      domain_admin_password: "password"
```
