terraform {
  backend "s3" {
      bucket = "terraform-state-gsn8lq9q2tgppvyrm6a57o057uw9z10c6rcod4wpo748l"
      key = "terraform/state"
      region = "us-west-2"
  }
}

resource "aws_instance" "Instance-icpl" {
      ami = data.aws_ami.ubuntu_latest.id
      instance_type = "t2.micro"
      tags = {
        Name = "Instance-icpl"
      }
      lifecycle {
        ignore_changes = [ami]
      }
      subnet_id = aws_subnet.devxp_vpc_subnet_public0.id
      associate_public_ip_address = true
      vpc_security_group_ids = [aws_security_group.devxp_security_group.id]
      iam_instance_profile = aws_iam_instance_profile.Instance-icpl_iam_role_instance_profile.name
      key_name = "Instance-icpl_keyPair"
}

resource "aws_eip" "Instance-icpl_eip" {
      vpc = true
      instance = aws_instance.Instance-icpl.id
}

resource "tls_private_key" "Instance-icpl_keyPair_tls_key" {
      algorithm = "RSA"
      rsa_bits = 4096
}

resource "aws_key_pair" "Instance-icpl_keyPair" {
      public_key = tls_private_key.Instance-icpl_keyPair_tls_key.public_key_openssh
      key_name = "Instance-icpl_keyPair"
}

resource "local_sensitive_file" "Instance-icpl_keyPair_pem_file" {
      filename = pathexpand("~/.ssh/Instance-icpl_keyPair.pem")
      file_permission = "600"
      directory_permission = "700"
      content = tls_private_key.Instance-icpl_keyPair_tls_key.private_key_pem
}

resource "aws_iam_user" "Instance-icpl_iam" {
      name = "Instance-icpl_iam"
}

resource "aws_iam_user_policy_attachment" "Instance-icpl_iam_policy_attachment0" {
      user = aws_iam_user.Instance-icpl_iam.name
      policy_arn = aws_iam_policy.Instance-icpl_iam_policy0.arn
}

resource "aws_iam_policy" "Instance-icpl_iam_policy0" {
      name = "Instance-icpl_iam_policy0"
      path = "/"
      policy = data.aws_iam_policy_document.Instance-icpl_iam_policy_document.json
}

resource "aws_iam_access_key" "Instance-icpl_iam_access_key" {
      user = aws_iam_user.Instance-icpl_iam.name
}

resource "aws_iam_instance_profile" "Instance-icpl_iam_role_instance_profile" {
      name = "Instance-icpl_iam_role_instance_profile"
      role = aws_iam_role.Instance-icpl_iam_role.name
}

resource "aws_iam_role" "Instance-icpl_iam_role" {
      name = "Instance-icpl_iam_role"
      assume_role_policy = "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": \"sts:AssumeRole\",\n      \"Principal\": {\n        \"Service\": \"ec2.amazonaws.com\"\n      },\n      \"Effect\": \"Allow\",\n      \"Sid\": \"\"\n    }\n  ]\n}"
}

resource "aws_subnet" "devxp_vpc_subnet_public0" {
      vpc_id = aws_vpc.devxp_vpc.id
      cidr_block = "10.0.0.0/25"
      map_public_ip_on_launch = true
      availability_zone = "us-west-2a"
}

resource "aws_subnet" "devxp_vpc_subnet_public1" {
      vpc_id = aws_vpc.devxp_vpc.id
      cidr_block = "10.0.128.0/25"
      map_public_ip_on_launch = true
      availability_zone = "us-west-2b"
}

resource "aws_internet_gateway" "devxp_vpc_internetgateway" {
      vpc_id = aws_vpc.devxp_vpc.id
}

resource "aws_route_table" "devxp_vpc_routetable_pub" {
      route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.devxp_vpc_internetgateway.id
      }
      vpc_id = aws_vpc.devxp_vpc.id
}

resource "aws_route" "devxp_vpc_internet_route" {
      route_table_id = aws_route_table.devxp_vpc_routetable_pub.id
      destination_cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.devxp_vpc_internetgateway.id
}

resource "aws_route_table_association" "devxp_vpc_subnet_public_assoc" {
      subnet_id = aws_subnet.devxp_vpc_subnet_public0.id
      route_table_id = aws_route_table.devxp_vpc_routetable_pub.id
}

resource "aws_vpc" "devxp_vpc" {
      cidr_block = "10.0.0.0/16"
      enable_dns_support = true
      enable_dns_hostnames = true
}

resource "aws_security_group" "devxp_security_group" {
      vpc_id = aws_vpc.devxp_vpc.id
      name = "devxp_security_group"
      ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
      ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
      ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
      egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
      egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
}

data "aws_iam_policy_document" "Instance-icpl_iam_policy_document" {
      statement {
        actions = ["ec2:RunInstances", "ec2:AssociateIamInstanceProfile", "ec2:ReplaceIamInstanceProfileAssociation"]
        effect = "Allow"
        resources = ["arn:aws:ec2:::*"]
      }
      statement {
        actions = ["iam:PassRole"]
        effect = "Allow"
        resources = [aws_instance.Instance-icpl.arn]
      }
}

data "aws_ami" "ubuntu_latest" {
      most_recent = true
      owners = ["099720109477"]
      filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64*"]
      }
      filter {
        name = "virtualization-type"
        values = ["hvm"]
      }
}


output "Instance-icpl_eip-public-ip" {
    value = aws_eip.Instance-icpl_eip.public_ip
    sensitive = false
}

output "Instance-icpl_keyPair-private_key" {
    value = tls_private_key.Instance-icpl_keyPair_tls_key.private_key_pem
    sensitive = true
}

output "Instance-icpl-ssh_instructions" {
    value = "To access Instance-icpl, use: ssh -i ~/.ssh/Instance-icpl_keyPair.pem ubuntu@<OUTPUTTED_IP)>"
    sensitive = false
}

