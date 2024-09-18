
resource "aws_subnet" "subnet" {
    vpc_id= var.vpc_id  #aws_vpc.vpc.id
    cidr_block=var.subnet_cidr_block  #"10.0.0.0/24"
    availability_zone=var.avail_zone   #"us-west-2a"

    tags={

      Name="${var.env}-subnet"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id= var.vpc_id     #aws_vpc.vpc.id
    tags={
       Name="${var.env}-igw"
    }

}

resource "aws_route_table" "route-table" {  
    vpc_id= var.vpc_id
    route{
        cidr_block="0.0.0.0/0" #anyone can enter this vpc through the igw using rt
        gateway_id=aws_internet_gateway.igw.id
    }
    tags={
        Name="${var.env}-rt"

    }

}

#to map the dev-subnet to the new route table
resource "aws_route_table_association" "subnet-rt" {  #the subnet is mapping to the rt and the rt is mapping to gw
    subnet_id=aws_subnet.subnet.id
    route_table_id=aws_route_table.route-table.id
}