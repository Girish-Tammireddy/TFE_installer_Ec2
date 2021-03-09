provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_instance" "tfe_installer" {
  ami           = var.ami-id
  instance_type = "t2.xlarge"
  subnet_id     = var.subnet-id
  root_block_device {
   volume_size = var.root_volume_size
  }
  vpc_security_group_ids = [
     aws_security_group.tfe_ec2_allow.id
  ]
  iam_instance_profile = "${aws_iam_instance_profile.tfe_profile.name}"
  tags = {
    Team = "automation",
    Name = "TFE_Installer"
  }
}


############################security-groups###############################################################

resource "aws_security_group" "tfe_ec2_allow" {
  name   = "tfe_ec2_allow"
  vpc_id = var.vpc_id
}


resource "aws_security_group_rule" "tfe_ec2_allow_all_vpc" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = var.vpc_cidr
  description = "Allow all internal traffic"

  security_group_id = aws_security_group.tfe_ec2_allow.id
}

#####################################Instance-profile##########################################################

resource "aws_iam_instance_profile" "tfe_profile" {
  name = "tfe_profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "tfe_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

##########IAM-Policy#####################################################################################################

resource "aws_iam_role_policy" "tfe_policy" {
  name = "tfe_policy"
  role = "${aws_iam_role.role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*",
        "ssm:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


