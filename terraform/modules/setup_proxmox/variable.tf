variable "hosts" {
  description = "List of targets to gather facts from"
  type        = any
}

variable "proxmox_cfg" {
  description = "Proxmox cluster configuration"
  type = any
}

variable "output_path"{
  description = "Path to output the token"
  type        = string
}
