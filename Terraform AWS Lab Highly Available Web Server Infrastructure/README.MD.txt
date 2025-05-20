Terraform AWS Lab: Highly Available Web Server Infrastructure

This project provisions a complete, highly available web infrastructure on AWS using Terraform. The setup includes public and private subnets across two availability zones, a NAT Gateway, bastion host, two private web servers behind a public-facing Application Load Balancer (ALB), and all necessary networking and security components.

🔧 Infrastructure Overview

VPC & Subnets

VPC: Custom VPC with CIDR block 15.0.0.0/16

Public Subnets:

tf-subnet-publicA (AZ: us-east-1a)

tf-subnet-publicB (AZ: us-east-1b)

Private Subnets:

tf-subnet-privateA (AZ: us-east-1a)

tf-subnet-privateB (AZ: us-east-1b)

Internet & NAT Gateway

Internet Gateway attached to the VPC for public subnet internet access

Elastic IP for NAT

NAT Gateway in tf-subnet-publicA allowing private subnet instances to reach the internet

Route Tables

Public Route Table: Routes 0.0.0.0/0 to the Internet Gateway

Private Route Table: Routes 0.0.0.0/0 to the NAT Gateway

Associations established for all subnets to their respective route tables

🛡 Security Groups

Bastion Host SG: Allows SSH from anywhere

ALB SG: Allows inbound HTTP (port 80) from the internet

EC2 Web Server SG:

Allows SSH from the bastion host

Allows HTTP from the ALB

Allows all outbound traffic

🧩 Compute Resources

Bastion Host

Amazon Linux 2 in public subnet A

Used to securely SSH into private EC2 instances

EC2 Web Servers

Two instances deployed in private subnets A & B

Run Apache web server with simple HTML content

Key Pair

web-key used to SSH into instances (public key provided locally)

🌐 Application Load Balancer (ALB)

Type: Application (Layer 7)

Accessibility: Public

Subnets: Deployed across public subnets A & B

Security Group: Allows inbound HTTP (port 80)

Target Group:

Includes both private EC2 instances

Health checks and routing managed through the listener

🧠 Concepts Practiced

Terraform Infrastructure as Code (IaC)

Multi-AZ VPC architecture

NAT and Internet Gateways

Application Load Balancer and Target Groups

Secure EC2 access with a Bastion Host

Role-based security group configuration

EC2 bootstrapping using user_data

🚀 Usage

Create a key pair locally and provide the path to your public key in the Terraform file

Run terraform init to initialize providers

Run terraform plan to preview the infrastructure

Run terraform apply to deploy it to AWS

📁 File Structure

.
├── main.tf         # All resources defined here
├── web-key.pub     # Public key used in key pair
└── README.md       # Project documentation

✅ Output

After deployment:

You can access the web application through the ALB DNS name (output shown after apply)

SSH into the bastion host and connect to private EC2s

Each web server displays a unique message (Hello from Terraform 1/2!)

