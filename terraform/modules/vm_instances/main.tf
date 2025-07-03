resource "proxmox_pool" "pools" {
  for_each = var.pools

  poolid = each.key
  comment = each.value.description
}

resource "proxmox_vm_qemu" "instances" {
  for_each = var.instances

  name        = each.value.name
  target_node = each.value.host
  pool = each.value.pool_name

  clone       = each.value.template_name
 
  os_type     = "cloud-init"
  boot        = "order=scsi0"
  hotplug = "network,disk,usb"
  tablet = false

  bootdisk  = "scsi0"

  cores       = each.value.cpu.cores
  sockets     = each.value.cpu.sockets
  numa = true

  memory      = each.value.memory
  balloon = 0

  scsihw = "virtio-scsi-pci"

  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = each.value.storage.location
  }

  # disk {
  #   slot    = "scsi0"
  #   type    = "disk"
  #   storage = each.value.storage.location
  #   size    = each.value.storage.size
  #   format  = "raw"
  #   cache   = "none"
  #   discard = true
  # }

  disk {
    slot    = "scsi0"
    type    = "disk"
    size    = each.value.storage.size
    storage = each.value.storage.location
    format  = "raw"
  }
  network {
    id = 0
    model    = "virtio"
    bridge   = each.value.network.service.bridge
    tag = each.value.network.service.vlan
  }
  ipconfig0  = "ip=${each.value.network.service.ip_address},gw=${each.value.network.service.gateway}"
  # network {
  #   id = 1
  #   model    = "virtio" #"e1000"
  #   bridge   = each.value.network.mngt.bridge
  #   tag = each.value.network.mngt.vlan
  # }
  # ipconfig1  = "ip=${each.value.network.mngt.ip_address},gw=${each.value.network.mngt.gateway}"
  
  serial {
    id     = 0
    type   = "socket"
  }
  vga {
    type = "serial0"
  }

  ciuser     = "mgnt"
  cipassword = "password"
  sshkeys = each.value.ssh_pubkey
  # cicustom = "user=local:snippets/user-data.yaml"

  agent = 1
  onboot = true


  lifecycle {
    ignore_changes = [ 
      bootdisk,
     ]
  }
}
