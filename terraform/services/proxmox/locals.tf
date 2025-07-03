locals {
  proxmox = {
    cluster_name = "pve-cluster"
    user = {
      name     = "iac@pam"
      token_id = "terraform"
    }
    ntp_servers = [
      "0.pool.ntp.org",
      "1.pool.ntp.org",
    ]
  }

  ansible = {
    become_password      = var.become_password
  }

  hosts = {
    pve1 = {
      role = "master"
      ip = "192.168.100.196"
      ssh_port = "10122"
      network = {
        uplink_interface = "enx00e04c0a2480"
        mgmt = {
          address = "192.168.100.196/24"
          gateway = "192.168.100.1"
        }
        vlan10 = {
          address = "10.0.10.11/24"
          gateway = "10.0.10.100"
        }
        vlan20 = {
          address = "10.0.20.11/24"
          gateway = "10.0.20.100"
        }
        vlan30 = {
          address = "10.0.30.11/24"
          gateway = "10.0.30.100"
        }
      }
      ceph_devices = [
        "/dev/sdb2"
      ]
    }
    pvegpu1 = {
      role = "slave"
      ip = "192.168.100.195"
      ssh_port = "10022"
      network = {
        uplink_interface = "enp1s0"
        mgmt = {
          address = "192.168.100.195/24"
          gateway = "192.168.100.1"
        }
        vlan10 = {
          address = "10.0.10.15/24"
          gateway = "10.0.10.100"
        }
        vlan20 = {
          address = "10.0.20.15/24"
          gateway = "10.0.20.100"
        }
        vlan30 = {
          address = "10.0.30.15/24"
          gateway = "10.0.30.100"
        }
      }
      ceph_devices = [
        "/dev/sdb2"
      ]
    }
  }

  instances = {
    test = {}
  }
}

variable "become_password" {
  description = "Password for sudo access"
  type        = string
  sensitive   = true
}
