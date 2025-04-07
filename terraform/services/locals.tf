locals {
    proxmox = {
        cluster_name = "pve_cluster"
        networks = {
            segments = {
                manage  = "192.168.1.0/24"
                storage = "192.168.1.0/24"
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
        user = {
            name = "root@pam"
            token_id = "terraform"
        }
        ntp_servers = [
            "0.pool.ntp.org",
            "1.pool.ntp.org",
        ]
    }

    hosts = {
        pve01 = {
            ip = "192.168.1.14/24"
            gatewayip = "192.168.1.1"

            role = "master"
            eni = {
               service = "eth0"
            }
            ntp_servers = [
                "0.pool.ntp.org",
                "1.pool.ntp.org",
            ]
            ceph_storage_devices = [
                "/dev/sdb",
                "/dev/sdc"
             ]
        }
    }

    instances = {
        test = {}
    }
}
