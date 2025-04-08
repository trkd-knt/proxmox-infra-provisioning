resource "ansible_host" "nodes" {
  for_each = var.hosts

  name   = each.value.ip
  groups = []

  variables = {
    ansible_host                  = each.value.ip
    ansible_user                  = "root"
    ansible_ssh_private_key_file = "./id_rsa"
    ansible_python_interpreter   = "/usr/bin/python3"

    # # reference in ansible create_token playbook
    # proxmox_user = "root@pam"
    # token_id     = "terraform"
    # output_path  = "/tmp/pve_token_${each.value.ip}.json"
    ansible_config = "${path.module}/../ansible.cfg"
  }
}

resource "ansible_playbook" "setup_all_host" {
  for_each = var.hosts

  ansible_playbook_binary = "ansible-playbook"
  playbook                = "${path.module}/ansible/all_host.yml"

  name = each.value.ip
  replayable = false

  extra_vars = {
    network = {
      uplink_interface = each.value.uplink_interface
      mgmt = {
        address = each.value.manageip
        gateway = each.value.gatewayip
      }
      vlan10 = {
        address = each.value.vlan10.address
        gateway = each.value.vlan10.gateway
      }
      vlan20 = {
        address = each.value.vlan20.address
        gateway = each.value.vlan20.gateway
      }
      vlan30 = {
        address = each.value.vlan30.address
        gateway = each.value.vlan30.gateway
      }
    }
    ntp_servers = join(" ", each.value.ntp_servers)
  }

  depends_on = [ansible_host.nodes]
}

resource "ansible_playbook" "setup_pve_master" {
  for_each = { for k, v in var.hosts : k => v if v.role == "master" } 

  ansible_playbook_binary = "ansible-playbook"
  playbook                = "${path.module}/ansible/pve_node_master.yml"

  name = each.value.ip
  replayable = true

  extra_vars = {
    role = each.value.role
    cluster_name = var.proxmox_cfg.cluster_name
    ceph_devices =  join(" ", each.value.ceph_devices)
    ceph_network = try(var.proxmox_cfg.networks.segments.ceph, "")
  }

  depends_on = [ansible_playbook.setup_all_host]
}

# resource "ansible_playbook" "setup_pve_slave" {
#   for_each = { for k, v in var.hosts : k => v if v.role == "slave" } 
# 
#   ansible_playbook_binary = "ansible-playbook"
#   playbook                = "${path.module}/ansible/setup_pve_slave.yml"
# 
#   name = each.value.ip
#   replayable = false
# 
#   variables = {
#     cluster_name =  "pve_cluster"
#   }
# 
#   depends_on = [ansible_playbook.setup_pve_master]
# }

resource "ansible_playbook" "setup_pve_cluster" {
  for_each = { for k, v in var.hosts : k => v if v.role == "master" } 

  ansible_playbook_binary = "ansible-playbook"
  playbook                = "${path.module}/ansible/pve_cluster.yml"

  name = each.value.ip
  replayable = false

  extra_vars = {
    proxmox_user = var.proxmox_cfg.user.name
    token_id = var.proxmox_cfg.user.token_id
    output_path = "${var.output_path}/proxmox_cluster_token.json"
  }

  # depends_on = [ansible_playbook.setup_pve_slave]
  depends_on = [ansible_playbook.setup_pve_master]
  
}

