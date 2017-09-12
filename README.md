# AWS AMI with Encrypted Root Device

AWS does not permit you to create an Instance with the option to have the root device encrypted.

In order to achieve this goal to have the root device encrypted, one must from an original
AMI create a new AMI with encrypted devices, see [AMIs with Encrypted Snapshots|http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIEncryption.html].


This repo aims to achieve creating an AMI with root device encrypted using Terraform.


# Requirements

* AWS CLI
* Terraform
* Pair of SSH keys (not mandatory, existent key on AWS can be used)
* Original AMI (CentOS 7 was used, but other linux images can be used)

# Method

1. Create KMS Key using [aws_kms_key](https://www.terraform.io/docs/providers/aws/r/kms_key.html)
2. Select original AMI to be encrypted. CentOS AMI images [here](https://wiki.centos.org/Cloud/AWS)
3. Launch an EC2 instance
4. Create AMI from instance using [aws_ami_from_instance](https://www.terraform.io/docs/providers/aws/r/ami_from_instance.html)
5. Copy AMI encrypting using the KMS key created using [aws_ami_copy](https://www.terraform.io/docs/providers/aws/r/ami_copy.html)