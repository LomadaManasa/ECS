resource "tls_private_key" "rsa" {
 algorithm = "RSA"
 rsa_bits = 4096 
}
resource "aws_key_pair" "Ec2key_pair" {
    key_name = "ec2_key_pair"
    public_key = tls_private_key.rsa.public_key_openssh
}
resource "local_file" "terraform_publicEc2keypair_save" {
  content = tls_private_key.rsa.private_key_pem
  filename = "ec2_private_key.pem"
}
resource "aws_launch_template" "ec2" {
    tags={
        Name="ec2"
    }
    image_id = "ami-053b0d53c279acc90"
    instance_type = "t2.micro"
    key_name = "ec2_key_pair"
    user_data     = base64encode(<<-USERDATA
                    #!/bin/bash
                    yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
                    systemctl enable amazon-ssm-agent
                    systemctl start amazon-ssm-agent
                  USERDATA
  )
  iam_instance_profile{
    name = aws_iam_instance_profile.Instance_profile.name
  }
}

