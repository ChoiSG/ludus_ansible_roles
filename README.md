# Ludus_Ansible_Roles

Custom (scuffed) ansible roles for the [ludus project](https://gitlab.com/badsectorlabs/ludus). 

- ludus_child_domain: Create a child domain and domain controller because ansible's `microsoft.ad` doesn't support it 

- ludus_child_domain_join: Join a machine to the child domain created from `ludus_child_domain`, since ludus's backend does not support domain/controllers created with 3rd party ansible roles 

