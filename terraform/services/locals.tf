locals {
    proxmox = {
        cluster_name = "pve-cluster"
        user = {
            name = "terraform@pam"
            token_id = "terraform"
        }
        networks = {
            segments = {
                manage  = "192.168.1.0/24"
                storage = "192.168.1.0/24"
                ceph    = "192.168.1.0/24"
            }
            vlans = {
                vlan10 = {
                    bridge = "vmbr0"
                    segument = "192.168.10.0"
                    netmask = "255.255.255.0"
                }
                vlan20 = {
                    bridge = "vmbr0"
                    segument = "192.168.10.0"
                    netmask = "255.255.255.0"
                }
                vlan30 = {
                    bridge = "vmbr0"
                    segument = "192.168.10.0"
                    netmask = "255.255.255.0"
                }
            }
        }
        ntp_servers = [
            "0.pool.ntp.org",
            "1.pool.ntp.org",
        ]
    }

    hosts = {
        pve01 = {
            ip = "192.168.1.13"
            network = {
              uplink_interface = "eth0"
              mgmt = {
                address = "192.168.1.14"
                gateway = "192.168.1.1"
              }
              vlan10 = {
                address = "192.168.10.0/24"
                gateway = "192.168.10.100"
              }
              vlan20 = {
                address = "192.168.20.0/24"
                gateway = "192.168.20.100"
              }
              vlan30 = {
                address = "192.168.30.0/24"
                gateway = "192.168.30.100"
              }
            }

            role = "master"
            eni = {
               service = "eth0"
            }
            ntp_servers = [
                "0.pool.ntp.org",
                "1.pool.ntp.org",
            ]
            ceph_devices = [
                "/dev/sdb",
                "/dev/sdc"
             ]
        }
    }

    instances = {
        test = {}
    }
}
