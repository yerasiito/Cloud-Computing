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

resource "openstack_compute_instance_v2" "test-server-tf" {
  name            = "test-server-tf"
  image_id        = var.openstack_image_id_debian 
  flavor_id       = var.openstack_flavor_id_m1_small
  key_pair        = var.ssh_key_pair_name
  security_groups = ["default","allow-ssh","allow-http","secgroup_grafana"]

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

resource "local_file" "tf_ansible_vars_file_new" {
  content = <<-DOC
      tf_floating_ip_1: ${openstack_networking_floatingip_v2.fip_1.address}
  DOC
  filename = "./tf_ansible_vars_file.yml"
}

