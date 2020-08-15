2020-jun-project1-externals

## Wordpress VPC deploying with Terraform


1. Configure AWS CLI Access Credentials.
Terraform requires that AWS CLI has administrative access to your aws account. Download your access keys and follow the below steps:

```
aws configure
```

## Running the Application in Local Machine 

### Clone the Repo 
 Clone the github repo "https://github.com/devopsacademyau/2020-jun-project1-externals". 

### Update Config Values

Update values in below files corresponding to your accounts
### .env.example file (root directory)
Update Below values corresponding to your account
```
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
```
### backend.example.tfvars  (cd to terraform directory)
Create a new  S3 bucket or use existing S3 bucket name and update the below bucket value to  store terraform state.Key and region need not change
````
bucket = "bucket-name"
key    = "terraform.tfstate"
region = "ap-southeast-2" 
````
### terraform.example.tfvars  (cd to terraform directory)
Update S3 bucket name to store terraform state
Update your home public ip with /32 subnet mask
```
your_home_network_cidr = "x.x.x.x/32" 
````
Create SSL certificate in ap-southeast-2 region  and update the certifcate arn in below field
https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html

```
alb_certificate_arn = "arn:asssa"
```

Create Free Domain name using https://my.freenom.com/clientarea.php?action=domaindetails and give the domain name here.Please make sure to update the name server to AWS one
```
dns_name = "dnsname.tk"
```

Create a hosted zone with the domain created above and provide hosted zone id below
https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html
```
zone_id = "******"
````

Once the above values are updated run below make command from root project directory to copy these files
```
make localsetup 
```

Once the local config command is completed below make commands can be used to bring up the applications


## Makefile commands

Run below commands in the root directory to create aws resource and push docker images.

Below command will create a docker with a short commit tag and push to ECR

### Create AWS infra and docker

Please make sure  make localsetup is ran with correct values before running this command

```

make all
```

Run below command to destroy using terraform

```
make destroy
```

This will run Terraform destroy

Terraform destroy. Infrastructure managed by Terraform will be destroyed [terraform destory]


### Below make  steps are optional .make all will run all the required commands internally

### make plan
```
make plan
```

This will run below terraform commands

1. Terraform Initialise. This command is used to initialize a working directory containing Terraform configuration files.This is the first command to start with.  Init will create a hidden directory ".terraform" and download plugins as needed by the configuration [terraform init]

2. Terraform plan. Run this command to view te execution plan for your configuration. The execution plan specifies what actions Terraform will take to achieve the desired state defined in the configuration, and the order in which the actions occur.[terraform plan]


### make apply
```
make apply
```

Terraform apply. In the same directory as the main.tf file you created, run the terraform apply command to apply your configuration.After confirming your execution plan as yes, Terraform will create your resource group [terraform apply]


### make build
```
make build
```

This will build docker image for worpress and tag with ECR repo


### make publish

This will  push new word press images to ECR repostiry
```
make publish
```
Below make command is used to deploy latest docker image in ECR
# make deploy-wp
```
make deploy-wp
```

Solution Diagram :

![Wordpress solution diagram02](https://user-images.githubusercontent.com/38310128/88801373-f5876680-d1ec-11ea-8fd1-37cac55a5c9e.jpg)


### Docker commands to upload image to ECR
```
Execute terraform apply before running the below commands

Run below commands to push new word press images to ECR repostiry

ECR_URL=$(aws ecr describe-repositories --region ap-southeast-2 --repository-names wordpress --query 'repositories[].repositoryUri' --output text)

# For aws-cli 1.9
aws ecr get-login --no-include-email --region ap-southeast-2 \
    | docker login --username AWS --password-stdin $ECR_URL

# This works with aws-cli 2.0 -- change region as needed
aws ecr get-login-password --region ap-southeast-2 \
    | docker login --username AWS --password-stdin $ECR_URL

docker tag wordpress:latest "$ECR_URL":latest
docker push "$ECR_URL":latest

Trigger ECS update service to use new image by ECS task
aws ecs update-service --cluster 2020-jun-project1-externals --service 2020-jun-project1-externals --force-new-deployment
````


Terraform/Application CICD: 

NOTE : Below changes are needed in github secrets to make CI/CD works.
 
 As a prerequisite perform the below steps before PR/Commit requests.

1. Create/Update following secrets in the  GITHUB Settings -> secrets.
```
AWS_ACCESS_KEY_ID 
AWS_SECRET_ACCESS_KEY 
DNS_NAME
HOME_NETWORK_IP_CIDR
HOSTED_ZONE_ID
S3_BUCKET_NAME
SSL_CERTIFCATE_ARN
```