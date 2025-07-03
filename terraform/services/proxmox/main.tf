module "setup_proxmox" {
  source      = "../../modules/setup_proxmox"
  hosts       = local.hosts
  proxmox_cfg = local.proxmox
  output_path = abspath("../../outputs")
  ansible_cfg = local.ansible
}

module "templates" {
  source      = "../../modules/vm_templates"
  hosts       = local.hosts
  ansible_cfg = local.ansible
  vm_templates = local.vm_templates
}

locals {
  vm_templates = {
    "debian12-template" = {
      vm_id          = 9000
      vm_name        = "debian12-template"
      vm_memory      = 2048
      vm_bridge      = "ovsbr0"
      vm_disk_resize = "10G"
      vm_storage     = "local-lvm"
      vm_image_url   = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
      vm_image_name  = "debian-12-genericcloud-amd64.qcow2"
    }
  }
}
