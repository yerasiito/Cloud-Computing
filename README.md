**Toolchain**

- 1. OpenStack
- 2. OpenStack
- 3. GitLab CI/CD
- 4. Terraform + Ansible
- 5. Grafana + usable data source
- 6. Application (tbd)


## Preparation
1. Add a personal token in gitlab:
```
Token name: gitlab-ci-token
Expiration date: empty
Role: Maintainer
Scopes: mark all boxes
```
Copy the generated access token and export it with:
`export GITLAB_CI_TOKEN="your_token"`
You can add this to your .bashrc or .zshrc

2. Create a ssh key in openstack and save the generated file in ~/.ssh
Name: gitlab_ci_cd (mandatory)

3. Create identity key:
```
Name: not relevant
Expiration date: empty
Roles: creator
```
Download the `cloud.yaml` and overwrite it in the cloned repo. `cp ../clouds.yaml terraform/`

## Usage

### 1. Step
Initialize terraform modules:
```
(cd terraform && 
terraform init -backend-config="password=$GITLAB_CI_TOKEN")
```

### 2. Step
To see what terraform will do execute:
```
(cd terraform && 
terraform plan)
```

### 3. Step
To apply the changes execute:
```
(cd terraform && 
terraform apply)
```

### 4. Step
Export the host fixed ip variable, we need it to send the metrics to host later:
```
cd terraform
export TF_VAR_fixed_ip=$(terraform output -raw host_fixed_ip)
cd ..
```

### 5. Step
Run ansible to install and configure the needed monitoring packages:
```
(cd ansible &&
# Configure host machine
ansible-playbook -i inventory.yaml host_playbook.yaml --key-file "~/.ssh/gitlab_ci_cd"

# Configure guest machine
ansible-playbook -i inventory.yaml clients_playbook.yaml --key-file "~/.ssh/gitlab_ci_cd")
```

### 6. Step: Open grafana in your browser
Execute ```(cd terraform && terraform output host_ip)``` to see the ip of the host. Open your browser and enter the ip with port 3000 like this:\
http://host_ip:3000/login

Enter with:\
Username: admin\
Password: admin

Click the toggle menu and select "Dashboards". Now you can select the dashboard you want in order to monitor the servers:
![](monitoring.png)

### 7. Step
To destroy the infrastructure execute:
```
(cd terraform &&
terraform destroy)
```
