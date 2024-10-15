# Ludus_Ansible_Roles

Custom (scuffed) ansible roles for the [ludus project](https://gitlab.com/badsectorlabs/ludus). 

Do not use modules other then the two below. They are made for my homelab and not tested. 

- ludus_child_domain: Create a child domain and domain controller because ansible's `microsoft.ad` doesn't support it 

- ludus_child_domain_join: Join a machine to the child domain created from `ludus_child_domain`, since ludus's backend does not support domain/controllers created with 3rd party ansible roles 

## Installation 

```bash
cd ./ludus_ansible_roles 
export LUDUS_API_KEY='<your-ludus-key>'
ludus ansible role add -d ./ludus_child_domain_join/
ludus ansible role add -d ./ludus_child_domain/ 
```

## Updating 

- Whenever you modify/update the ansible roles, ensure to remove and re-add them to ludus. For example: 

```bash
ludus ansible role rm ludus_child_domain_join/ ; ludus ansible role add -d ./ludus_child_domain_join/
```