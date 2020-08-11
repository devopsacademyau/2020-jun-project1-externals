SHA=$(shell git rev-parse --short HEAD)
ECR_URL=$(shell aws ecr describe-repositories --region ap-southeast-2 --repository-names wordpress --query 'repositories[].repositoryUri' --output text)
ECR_LOGIN= $(shell aws ecr get-login-password |docker login --username AWS --password-stdin ${ECR_URL})
IMAGE_NAME="${ECR_URL}:${SHA}"

all : plan apply build publish deploy-wp

.PHONY: plan #Run Terraform Plan and output the plan
plan:
	cd terraform; terraform init ;terraform refresh;terraform plan -out project1_tf_plan

.PHONY: apply #Run Terraform apply and creates the network and ECR
apply:
	cd terraform; terraform apply project1_tf_plan;


.PHONY: build # Run Docker build for wordpress and tag using ECR 
build:
	@echo "@@@ Start Docker Build  for ${IMAGE_NAME} @@@"
	docker build -t  ${IMAGE_NAME} -f docker/Dockerfile.wordpress .

.PHONY: publish ## Push the docker image to ECR repo
publish:
	@echo ${ECR_LOGIN} 
	docker push  ${IMAGE_NAME}

.PHONY: deploy-wp #Update the task definition with the new container built on previous
deploy-wp: 
	@echo "@@@ Update ECS service with new image task definition @@@"
	cd terraform; terraform apply -target=module.ecs -var="image_tag=${SHA}" -auto-approve

.PHONY:destroy
destroy:
	cd terraform;terraform destroy -auto-approve

