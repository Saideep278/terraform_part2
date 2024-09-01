# vpc for rds

resource "aws_vpc" "db" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

data "aws_availability_zones" "available" {
  state = "available"
}

# output "azs" {
#   value = [data.aws_availability_zones.available]
# }

#db subnet group for rds instance
resource "aws_subnet" "db_subnet" {
  count = 2
  vpc_id = aws_vpc.db.id
  cidr_block = cidrsubnet(aws_vpc.db.cidr_block,8,count.index)
  #cidrsubnet(cidr_block,newbits,netnum)
  #newbits is the number additional bits needed to add for prefix
  #netnum is  like no. of subnets needed
  availability_zone = data.aws_availability_zones.available.names[count.index]

}

#sg for rds
resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.db.id
  ingress  {
    cidr_blocks = [aws_vpc.db.cidr_block]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  egress  {
    cidr_blocks = [aws_vpc.db.cidr_block]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
}