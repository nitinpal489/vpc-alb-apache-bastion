#vpc 


# .aws/credentials and config(region-- it picks the region which is inside the defined folder).


#calling availabilty zones from public subnet out of many subnet.
data "aws_availability_zones" "available" {
  state = "available"
}

# calling vpc here

resource "aws_vpc" "vpc" {
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name      = "stage-vpc",
    terraform = "true"
  }
}

# calling igw here

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    name = "stage-igw"
  }
}

#create subnet
#public

resource "aws_subnet" "public" {
  count  = length(var.pub_cidr)
  vpc_id = aws_vpc.vpc.id
  #here, calling of pub_cidr file is present in which all the cidr of 
  #public subnet are already defined.
  # calling var.<variablename>, this shows that inside the vpc.tf we are calling variable.tf 
  cidr_block              = element(var.pub_cidr, count.index)
  map_public_ip_on_launch = "true"
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    # if within the "double codes" i need to call some loop then i should have ${ }.
    Name = "stage-public-${count.index + 1}-subnet"
  }
}

resource "aws_subnet" "private" {
  count      = length(var.private_cidr)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.private_cidr, count.index)
  #map_public_ip_on_launch = "false"
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "stage-private-${count.index + 1}-subnet"
  }
}

resource "aws_subnet" "data" {
  count      = length(var.data_cidr)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.data_cidr, count.index)
  #map_public_ip_on_launch = "false"
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "stage-data-${count.index + 1}-subnet"
  }
}

#nat-gw in pub subnet


resource "aws_eip" "eip" {
  vpc = true

  tags = {
    Name = "stage-eip"
  }

}

resource "aws_nat_gateway" "natgw" {
  depends_on = [
    aws_eip.eip
  ]
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "stage-natgw"
  }

}
