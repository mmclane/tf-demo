rm .terraform.lock.hcl
rm -Rf .terraform 
rm terraform.tfstate
rm terraform.tfstate.backup

mv ./module/data.tf .
mv ./module/outputs.tf .
mv ./module/variables.tf .
mv ./module/main.tf .
mv ./module/role.tf ./advanced
mv ./module/securitygroup.tf ./advanced
mv terraform.tfvars.backup terraform.tfvars
mv module.tf ./advanced
