. packer/.env

packer build packer/packer_file.json

sleep 5

cd terraform

terraform init

terraform apply -auto-approve

terraform output instance_ips