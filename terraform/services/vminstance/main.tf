module "instances" {
  source      = "../../modules/vm_instances"
  api_address = local.api_address
  pools = local.pools
  instances = local.instances
}
