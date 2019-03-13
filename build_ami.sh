source .env

packer build packer_file.json

terraform init

terraform apply -auto-approve

terraform output instance_ips