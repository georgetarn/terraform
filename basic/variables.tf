variable "profile" {
  default     = "xxx"
  description = "AWS local profile credentials"
}

variable "prefix" {
  default     = "yourname"
  description = "Cluster Prefix - All resources created by Terraform have this prefix prepended to them"
}

variable "count_ec2_instance_nodes" {
  default     = "0"
  description = "Number of ec2 nodes"
}

variable "region" {
  default     = "us-east-1"
  description = "AWS Region for deployment"
}

variable "ec2_instance_node_type" {
  default     = "t2.large"
  description = "AWS instance type for the ec2 nodes"
}

variable "availability_zones" {
  default     = "1"
  description = "Number of availability zones to use"
}
