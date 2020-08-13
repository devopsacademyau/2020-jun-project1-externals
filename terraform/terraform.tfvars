# Copy this file to "terraform.tfvars" and adjust as needed.

your_home_network_cidr = "101.181.70.69/32" 

# provide the certificate from ACM 
alb_certificate_arn = "arn:aws:acm:ap-southeast-2:348248800869:certificate/0c6d4095-dd02-4717-bff1-b076303dd2cd"

dns_name = "wp"

# Provide your hosted zone id 
zone_id = "ZZ90LZK3RNF5D"