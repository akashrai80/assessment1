output "vpc_cidr" {
    value = module.vpc.default_vpc_cidr_block
}

output "vpc_id" {
    value = module.vpc.vpc_id
}