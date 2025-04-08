module "instances" {
    source = "../modules/vm_instances"
    api_address = local.hosts.pve01.ip
}