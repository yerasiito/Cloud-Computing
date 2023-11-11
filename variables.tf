variable "user_name" {
    description = "Your stuser name"
    type = string
}

variable "user_password" {
    description = "The password from your stuser"
    sensitive = true
}

variable "ssh_key_pair_name" {
    description = "The name of your ssh key pair"
    type = string
}

variable "openstack_auth_url" {
    type = string
    default = "https://h-da.cloud:13000"
}

variable "openstack_user_domain_name" {
    type = string
    default = "h-da.de"
}

variable "openstack_region_eu_central" {
    type = string
    default = "eu-central"
}

variable "openstack_tenant_id" {
    type = string
    default = "601bbd1a98d64fbb9be56bb801146a98"
}

variable "openstack_image_id_debian" {
    type = string
    default = "ddea80d7-c762-4f8d-9837-9f3369b3bb1f"
}

variable "openstack_flavor_id_m1_small" {
    type = string
    default = "421c941e-7375-4239-92d5-d43b1fbc0480"
}

variable "openstack_network_name" {
    type = string
    default = "cct-b8-network"
}