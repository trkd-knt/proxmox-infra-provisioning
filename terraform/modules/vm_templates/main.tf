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

resource "ansible_playbook" "create_vm_template" {
  for_each = var.vm_templates

  ansible_playbook_binary = "ansible-playbook"
  playbook                = "${path.module}/ansible/vm_templates.yml"

  name       = [for k, v in var.hosts : k if v.role == "master"][0]
  replayable = false

  extra_vars = {
    vm_id = each.value.vm_id
    vm_name = each.value.vm_name
    vm_memory = each.value.vm_memory
    vm_bridge = each.value.vm_bridge
    vm_disk_resize = each.value.vm_disk_resize
    vm_storage = each.value.vm_storage
    vm_image_url = each.value.vm_image_url
    vm_image_name = each.value.vm_image_name
    ansible_become_password      = var.ansible_cfg.become_password
  }
}

# 共有ディスクがないときは必要
resource "ansible_playbook" "create_vm_template_svale1" {
  for_each = var.vm_templates

  ansible_playbook_binary = "ansible-playbook"
  playbook                = "${path.module}/ansible/vm_templates.yml"

  name       = [for k, v in var.hosts : k if v.role == "slave"][0]
  replayable = true

  extra_vars = {
    vm_id = tostring(tonumber(each.value.vm_id) + 1)
    vm_name = each.value.vm_name
    vm_memory = each.value.vm_memory
    vm_bridge = each.value.vm_bridge
    vm_disk_resize = each.value.vm_disk_resize
    vm_storage = each.value.vm_storage
    vm_image_url = each.value.vm_image_url
    vm_image_name = each.value.vm_image_name
    ansible_become_password      = var.ansible_cfg.become_password
  }
}

