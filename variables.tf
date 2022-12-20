


# defining the cidr range under each subnet.
# if u do not define any thing inside default then the terraform will ask at the cli like.
# what value we need to define. this will ask u to define 

variable "pub_cidr" {
  default = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24"]
  type    = list(any)
}

variable "private_cidr" {
  default = ["10.1.3.0/24", "10.1.4.0/24", "10.1.5.0/24"]
  type    = list(any)

}

variable "data_cidr" {
  default = ["10.1.6.0/24", "10.1.7.0/24", "10.1.8.0/24"]
  type    = list(any)

}
