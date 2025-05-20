#setting up VPC
resource "aws_vpc" "tf-vpc" {
  cidr_block = "15.0.0.0/16"

  tags = {
    Name = "tf-vpc"
  }

}
#setting up private subnets 
resource "aws_subnet" "tf-subnet-privateA" {
  vpc_id                  = aws_vpc.tf-vpc.id
  cidr_block              = "15.0.1.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"
  tags = {
    Name = "tf-subnet-privateA"
  }
}


resource "aws_subnet" "tf-subnet-privateB" {
  vpc_id                  = aws_vpc.tf-vpc.id
  cidr_block              = "15.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"
  tags = {
    Name = "tf-subnet-privateB"
  }

}


#setting up public subnets
resource "aws_subnet" "tf-subnet-publicA" {
  vpc_id                  = aws_vpc.tf-vpc.id
  cidr_block              = "15.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "tf-subnet-publicA"
  }
}

resource "aws_subnet" "tf-subnet-publicB" {
  vpc_id                  = aws_vpc.tf-vpc.id
  cidr_block              = "15.0.4.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "tf-subnet-publicB"
  }
}

#setting up internet gateway
resource "aws_internet_gateway" "tf-igw" {
  vpc_id = aws_vpc.tf-vpc.id

  tags = {
    Name = "tf-igw"
  }
}

#setting up Elastic IP for NAT Gateway
resource "aws_eip" "tf-eip" {
  depends_on = [aws_internet_gateway.tf-igw]
  domain     = "vpc"
  tags = {
    Name = "tf-eip"
  }
}
#setting up NAT Gateway
resource "aws_nat_gateway" "tf-nat-gateway" {


  allocation_id = aws_eip.tf-eip.id
  subnet_id     = aws_subnet.tf-subnet-publicA.id

  tags = {
    Name = "tf-nat-gateway"
  }

}

#setting up route public table
resource "aws_route_table" "tf-pub-rt" {
  vpc_id = aws_vpc.tf-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf-igw.id
  }
  tags = {
    Name = "tf-pub-rt"
  }
}

#setting up route table for private subnet
resource "aws_route_table" "tf-prv-rt" {
  vpc_id = aws_vpc.tf-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tf-nat-gateway.id
  }
  tags = {
    Name = "tf-prv-rt"
  }
}

#setting up route table association
resource "aws_route_table_association" "tf-pub-rt-associationA" {
  subnet_id      = aws_subnet.tf-subnet-publicA.id
  route_table_id = aws_route_table.tf-pub-rt.id
}

resource "aws_route_table_association" "tf-pub-rt-associationB" {
  subnet_id      = aws_subnet.tf-subnet-publicB.id
  route_table_id = aws_route_table.tf-pub-rt.id
}

#setting up route table association for private subnetA
resource "aws_route_table_association" "tf-prv-rt-associationA" {
  subnet_id      = aws_subnet.tf-subnet-privateA.id
  route_table_id = aws_route_table.tf-prv-rt.id
}

#setting up route table association for private subnetB
resource "aws_route_table_association" "tf-prv-rt-associationB" {
  subnet_id      = aws_subnet.tf-subnet-privateB.id
  route_table_id = aws_route_table.tf-prv-rt.id
}

#bastion host security group
resource "aws_security_group" "bastion-sg" {
  name   = "bastion-sg"
  vpc_id = aws_vpc.tf-vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # Replace with your IP address ,using this as an example
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "bastion-sg"
  }
}

#setting up security group for load balancer
resource "aws_security_group" "alb-sg" {
  name   = "alb-sg"
  vpc_id = aws_vpc.tf-vpc.id
  ingress {
    description = "allow http from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#setting up security group for EC2 instance
resource "aws_security_group" "tf-sg" {
  name        = "tf-sg"
  description = "Allow HTTP from ALB and SSH from Bastion"
  vpc_id      = aws_vpc.tf-vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    #Allows SSH traffic from the bastion host security group
    security_groups = [aws_security_group.bastion-sg.id]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    #Allows HTTP traffic from all IPs
    security_groups = [aws_security_group.alb-sg.id]
  }
  #egress rule to allow all outbound traffic

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "tf-sg"
  }
}

#setting up key pair
resource "aws_key_pair" "web-key" {
  key_name   = "web-key"
  public_key = file("C:/Users/eyas2/OneDrive/Documents/Portfolio/terraform/web-key.pub")
}

#setting up bastion host instance
resource "aws_instance" "bastion-host" {
  ami                         = "ami-085386e29e44dacd7" # Amazon Linux 2 AMI
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.web-key.key_name
  subnet_id                   = aws_subnet.tf-subnet-publicA.id
  vpc_security_group_ids      = [aws_security_group.bastion-sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "bastion-host"
  }
}

#setting up EC2 instance with a simple web server
resource "aws_instance" "tf_instance" {
  ami                    = "ami-085386e29e44dacd7" # Amazon Linux 2 AMI
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.web-key.key_name
  subnet_id              = aws_subnet.tf-subnet-privateA.id
  vpc_security_group_ids = [aws_security_group.tf-sg.id]
  user_data              = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Terraform 1!</h1>" > /var/www/html/index.html
              EOF
  tags = {
    Name = "tf-instance"
  }
}

resource "aws_instance" "tf_instance2" {
  ami                    = "ami-085386e29e44dacd7" # Amazon Linux 2 AMI
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.web-key.key_name
  subnet_id              = aws_subnet.tf-subnet-privateB.id
  vpc_security_group_ids = [aws_security_group.tf-sg.id]
  user_data              = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Terraform 2!</h1>" > /var/www/html/index.html
              EOF
  tags = {
    Name = "tf-instance2"
  }
}


#setting up load balancer
resource "aws_lb" "tf_lb" {
  name               = "tf-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.tf-subnet-publicA.id, aws_subnet.tf-subnet-publicB.id]
  depends_on         = [aws_internet_gateway.tf-igw]
}

#setting up lb target group
resource "aws_lb_target_group" "tf-target-group" {
  name     = "tf-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.tf-vpc.id
}

#setting up target group attachment
resource "aws_lb_target_group_attachment" "web1" {
  target_group_arn = aws_lb_target_group.tf-target-group.arn
  target_id        = aws_instance.tf_instance.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web2" {
  target_group_arn = aws_lb_target_group.tf-target-group.arn
  target_id        = aws_instance.tf_instance2.id
  port             = 80
}


#setting up listener for load balancer
resource "aws_lb_listener" "tf-listener" {
  load_balancer_arn = aws_lb.tf_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf-target-group.arn
  }
}