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

resource "ansible_playbook" "gather_facts" {
  for_each = var.targets

  name     = each.value.ip
  playbook  = "${path.module}/ansible/playbooks/gather_facts.yml"

  extra_vars = {
    inventory_file = "${path.module}/ansible/inventory.yml"
  }

  depends_on = [
    ansible_host.nodes,
  ]
}
