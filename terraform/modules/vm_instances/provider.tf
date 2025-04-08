terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.11"
    }
  }
}

locals {
  proxmox_token_data = jsondecode(file("${path.module}/../../outputs/proxmox_cluster_token.json"))
}
provider "proxmox" {
  pm_api_token_id     = local.proxmox_token_data["full-tokenid"]
  pm_api_token_secret = local.proxmox_token_data["value"]
  pm_api_url          = "https://${var.api_address}:8006/api2/json"
  pm_tls_insecure     = true
}
