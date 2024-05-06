variable "vpc_cidrs" {
 type        = string
 description = "VPC CIDR values"
}

variable "name" {
 type        = string
 description = "VPC tag name"
}

variable "availability_zones" {
 type        = list(string)
 description = "Region Avility zones"
 default = [ "" ]
}

variable "private_subnets" {
 type        = list(string)
 description = "Private subnets"
}

variable "public_subnets" {
 type        = list(string)
 description = "Public subnets"
}

variable "tags" {
  type = map(string)
  default = {
    Terraform = "true"
    Environment = "dev"
  }
}
