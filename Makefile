.PHONY: build deploy clean init plan apply destroy

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

clean:
	rm -f lambda/bootstrap
	rm -f terraform/lambda_function.zip
	cd terraform && rm -rf .terraform .terraform.lock.hcl