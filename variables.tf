### Manditory
variable "name_prefix" {}
variable "server_instance_type" {}
variable "vpc" {}

### Optional
variable "ami_id" {
  default     = ""
  description = "Optional AMI.  Otherwise it will look up latest Ubuntu AMI"
  type        = string
}

variable "ebs_vol_size" {
  default     = 50
  description = "For launch template"
  type        = number
}
