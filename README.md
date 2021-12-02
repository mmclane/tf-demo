# tf-demo
Terraform configs used for demo during a meetup.

The slides for this talk can be found here:
https://docs.google.com/presentation/d/1jWhY8pE-rIvf0eJmgmnZtpGWecTZljTZ_V04aiUBLZA/edit?usp=sharing

## Tips

To reset things, move setup.sh from the bin directory to the root and run it.  

To move everything into a module directory to demo how modules work, move zmodulesetup.sh to the root of the directory and run it.  Make sure to run terraform destroy first so that you don't orphan cloud resources!
