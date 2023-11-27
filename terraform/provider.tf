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