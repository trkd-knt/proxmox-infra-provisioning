resource "ansible_group" "proxmox" {
  name = "targets"

  variables = {
    ansible_become        = "yes"
    ansible_become_method = "sudo"
    ntp_server            = "ntp.nict.jp"
    timezone              = "Asia/Tokyo"
  }
}

resource "ansible_host" "nodes" {
  for_each = var.targets

  name   = each.value.ip
  groups = ["targets"]

  variables = {
    ansible_host                  = each.value.ip
    ansible_user                  = "root"
    ansible_ssh_private_key_file = "./id_rsa"
    ansible_python_interpreter   = "/usr/bin/python3"
  }
}

# resource "ansible_playbook" "gather_facts" {
#   for_each = var.targets
# 
#   name     = each.value.ip
#   playbook  = "${path.module}/ansible/playbooks/gather_facts.yml"
# 
#   # extra_vars = {
#   #   inventory_file = "${path.module}/ansible/inventory.yml"
#   # }
# 
#   depends_on = [
#     ansible_host.nodes,
#   ]
# }

resource "ansible_playbook" "gather_facts" {
  for_each = var.targets

  ansible_playbook_binary = "ansible-playbook"
  playbook                = "${path.module}/ansible/playbooks/gather_facts.yml"

  # inventory configuration
  name = each.value.ip

  # # ansible vault
  # vault_password_file = "vault-password-file.txt"
  # vault_files = [
  #   "vault-file.yml",
  # ]

  # connection configuration and other vars
  #extra_vars = {
  #  ansible_hostname   = docker_container.alpine_1.name
  #  ansible_connection = "docker"
#
  #  test_filename = "test_e2e_vault.txt"
  #}

  depends_on = [ansible_host.nodes] # make sure this resource waits for e2e_vars to finish
}