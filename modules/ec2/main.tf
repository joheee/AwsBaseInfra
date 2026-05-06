resource "aws_instance" "this" {
    ami = var.ami 
    instance_type = var.instance_type
    primary_network_interface {
      network_interface_id = var.nic_id
    }
    tags = {
      Name = var.ec2_name
    }
}