
module "setup_proxmox" {
    source = "../modules/setup_proxmox"
    hosts = local.hosts
    proxmox_cfg = local.proxmox
}

# module "instances" {
#     source = "../modules/vm_instances"
#     instances = local.hosts.proxmox
# 
#     depends_on = [ module.proxmox ]
# }

# module "gather_facts" {
#     source = "../modules/gather_facts" 
#     targets = local.hosts.proxmox
# 
#     depends_on = [ module.proxmox ]
# }
