rm .terraform.lock.hcl
rm -Rf .terraform 
rm terraform.tfstate
rm terraform.tfstate.backup

mv data.tf ./module 
mv outputs.tf ./module 
mv variables.tf ./module
mv main.tf ./module
mv role.tf ./module
mv securitygroup.tf ./module
mv terraform.tfvars terraform.tfvars.backup
mv ./advanced/module.tf .
