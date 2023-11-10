terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}

provider "openstack" {
    user_name   = "${var.user_name}"
    password    = "${var.user_password}"
    tenant_id   = "601bbd1a98d64fbb9be56bb801146a98"
    auth_url    = "https://h-da.cloud:13000"
    region      = "eu-central" 
    user_domain_name = "h-da.de"
}


resource "openstack_compute_instance_v2" "test-server-tf" {
  name = "test-server-tf"
  image_id = "ddea80d7-c762-4f8d-9837-9f3369b3bb1f"
  flavor_id = "421c941e-7375-4239-92d5-d43b1fbc0480"
  key_pair = "${var.ssh_key_pair_name}"
  security_groups = ["default"]

  network {
    name = "cct-b8-network"
  }
}