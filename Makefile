SHA=$(shell git rev-parse --short HEAD)
ECR_URL=$(shell aws ecr describe-repositories --region ap-southeast-2 --repository-names wordpress --query 'repositories[].repositoryUri' --output text)
ECR_LOGIN= $(shell aws ecr get-login-password --region ap-southeast-2 |docker login --username AWS --password-stdin ${ECR_URL})
ECR_TAG="${ECR_URL}:${SHA}"
COMPOSE_RUN_SHELL= docker-compose run --rm shell
COMPOSE_WORDPRESS= docker-compose build --force-rm wordpress

all : plan apply build publish deploy-wp

.PHONY: localsetup
localsetup:
	cp -f .env.example .env
	cd terraform;cp -f backend.example.tfvars backend.tfvars;cp -f  terraform.example.tfvars terraform.tfvars

.PHONY: plan #Execute Terraform Plan and output the plan
plan:
	#$(COMPOSE_RUN_SHELL) make _plan s3_bucket=$(s3_bucket)
	$(COMPOSE_RUN_SHELL) make _plan

.PHONY: _plan #bash command to run the plan
_plan:
	cd terraform;terraform init -backend-config=backend.tfvars;terraform refresh;terraform plan -out project1_tf_plan
.PHONY: apply #Execute the Terraform Apply to creates the network and ECR
apply:
	$(COMPOSE_RUN_SHELL) make _apply

PHONY: _apply #bash command to run the plan
_apply:
	cd terraform; terraform apply project1_tf_plan;

.PHONY: build # Run Docker build for wordpress and tag using ECR 
build: 
	@echo "@@@ Start Docker Build  for ${ECR_TAG} @@@"
	ECR_TAG=${ECR_TAG}  $(COMPOSE_WORDPRESS)


.PHONY: ci-build # Run Docker build during CI as ECR repo wont be available during this time
ci-build: 
	$(COMPOSE_WORDPRESS)

.PHONY: publish ## Push the docker image to ECR repo
publish:
	@echo ${ECR_LOGIN} 
	docker push  ${ECR_TAG}

.PHONY: deploy-wp #Update the task definition with the new container built on previous
deploy-wp: 
	$(COMPOSE_RUN_SHELL) make _deploy-wp

.PHONY: _deploy-wp #Update the task definition with the new container built on previous
_deploy-wp: 
	cd terraform;terraform init; terraform apply -target=module.ecs -var="image_tag=${SHA}" -auto-approve

.PHONY: destroy #Deletes the AWS infra created by terraform
destroy:
	$(COMPOSE_RUN_SHELL) make _destroy

.PHONY:_destroy
_destroy:
	cd terraform;terraform destroy -auto-approve