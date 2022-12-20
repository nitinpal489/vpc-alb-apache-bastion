#to call availability zones as output with their names like, 1a,1b,1c.....

output "zones" {
  value = data.aws_availability_zones.available.names

}

output "vpcid" {
  value = aws_vpc.vpc.id

}

#output "aws_internet_gateway.igw.arn" {
# value = aws_internet_gateway.igw.id

#}

output "countofaz" {
  value = data.aws_availability_zones.available.names

}