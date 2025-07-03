variable "hosts" {
  description = "List of targets to gather facts from"
  type        = any
}

variable "ansible_cfg" {
  description = "Ansible configuration"
  type        = any
}

variable "vm_templates" {
  description = "List of VM templates to create"
  type        = any
}
