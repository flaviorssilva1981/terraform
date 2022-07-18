variable "amis" {
    type = map
    default = {
        "us-east-1" = "ami-052efd3df9dad4825"
        "us-east-2" = "ami-02f3416038bdb17fb"
    }
  
}

variable "cdirs_acesso_remoto" {
    type = list
    default = ["189.18.223.180/32","189.20.223.180/32"]
}

variable "key_name" {
    default = "terraform_aws"
}