terraform {
  backend "http" {
    address        = "https://code.fbi.h-da.de/api/v4/projects/31281/terraform/state/tf_state"
    lock_address   = "https://code.fbi.h-da.de/api/v4/projects/31281/terraform/state/tf_state/lock"
    unlock_address = "https://code.fbi.h-da.de/api/v4/projects/31281/terraform/state/tf_state/lock"
    username       = "gitlab-ci-token"
    lock_method    = "POST"
    unlock_method  = "DELETE"
  }

  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}

provider "openstack" {
  cloud = "openstack"
}

resource "openstack_compute_instance_v2" "test-server-tf" {
  name            = "test-server-tf"
  image_id        = var.openstack_image_id_debian 
  flavor_id       = var.openstack_flavor_id_m1_small
  key_pair        = var.ssh_key_pair_name
  security_groups = ["default","allow-ssh"]

  network {
    name = var.openstack_network_name
  }
}

resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "public-2"
}

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
  instance_id = "${openstack_compute_instance_v2.test-server-tf.id}"
  fixed_ip    = "${openstack_compute_instance_v2.test-server-tf.network.0.fixed_ip_v4}"
}
