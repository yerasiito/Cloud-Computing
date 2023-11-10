variable "user_name" {
    description = "The name of the stuser"
    type = string
}

variable "user_password" {
    description = "The password for the stuser"
    sensitive = true
}

variable "ssh_key_pair_name" {
    description = "The name of the ssh key pair"
    type = string
}