 module "webapp" {
   source = "../modules/webapp"
 }

 /*module "microservices" {
   source = "../modules/microservices"

   vpc_id     = module.webapp.webapp_vpc_id
   subnet_ids = module.webapp.subnet_ids
 }

output "alb" {
  value = module.microservices.load_balancer_hostname
}*/