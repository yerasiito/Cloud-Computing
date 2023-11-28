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

## Ansible
I added a new playbook named `playbook.yml` and a `ansible.cfg` file.
The `ansible.cfg` file however is not accepted in my wsl and I had to add `ANSIBLE_HOST_KEY_CHECKING=False` in front of the ansible command.
The ansible script will update the server and install a nginx webserver on it.
This seems to be working fine so far. But again it is not ready to be merged into the main branch.
The 20 second sleep is currently necessary because the server is not ready to accept ssh connections immediately after the creation.

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
