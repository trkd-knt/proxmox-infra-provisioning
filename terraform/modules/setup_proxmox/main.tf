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
  }
}

resource "ansible_playbook" "setup_all_host" {
  for_each = var.hosts

  ansible_playbook_binary = "ansible-playbook"
  playbook                = "${path.module}/ansible/all_host.yml"

  name = each.value.ip
  replayable = false

  extra_vars = {
    uplink_interface = each.value.eni.service
    ovs_ip_address = each.value.ip
    ovs_gateway =  each.value.gatewayip
    # ntp_servers = each.value.ntp_servers
  }

  depends_on = [ansible_host.nodes]
}

# resource "ansible_playbook" "setup_pve_master" {
#   for_each = { for k, v in var.hosts : k => v if v.role == "master" } 
# 
#   ansible_playbook_binary = "ansible-playbook"
#   playbook                = "${path.module}/ansible/setup_pve_master.yml"
# 
#   name = each.value.ip
#   replayable = false
# 
#   depends_on = [ansible_playbook.setup_all_host]
# }
# 
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
# 
# resource "ansible_playbook" "setup_pve_cluster" {
#   for_each = { for k, v in var.hosts : k => v if v.role == "master" } 
# 
#   ansible_playbook_binary = "ansible-playbook"
#   playbook                = "${path.module}/ansible/setup_pve_cluster.yml"
# 
#   name = each.value.ip
#   replayable = false
# 
#   variables = {
#     master_ip =  [for k, v in var.targets : v.ip if v.role == "master"][0]
#   }
# 
#   depends_on = [ansible_playbook.setup_pve_slave]
# }

