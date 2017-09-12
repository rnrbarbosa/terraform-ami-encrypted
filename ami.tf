#------------------------------------------------------------
# INput Variables
#------------------------------------------------------------
variable "ami" {
	default = "ami-7cbc6e13"
}
#------------------------------------------------------------
# VPC
#------------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block = "172.31.0.0/16"
  tags = {
    Name = "TMP VPC"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "172.31.1.0/24"
  map_public_ip_on_launch = true
  tags = {
  	Name =  "Temp Public Subnet"
  }
}


#------------------------------------------------------------
#  EC2 Template Instance
#------------------------------------------------------------
resource "aws_instance" "ec2" {
  ami                         = "${var.ami}"
  instance_type               = "t2.micro"
  key_name      			  = "${aws_key_pair.key.key_name}"
  subnet_id                   = "${aws_subnet.public.id}"
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 10
    delete_on_termination = true
  }

  tags {
    Name = "temp ec2 for ami creation"
  }
}

#------------------------------------------------------------
#  AMI Creation
#------------------------------------------------------------
resource "aws_kms_key" "key" {
	description = "KMS key to encrypt root disk"
	  tags {
		Name = "CentOS Root Disk Encryption Key"
	  }
}

resource "aws_kms_alias" "key" {
  name          = "alias/itergo/root_device"
  target_key_id = "${aws_kms_key.key.key_id}"
}


resource "aws_ami_from_instance" "ami" {
  name               = "centos7"
  source_instance_id = "${aws_instance.ec2.id}"
}

resource "aws_ami_copy" "ami" {
  name              = "centos7-rootdev-encrypted"
  description       = "A copy of ami-7cbc6e13 with root_device encrypted"
  source_ami_id     = "${aws_ami_from_instance.ami.id}"
  source_ami_region = "eu-central-1"
  encrypted 		= true
  kms_key_id		= "${aws_kms_key.key.arn}"

  tags {
    Name = "CentOS 7 root_device encrypted"
  }
  lifecycle {
	prevent_destroy = true	
  }
}
