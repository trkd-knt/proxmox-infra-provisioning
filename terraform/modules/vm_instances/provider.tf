terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc8"
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

# root@pve1:~# pveum user token add iac@pam terraform2 --output-format json
# {"full-tokenid":"iac@pam!terraform2","info":{"privsep":1},"value":"fd7ab27c-473a-48ab-8113-eaee9064e3b2"}
# root@pve1:~# 