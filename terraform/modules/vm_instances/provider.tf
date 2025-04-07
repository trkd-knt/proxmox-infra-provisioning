terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.11"
    }
  }
}
provider "proxmox" {
  pm_api_token_id     = "root@pam!terraform"
  pm_api_token_secret = "6a745d8c-25e7-43f4-891d-787368bb775c"
  pm_api_url          = "https://localhost:8006/api2/json"
  pm_tls_insecure     = true
}
