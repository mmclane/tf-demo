module "instances" {
    count = 10
    source = "./module"
    name_prefix          = "m3-demo${count.index}"
    server_instance_type = "t3.micro"
    vpc                  = "dn-main"
}

output "instances" {
    value = module.instances
}
