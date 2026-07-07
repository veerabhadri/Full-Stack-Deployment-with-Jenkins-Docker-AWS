##############################################
# Latest Ubuntu 24.04 LTS AMI
##############################################

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

##############################################
# Jenkins EC2 Instance
##############################################

resource "aws_instance" "jenkins" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.jenkins_instance_type
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name
  key_name             = var.key_name
  user_data            = file("${path.module}/user-data/jenkins.sh")

  root_block_device {
    volume_size = var.jenkins_volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-jenkins"
  })
}