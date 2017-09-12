# AWS AMI with Encrypted Root Device

AWS does not permit you to create an Instance with the option to have the root device encrypted.

In order to achieve this goal to have the root device encrypted, one must from an original
AMI create a new AMI with encrypted devices, see [AMIs with Encrypted Snapshots|http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIEncryption.html].


This repo aims to achieve creating an AMI with root device encrypted using Terraform.
