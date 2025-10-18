.PHONY: build deploy clean init plan apply destroy ansible-deploy ansible-destroy ansible-update ansible-validate

# Traditional Terraform-only commands (kept for compatibility)
build:
	cd lambda && GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -tags lambda.norpc -o bootstrap main.go

init:
	cd terraform && terraform init

plan:
	cd terraform && terraform plan

apply:
	cd terraform && terraform apply

deploy: build apply

destroy:
	cd terraform && terraform destroy

# Ansible-integrated commands (recommended)
ansible-deploy-dev:
	ansible-playbook -i inventory/hosts.yml playbooks/deploy.yml --limit dev

ansible-deploy-staging:
	ansible-playbook -i inventory/hosts.yml playbooks/deploy.yml --limit staging

ansible-deploy-prod:
	ansible-playbook -i inventory/hosts.yml playbooks/deploy.yml --limit prod

ansible-destroy-dev:
	ansible-playbook -i inventory/hosts.yml playbooks/destroy.yml --limit dev

ansible-destroy-staging:
	ansible-playbook -i inventory/hosts.yml playbooks/destroy.yml --limit staging

ansible-destroy-prod:
	ansible-playbook -i inventory/hosts.yml playbooks/destroy.yml --limit prod

ansible-update-dev:
	ansible-playbook -i inventory/hosts.yml playbooks/update.yml --limit dev

ansible-update-staging:
	ansible-playbook -i inventory/hosts.yml playbooks/update.yml --limit staging

ansible-update-prod:
	ansible-playbook -i inventory/hosts.yml playbooks/update.yml --limit prod

ansible-validate:
	ansible-playbook -i inventory/hosts.yml playbooks/validate.yml

# Convenience aliases
deploy-dev: ansible-deploy-dev
deploy-staging: ansible-deploy-staging
deploy-prod: ansible-deploy-prod
destroy-dev: ansible-destroy-dev
destroy-staging: ansible-destroy-staging
destroy-prod: ansible-destroy-prod
update-dev: ansible-update-dev
update-staging: ansible-update-staging
update-prod: ansible-update-prod
validate: ansible-validate

clean:
	rm -f lambda/bootstrap
	rm -f terraform/lambda_function.zip
	cd terraform && rm -rf .terraform .terraform.lock.hcl
	rm -rf backups/