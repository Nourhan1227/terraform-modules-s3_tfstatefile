output "ec2-public-ip" {
    value=aws_instance.ec2.public_ip
}

output "aws_ami_id" {
    value=data.aws_ami.amazon-machine-image.id
}

