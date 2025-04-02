resource "ansible_host" "nodes" {
  for_each = var.targets

  name   = each.value.ip
  groups = []

  variables = {
    ansible_host                  = each.value.ip
    ansible_user                  = "root"
    ansible_ssh_private_key_file = "./id_rsa"
    ansible_python_interpreter   = "/usr/bin/python3"
  }
}

resource "ansible_playbook" "gather_facts" {
  for_each = var.targets

  ansible_playbook_binary = "ansible-playbook"
  playbook                = "${path.module}/../ansible/playbooks/gather_facts.yml"

  name = each.value.ip

  depends_on = [ansible_host.nodes]
}
