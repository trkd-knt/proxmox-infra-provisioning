variable "api_address" {
  description = "Proxmox API address"
  type        = string
}

variable "pools" {
  description = "Map of pools to create"
  type        = any
}

variable "instances" {
  description = "Map of instances to create"
  type        = any
}
