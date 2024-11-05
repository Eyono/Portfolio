# Private Network Access via Windows Bastion Host

This project demonstrates a secure AWS VPC configuration with customized Security Groups and Network Access Control Lists (NACLs) to manage and control inbound and outbound traffic effectively.

## Overview

This project uses AWS services to create a secure network environment that includes:
- **VPC with isolated subnets (public and private)**
- **Security Groups** to control instance-level access
- **Network ACLs** to control subnet-level traffic
- **EC2 Instances** Created a bastion host to securely access resources within private subnets

## Objectives

- Implement the principle of least privilege for network access.
- Demonstrate a multi-tier architecture using Security Groups and NACLs.
- Secure private resources by isolating subnets and using a bastion host.

## Architecture Diagram
![image](https://github.com/user-attachments/assets/4ca2eb90-1ca8-4d78-b01f-39dbef1e12cd)


The architecture includes:
- **Public Subnet**: For the bastion host, allowing SSH access from a trusted IP.
- **Private Subnet**: For application servers, accessible only through the bastion host.
- **Security Groups**: Specific rules for each instance type to control instance-level access.
- **NACLs**: Rules for additional subnet-level security.

## Key Components

- **VPC**: Custom VPC with public and private subnets.
- **Bastion Host**: Allows secure RDP access to instances in the private subnet.
- **Security Groups**: Configured to control inbound and outbound traffic for each instance.
- **Network ACLs**: Additional layer of security applied at the subnet level.

## AWS Services Used

- **Amazon VPC** for network creation and subnet isolation.
- **Security Groups** for instance-level access control.
- **Network ACLs (NACLs)** for subnet-level access control.
- **EC2** for instances within the VPC.
- **IAM** for secure role-based access.

## Project Setup and Configuration

### Step 1: VPC and Subnet Creation

1. Create a new VPC with CIDR block `23.0.0.0/16`.
   ![image](https://github.com/user-attachments/assets/879ae932-d427-4731-b4d1-46ab391f59f8)

2. Add public and private subnets.
![image](https://github.com/user-attachments/assets/b1bc8a42-f9dd-4971-9821-061bdaaa907c)
3. Create a public route table with internet gatway and associating it with the public subnet.
![image](https://github.com/user-attachments/assets/7d665f64-4d08-4c91-8b42-0a6c77e96d5d)

### Step 2: Network ACL Configurations

- Public Subnet NACL: Allows SSH (port 22) from trusted IPs and all outbound traffic.
  ![image](https://github.com/user-attachments/assets/29ced898-eb52-495f-93bf-449df48d24a4)
- Private Subnet NACL: Allows only specific inbound traffic (e.g., HTTP/HTTPS if hosting a web app) and denies others.
 ![image](https://github.com/user-attachments/assets/8188b719-2add-4c2a-b6f6-460e576e4def)

### Step 3: Security Group Configurations

- **Bastion Security Group**: Allows inbound RDP access only from a specified IP.
- **Web App Security Group**: Allows traffic only from the bastion host.



### Step 4: Setting Up the Bastion Host

1. Deploy an EC2 instance in the public subnet to serve as a bastion host.
2. Attach the public subnet security group to the bastion host.
3. Configure the bastion host to allow SSH access only from your trusted IP.

## Code and Configuration Files

- See the `config/` folder for CloudFormation or Terraform scripts used to automate the setup.
- `code/`: Contains any scripts or CLI commands for setting up security groups, NACLs, and EC2 instances.

## Lessons Learned and Best Practices

- **Least Privilege Principle**: Ensuring minimal access by setting restrictive Security Group and NACL rules.
- **Subnet Isolation**: Using public and private subnets to isolate application layers.
- **Auditing Access**: Regularly monitoring network traffic and updating security rules as needed.

## Screenshots

Include screenshots of:
- AWS console showing the VPC setup.
- Security Group configurations.
- Network ACL configurations.

## How to Use This Repository

1. Clone the repository.
2. Follow the instructions in `docs/` to set up the environment.
3. Review `config/` for automated deployment scripts (Terraform/CloudFormation).

## Future Enhancements

- Implement automated alerts for any suspicious activity within the VPC.
- Integrate AWS Config to monitor changes to Security Groups and NACLs.

## Conclusion

This project showcases a secure VPC setup on AWS, with a focus on isolation and controlled access using Security Groups and NACLs. It serves as a foundation for more complex network architectures in cloud environments.

---

