**Toolchain**

- 1. OpenStack
- 2. OpenStack
- 3. GitLab CI/CD
- 4. Terraform + Ansible
- 5. Grafana + usable data source
- 6. Application (tbd)

## Creating application credentials
First you need to create the application credentials and place the `clouds.yaml` file in the `terraform` directory. It needs to be the directory where you initialize terraform. The file should look like the `clouds-example.yaml` but with your credentials.

## Steps
### 1. Step
Run `terraform init` to initialize the terraform modules.

### 2. Step
Run `terraform plan` to see what terraform will do.

### 3. Step
Run `terraform apply` to apply the changes.

### 4. Step
Run `terraform destroy` to destroy the infrastructure.