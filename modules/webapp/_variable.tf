variable "app-name" {
    type = string
    default = "webapp-stone"
}
variable "repo-name" {
    type = string
    default =  "webapp-repo"
}

variable "user-name" {
    type = string
    default =  "webapp-user"
}

variable "vpc_config" {
    type = map(string)
    default =  { instance_tenancy : "default", cidr: "172.31.0.0/16", number_of_subnets = "2", number_of_sg = "1"}
}

variable "subnet_cidrs" {
    description = "length should be greater than equal to number_of_subnets in vpc_config"
    type = list(string)
    default = ["172.31.0.0/17","172.31.128.0/17"]
}

variable "subnet_availability_zone_ids" {
    description = "length greater than equal to number_of_subnets in vpc_config"
    type = list(string)
    default = ["use2-az3","use2-az2"]
}

variable "key_path" {
    type = string
    default = "eks_key.pem"
}

variable "key_pair_name" {
    type = string
    default = "stone-key-pair"
}