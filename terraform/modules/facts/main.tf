resource "ansible_group" "proxmox" {
  name = "all"

  variables = {
    ansible_become        = "yes"
    ansible_become_method = "sudo"
    ntp_server            = "ntp.nict.jp"
    timezone              = "Asia/Tokyo"
  }
}

resource "ansible_host" "pve_node1" {
  name   = "pve01"
  groups = ["all"]

  variables = {
    ansible_host                  = "192.168.0.10"
    ansible_user                  = "root"
    ansible_ssh_private_key_file = "./id_rsa"
    ansible_python_interpreter   = "/usr/bin/python3"
  }
}

resource "ansible_host" "pve_node2" {
  name   = "pve02"
  groups = ["all"]

  variables = {
    ansible_host                  = "192.168.0.11"
    ansible_user                  = "root"
    ansible_ssh_private_key_file = "./id_rsa"
    ansible_python_interpreter   = "/usr/bin/python3"
  }
}

resource "ansible_playbook" "gather_facts" {
  name     = "gather_facts"
  playbook  = "${path.module}/../ansible/playbooks/gather_facts.yml"

  depends_on = [
    ansible_host.pve_node1,
    ansible_host.pve_node2
  ]
}
