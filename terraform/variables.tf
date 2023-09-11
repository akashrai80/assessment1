variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
    type = string
    default = "ami-0767f77deb6f0e899"
}

variable "instance_type" {
    type = string
    default = "t2.small"
}