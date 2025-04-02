
module "proxmox" {
    source = "../modules/proxmox"
    targets = local.hosts.proxmox   
}

module "facts" {
    source = "../modules/facts" 
    targets = local.hosts.proxmox
    depends_on = [ module.proxmox ]
}
