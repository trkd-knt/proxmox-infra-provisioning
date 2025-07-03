locals {
  api_address = "localhost"
  pools = {
    test-group = {
      description = "Test group for VMs"
    }
  }
  instances = {
    # test instance
    vm1 = {
      name           = "vm-service-01"
      pool_name      = "test-group"
      host           = "pvegpu1"
      template_name  = "debian12-template"

      cpu = {
        cores   = 2
        sockets = 1
      }

      memory = 2048

      storage = {
        size     = "10G"
        location = "local-lvm"
      }

      network = {
        service = {
          bridge     = "ovsbr0"
          ip_address = "192.168.100.101/24"
          gateway    = "192.168.100.1"
          vlan       = null
        }
        mngt = {
          bridge     = "vmbr30"
          ip_address = "10.0.30.101/24"
          gateway    = "10.0.30.11"
          vlan       = 30
        }
      }

      ssh_pubkey       = file("../../outputs/pmx_id_rsa.pub")
    }
    # test instance
    vm2 = {
      name           = "vm-service-02"
      pool_name      = "test-group"
      host           = "pve1"
      template_name  = "debian12-template"

      cpu = {
        cores   = 2
        sockets = 1
      }

      memory = 2048

      storage = {
        size     = "30G"
        location = "local-lvm"
      }

      network = {
        service = {
          bridge     = "ovsbr0"
          ip_address = "192.168.100.102/24"
          gateway    = "192.168.100.1"
          vlan = null
        }
        mngt = {
          bridge     = "vmbr30"
          ip_address = "10.0.30.102/24"
          gateway    = "10.0.30.11"
          vlan = 30
        }
      }

      ssh_pubkey       = file("../../outputs/pmx_id_rsa.pub")
    }
  }
}
