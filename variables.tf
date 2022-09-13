variable "env" {
  default = "dev"
}
variable "instance_name" {
  description = "instance name"
}

variable "vpc" {
  description = "vpc name"
}
variable "subnet" {
  description = "subnet name"
}
variable "source_ranges" {
  type        = list(string)
  description = "The list of public subnets being created"
}
variable "project_id" {
  type        = string
  description = "The project ID to deploy to"
  default     = null
}

variable "region" {
  type        = string
  default     = "asia-southeast1"
  description = "The region to deploy to"
}
variable "machine_type" {
  type        = string
  default     = "f1-micro"
  description = "Machine type"
}
variable "machine_zone" {
  type        = string
  default     = null
  description = "Machine type"
}
variable "machine_image" {
  type        = string
  default     = "centos-cloud/centos-7"
  description = "Machine image"
}
variable "startup_script" {
  type        = string
  default     = null
  description = "Startup script"
}
variable "service_account_email" {
  type        = string
  default     = null
  description = "Service account email"
}
variable "metadata" {
  type = map(string)

  default = {
    project = "goquo"
  }
  description = "Instance metadata"
}
variable "instance_udp_ports" {
  type        = list(string)
  default     = []
  description = "The list of udp port need to be whilisted"
}
variable "instance_tcp_ports" {
  type        = list(string)
  default     = ["22"]
  description = "The list of tcp port need to be whilisted"
}
variable "static_ip" {
  type        = bool
  default     = false
  description = "Static ip for instance."
}