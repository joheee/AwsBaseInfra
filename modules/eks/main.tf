resource "aws_eks_cluster" "this" {
    name = var.name
    role_arn = var.role_arn
    access_config {
      authentication_mode = var.authentication_mode
    }
    vpc_config {
      subnet_ids = var.subnet_ids
    }
}