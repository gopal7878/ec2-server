variable "name" {
  description = "Name of bastion"
  type        = string
  default     = ""
}
variable "public_ip" {
  description = "Name of bastion"
  type        = bool
  default     = true
}

variable "tag" {
  description = "Additional tags"
  type        = string
  default     = ""
}
variable "subnet" {
  description = "Zones to launch our instances into"
  type        = string
  default     = ""
}
variable "volume_size" {
  description = "volume size"
  type        = number
}

variable "volume_type" {
  description = "volume type"
  type        = string
  default     = "gp2"
}

variable "ami_id" {
  description = "Name of Launch configuration"
  type        = string
  default     = ""
}
variable "key_name" {
  description = "Key name of Launch configuration"
  type        = string
  default     = ""
}
variable "instance_type" {
  description = "Name of Launch configuration"
  type        = string
  default     = ""
}
variable "security_groups" {
  description = "Name of Launch configuration"
  type        = list(string)
  default     = []
}

variable "secretsmanager_secret" {
  description = "Name of the secrets manager to store key"
  type        = string
  default     = ""
}
