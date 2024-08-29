# Ludus_Child_Domain

Ansible role to create a child domain and domain controller based on the parent domain information. 

## WARNING 
Child domains created with this module (`ludus_child_domain`) module will NOT by default create the `domainadmin` user account. Make sure to use the default `administrator` username when you need to specify the domain administrator for the child domain created with this module. 

## Example 

```yaml
ludus: 
  
  # Create parent domain and domain controller first using ludus's primary-dc role
  - vm_name: "{{ range_id }}-Internal-VLAN20-pdc01"
    hostname: "pdc01"
    template: win2016-server-x64-template
    vlan: 20
    ip_last_octet: 20
    ram_gb: 4
    cpus: 1
    windows:
      sysprep: true 
    domain:
      fqdn: test.local
      role: primary-dc

  # Create Child domain/controller created with ludus_child_domain 
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
      parent_ea_user: "test.local\\administrator"
      parent_ea_password: "password"
      parent_dc_ip: "10.2.20.20"
      current_host_ip: "10.2.30.10"
