terraform{
    backend "s3" {
        bucket = "my-bucket-772992660467"
        key="myapp-state/terraform.tfstate"
        region="us-west-2"

    }
    
}

provider "aws" {
    region="us-west-2"
    access_key=""
    secret_key=""
}


resource "aws_vpc" "vpc" {
    cidr_block=var.vpc_cidr_block  #"10.0.0.0/16"
    tags={

      Name="${var.env}-vpc"
    }
}

module "subnet-igw-rt" {
    source="./modules/network"
    vpc_id=aws_vpc.vpc.id
    subnet_cidr_block=var.subnet_cidr_block
    env= var.env
    avail_zone=var.avail_zone
}

module "ec2-secgrp-key" {
    source="./modules/server"
    vpc_id=aws_vpc.vpc.id
    instance_type=var.instance_type
    my-ip=var.my-ip
    env= var.env
    avail_zone=var.avail_zone
    subnet_id=module.subnet-igw-rt.subnet-details.id
}



    # connection {   #making a connection between ec2 and the provider  using ssh
    #     type="ssh"
    #     user="ec2-user"
    #     host=self.public_ip
    #     private_key=file(var.private_key_ssh)
    # }
    # provisioner "remote-exec"{   #this is service to mske config mngmnt on ec2 instead of userdata
    #     # inline= [
    #     #     "mkdir test1" ,
    #     #     "touch test2"
    #     # ]
    #     script=file("userdata.sh") 
    # }
    # provisioner "file" {  #this is for copying a file or script to the newly 

    # }




