
output "vpc_id" {
    description = "The vpc id"
    value = aws_vpc.AWS-3-tier-vpc.id
}

output "public-subnet-az-1a" {
    value = aws_subnet.public-subnet-az-1a.id
}

output "private-subnet-az-1a" {
    value = aws_subnet.private-subnet-az-1a.id
}

output "public-subnet-az-1b" {
    value = aws_subnet.public-subnet-az-1b.id
}

output "private-subnet-az-1b" {
    value = aws_subnet.private-subnet-az-1b.id
}