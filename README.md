# A really big disclaimer
This branch does not work on the MAIN branch.
Don't merge it!

## Terraform changes
I added this part to the variables, which is necessary for the ansible playbook to work.
In the future this must be replaced with a gitlab variable (like the ssh key in general)
```
variable "local_ssh_key_pair_path" {
    description = "The path to your local ssh key pair"
    type = string
    default = "~/.ssh/id_ed25519"
}
```

In the main.tf I added the following line to execute the ansible playbook.
It is not a good solution at all. We have a sleep at the beginning, since I did not figured out
how to wait for the instance to be ready. Also this part should be in the resource `openstack_compute_instance_v2` and not in the resource `openstack_networking_floatingip_v2`.
So here is plenty of room for improvement.
```
  provisioner "local-exec" {
    command = "sleep 30;ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${openstack_networking_floatingip_v2.fip_1.address}, -u debian --private-key=${var.local_ssh_key_pair_path} playbook.yml"
  }
```

## Ansible
I added a new playbook named `playbook.yml` and a `ansible.cfg` file.
The `ansible.cfg` file however is not accepted in my wsl and I had to add `ANSIBLE_HOST_KEY_CHECKING=False` in front of the ansible command.
The ansible script will update the server and install a nginx webserver on it.
This seems to be working fine so far. But again it is not ready to be merged into the main branch.


**Toolchain**

- 1. OpenStack
- 2. OpenStack
- 3. GitLab CI/CD
- 4. Terraform + Ansible
- 5. Grafana + usable data source
- 6. Application (tbd)


## Steps
### 1. Step
Run `terraform init` to initialize the terraform modules.

### 2. Step
Run `terraform plan` to see what terraform will do.

### 3. Step
Run `terraform apply` to apply the changes.

### 4. Step
Run `terraform destroy` to destroy the infrastructure.