# Copy this file to "terraform.tfvars" and adjust as needed.

your_home_network_cidr = "x.x.x.x/32"

# provide the certificate from ACM 
alb_certificate_arn = "arn:aws:acm:ap-southeast-2:xxxx:certificate/xxxx"

dns_name = "wp"

# Provide your hosted zone id 
zone_id = "xxxx"