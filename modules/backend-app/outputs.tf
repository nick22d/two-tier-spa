output "sg_for_alb" {
    value = aws_security_group.sg_for_alb.id
}

output "sg_for_ec2" {
    value = aws_security_group.sg_for_ec2.id
}