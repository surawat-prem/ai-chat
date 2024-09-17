data "aws_ami" "noble" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_network_interface" "noble" {
  subnet_id = var.aws_ec2_net_subnet_id
  private_ips = var.aws_ec2_net_private_ips
  tags = var.aws_ec2_net_tags
}

resource "aws_network_interface_sg_attachment" "noble" {
  security_group_id = aws_security_group.noble.id
  network_interface_id = aws_network_interface.noble.id
}

resource "aws_security_group" "noble" {
  name = "noble_vm_security_group"
  vpc_id = var.aws_ec2_net_vpc_id
  tags = var.aws_ec2_security_group_tags
}

resource "aws_vpc_security_group_ingress_rule" "noble-ingress-rule" {
  for_each = var.aws_vpc_sg_ingress_rules
  security_group_id = aws_security_group.noble.id
  cidr_ipv4 = each.value["cidr_ipv4"]
  from_port = each.value["from_port"]
  ip_protocol = each.value["ip_protocol"]
  to_port = each.value["to_port"]
  
}

resource "aws_vpc_security_group_egress_rule" "noble-egress-rule" {
  for_each = var.aws_vpc_sg_egress_rules
  security_group_id = aws_security_group.noble.id
  cidr_ipv4 = each.value["cidr_ipv4"]
  from_port = each.value["from_port"]
  ip_protocol = each.value["ip_protocol"]
  to_port = each.value["to_port"]
}

resource "aws_eip" "noble" {
  domain = "vpc"
  network_interface = aws_network_interface.noble.id
  associate_with_private_ip = aws_network_interface.noble.private_ip

  depends_on = [ aws_instance.noble ]
}

resource "aws_instance" "noble" {
  ami           = data.aws_ami.noble.id
  instance_type = var.aws_ec2_instance_type
  network_interface {
    network_interface_id = aws_network_interface.noble.id
    device_index = 0
  }
  key_name = var.aws_ec2_key_name

  tags = var.aws_ec2_tags
}

# resource "aws_ebs_volume" "noble" {
#   availability_zone = aws_instance.noble.availability_zone
#   size = var.aws_ebs_volume_size
#   tags = var.aws_ebs_volume_tags
# }

# resource "aws_volume_attachment" "noble" {
#   device_name = "/dev/sdf"
#   volume_id = aws_ebs_volume.noble.id
#   instance_id = aws_instance.noble.id
# }