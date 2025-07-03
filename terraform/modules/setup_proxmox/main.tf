resource "ansible_host" "nodes" {
  for_each = var.hosts

  name   = each.key
  groups = []

  variables = {
    ansible_host                 = each.key
    ansible_python_interpreter   = "/usr/bin/python3"
    ansible_config = "${path.module}/../ansible.cfg"
  }
}

resource "ansible_playbook" "setup_all_host" {
  for_each = var.hosts

  ansible_playbook_binary = "ansible-playbook"
  playbook                = "${path.module}/ansible/all_host.yml"

  name       = each.key
  replayable = false

  extra_vars = {
    custom_hosts = join("\n", [for k, v in var.hosts : "${v.ip} ${k}.local"])
    uplink_interface = each.value.network.uplink_interface
    mgmt_address     = each.value.network.mgmt.address
    mgmt_gateway     = each.value.network.mgmt.gateway
    vlan10_address   = each.value.network.vlan10.address
    vlan10_gateway   = each.value.network.vlan10.gateway
    vlan20_address   = each.value.network.vlan20.address
    vlan20_gateway   = each.value.network.vlan20.gateway
    vlan30_address   = each.value.network.vlan30.address
    vlan30_gateway   = each.value.network.vlan30.gateway
    ntp_servers      = join(" ", var.proxmox_cfg.ntp_servers)
    ansible_become_password      = var.ansible_cfg.become_password
  }

  depends_on = [ansible_host.nodes]
}

resource "ansible_playbook" "setup_pve_master" {
  for_each = { for k, v in var.hosts : k => v if v.role == "master" }

  ansible_playbook_binary = "ansible-playbook"
  playbook                = "${path.module}/ansible/pve_node.yml"

  name       = each.key
  replayable = false

  extra_vars = {
    role         = each.value.role
    cluster_name = var.proxmox_cfg.cluster_name
    ceph_devices = join(" ", each.value.ceph_devices)
    ceph_network = try(var.proxmox_cfg.networks.segments.ceph, "")
    ansible_become_password      = var.ansible_cfg.become_password
  }

  depends_on = [ansible_playbook.setup_all_host]
}

resource "ansible_playbook" "setup_pve_slave" {
  for_each = { for k, v in var.hosts : k => v if v.role == "slave" } 

  ansible_playbook_binary = "ansible-playbook"
  playbook                = "${path.module}/ansible/pve_node_slave.yml"

  name = each.key
  replayable = true

  extra_vars = {
    role         = each.value.role
    cluster_name = var.proxmox_cfg.cluster_name
    master_ip  = [for k, v in var.hosts : v.ip if v.role == "master"][0]
    master_ssh_port = [for k, v in var.hosts : v.ssh_port if v.role == "master"][0]
    ceph_devices = join(" ", each.value.ceph_devices)
    ceph_network = try(var.proxmox_cfg.networks.segments.ceph, "")
    ansible_become_password      = var.ansible_cfg.become_password
  }

  depends_on = [ansible_playbook.setup_pve_master]
}

resource "ansible_playbook" "setup_pve_cluster" {
  for_each = { for k, v in var.hosts : k => v if v.role == "master" }

  ansible_playbook_binary = "ansible-playbook"
  playbook                = "${path.module}/ansible/pve_cluster.yml"

  name       = each.key
  replayable = false

  extra_vars = {
    proxmox_user = var.proxmox_cfg.user.name
    token_id     = var.proxmox_cfg.user.token_id
    output_path  = "${var.output_path}/proxmox_cluster_token.json"
    ansible_become_password      = var.ansible_cfg.become_password
  }

  depends_on = [ansible_playbook.setup_pve_slave]
}

