resource "openstack_networking_secgroup_v2" "secgroup_grafana" {
  name        = "secgroup_grafana"
  description = "Terraform security group for grafana"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_grafana" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3000
  port_range_max    = 3000
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_grafana.id
}

### Create instances

resource "openstack_compute_instance_v2" "host" {
  name            = "host"
  image_id        = var.openstack_image_id_debian
  flavor_id       = var.openstack_flavor_id_m1_small
  key_pair        = var.ssh_key_pair_name
  security_groups = ["default","allow-ssh","allow-http","secgroup_grafana"]

  network {
    name = var.openstack_network_name
  }
}

resource "openstack_compute_instance_v2" "guest1" {
  name            = "guest1"
  image_id        = var.openstack_image_id_debian
  flavor_id       = var.openstack_flavor_id_m1_small
  key_pair        = var.ssh_key_pair_name
  security_groups = ["default","allow-ssh","allow-http"]

  network {
    name = var.openstack_network_name
  }
}

resource "openstack_compute_instance_v2" "guest2" {
  name            = "guest2"
  image_id        = var.openstack_image_id_debian
  flavor_id       = var.openstack_flavor_id_m1_small
  key_pair        = var.ssh_key_pair_name
  security_groups = ["default","allow-ssh","allow-http"]

  network {
    name = var.openstack_network_name
  }
}

### pools ###

resource "openstack_networking_floatingip_v2" "fip_host" {
  pool = "public-2"
}

resource "openstack_networking_floatingip_v2" "fip_guest1" {
  pool = "public-2"
}

resource "openstack_networking_floatingip_v2" "fip_guest2" {
  pool = "public-2"
}

### IPs association  ###

resource "openstack_compute_floatingip_associate_v2" "fip_host" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_host.address}"
  instance_id = "${openstack_compute_instance_v2.host.id}"
  fixed_ip    = "${openstack_compute_instance_v2.host.network.0.fixed_ip_v4}"
}

resource "openstack_compute_floatingip_associate_v2" "fip_guest1" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_guest1.address}"
  instance_id = "${openstack_compute_instance_v2.guest1.id}"
  fixed_ip    = "${openstack_compute_instance_v2.guest1.network.0.fixed_ip_v4}"
}

resource "openstack_compute_floatingip_associate_v2" "fip_guest2" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_guest2.address}"
  instance_id = "${openstack_compute_instance_v2.guest2.id}"
  fixed_ip    = "${openstack_compute_instance_v2.guest2.network.0.fixed_ip_v4}"
}

### Inventory file ###

resource "local_file" "ansible_inventory" {
  content  = <<-EOT
    all:
      hosts:
        host:
          ansible_host: ${openstack_networking_floatingip_v2.fip_host.address}  
      children:
          guests:
            hosts:
              guest1:
                ansible_host: ${openstack_networking_floatingip_v2.fip_guest1.address}
              guest2:
                ansible_host: ${openstack_networking_floatingip_v2.fip_guest2.address}
    EOT
  filename = "../ansible/inventory.yaml"
}

### Outputs ###

output "guest1_ip" {
  value = openstack_networking_floatingip_v2.fip_guest1.address
}

output "guest2_ip" {
  value = openstack_networking_floatingip_v2.fip_guest2.address
}

output "host_fixed_ip" {
  value = openstack_compute_instance_v2.host.network.0.fixed_ip_v4
}

output "host_ip" {
  value = openstack_networking_floatingip_v2.fip_host.address
}