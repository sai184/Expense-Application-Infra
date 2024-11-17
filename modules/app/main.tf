resource "aws_security_group" "security-group" {
  name        = "${var.env}--${var.component}"
  description = "${var.env}--${var.component}"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    description = "HTTP"
    protocol         = "Tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 22
    to_port          = 22
    description = "SSH"
    protocol         = "Tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "Tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }
  tags={
    Name="${var.env}--${var.component}--sg"
    }
  }

resource "aws_iam_role" "role" {
  name = "${var.env}--${var.component}"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })


}



resource "aws_launch_template" "expense-template" {
  Name = "${var.env}--${var.component}"
  image_id = "ami-012967cc5a8c9f891"

  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t2.micro"
  #key_name = "nag"
  vpc_security_group_ids = [aws_security_group.security-group.id]
   iam_instance_profile {
    name = "test"
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.env}--${var.component}"
    }
  }

  user_data = base64encode(templatefile("${path.module}/userdata.sh"))
}
