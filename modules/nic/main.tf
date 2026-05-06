resource "aws_network_interface" "this" {
    subnet_id = var.subnet_id
    private_ip = var.private_ip
    tags = {
        Name = var.nic_name
    }
}