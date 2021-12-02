resource "aws_security_group" "sg" {
  name        = "${local.name}-sg"
  description = "Security Group for ${local.name} server"
  vpc_id      = data.aws_vpc.vpc.id
  tags        = local.tags
}

locals {
  ingress_rules = {
    ssh = {
      from_port   = 22
      to_port     = 22
      protocol    = "TCP"
      cidr_blocks = ["10.1.0.0/16"]
    },
    http = {
      from_port   = 80
      to_port     = 80
      protocol    = "TCP"
      cidr_blocks = ["10.1.0.0/16"]
    }
  }
}

resource "aws_security_group_rule" "rules" {
  for_each          = local.ingress_rules
  type              = "ingress"
  description       = "This SG rule allows inbound ${each.key} traffic"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "self" {
  type              = "ingress"
  description       = "This SG rule allows inbound traffic from the SG"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  description       = "This SG rule allows all outbound traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}


## New way to do it!!
locals {
  ingress_ports  = ["53", "9345", "6443", "8443"]
  internal_cidrs = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

resource "aws_security_group_rule" "ingress" {
  for_each          = toset(local.ingress_ports)
  type              = "ingress"
  from_port         = each.value
  to_port           = each.value
  protocol          = "TCP"
  cidr_blocks       = local.internal_cidrs
  security_group_id = aws_security_group.sg.id
}
