variable "targets" {
  description = "List of targets to gather facts from"
  type        = map(object({ip = string}))
}
