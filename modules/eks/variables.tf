variable "name" {
  type = string
}
variable "role_arn" {
  type = string
}
variable "authentication_mode" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}