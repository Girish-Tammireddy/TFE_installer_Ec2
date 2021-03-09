variable "ami-id" {
  type    = string
  default = "ami-0915bcb5fa77e4892"
}
variable "region" {
  type    = string
  default = "us-east-1"
}
variable "vpc_id" {
  type = string
}
variable "subnet-id" {
  type = string
}
variable "vpc_cidr" {
  type = list(string)
}
variable "root_volume_size" {
  type        = string
  description = "The size of the volume in gigabytes for the root block device."
  default = "50"
}


