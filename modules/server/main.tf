#creating sec group in vpc to attcavh it in ec2
resource "aws_security_group" "sec-grp" {
    name = "${var.env}-sec-grp"
    vpc_id = var.vpc_id   #aws_vpc.vpc.id
    ingress {
    from_port   = 22
    to_port     = 22
    cidr_blocks = [var.my-ip]
    protocol    = "tcp"
    }
    ingress {
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    }
    tags = {
        Name = "${var.env}-sec-grp"
    } 
    egress{
        from_port=0
        to_port=0
        cidr_blocks=["0.0.0.0/0"] #anyone from ec2 can access the outside the nw (allow all outpound traffic)
        protocol= "-1"
        prefix_list_ids=[]   #anyone from ec2 can access any endpoint
    }
}
# we need to fetch the ami of ec2 using data to be compatible with any region
data "aws_ami" "amazon-machine-image"{
    most_recent= true #to fetch the newest image 
    owners=["amazon"]
    filter {
        name="name"
        values=["amzn2-ami-*-x86_64-gp2"]
    }
    filter {
        name="virtualization-type"
        values=["hvm"]
    }

}


#creating th ec2
resource "aws_instance" "ec2" {
    ami=data.aws_ami.amazon-machine-image.id
    instance_type=var.instance_type   #"t2.micro"
    subnet_id=var.subnet_id  #module.subnet-igw-rt.subnet-details.id #aws_subnet.subnet.id
    vpc_security_group_ids=[aws_security_group.sec-grp.id]
    availability_zone=var.avail_zone   #"us-west-2a"
    associate_public_ip_address= true
    key_name=aws_key_pair.ssh-key.key_name        #"tfkey"
    user_data = file("userdata.sh")                    # <<-EOF  EOF
    tags={
        Name="${var.env}-myserver2"   
    }

}
#generate key manual
resource "aws_key_pair" "ssh-key" {
    key_name="tfkey2"
    public_key=file("/home/nour/.ssh/id_rsa.pub")
}
