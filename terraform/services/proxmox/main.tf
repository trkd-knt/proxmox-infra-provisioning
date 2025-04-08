module "setup_proxmox" {
    source = "../../modules/setup_proxmox"
    hosts = local.hosts
    proxmox_cfg = local.proxmox
    output_path = abspath("../../outputs")
}
