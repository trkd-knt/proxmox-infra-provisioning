
module "proxmox" {
    source = "../modules/proxmox"
    targets = local.hosts.proxmox   
}

module "gather_facts" {
    source = "../modules/gather_facts" 
    targets = local.hosts.proxmox
}
