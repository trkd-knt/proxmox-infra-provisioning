resource "ansible_host" "node" {

  name   = var.target.ip
  groups = []

  variables = {
    ansible_host                  = var.target.ip
    ansible_user                  = "root"
    ansible_ssh_private_key_file = "./id_rsa"
    ansible_python_interpreter   = "/usr/bin/python3"
  }
}

resource "ansible_playbook" "setup_pve" {
  ansible_playbook_binary = "ansible-playbook"
  playbook                = "${path.module}/ansible/setup_pve.yml"

  name = var.target.ip
  replayable = false

  depends_on = [ansible_host.nodes]
}
