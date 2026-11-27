variable "yc_token" {
  type        = string
  description = "OAuth-токен Яндекс.Облака"
  sensitive   = true
}

variable "yc_cloud_id" {
  type        = string
  description = "ID облака Яндекс.Облака"
}

variable "yc_folder_id" {
  type        = string
  description = "ID каталога Яндекс.Облака"
}

variable "network_name" {
  type        = string
  default     = "diplom-vpc"
  description = "Имя VPC сети"
}

variable "subnets" {
  type = map(object({
    zone = string
    cidr = string
  }))
  default = {
    subnet-a = {
      zone = "ru-central1-a"
      cidr = "10.10.1.0/24"
    }
    subnet-b = {
      zone = "ru-central1-b"
      cidr = "10.10.2.0/24"
    }
    subnet-d = {
      zone = "ru-central1-d"
      cidr = "10.10.3.0/24"
    }
  }
  description = "Список подсетей в трех зонах доступности"
}

variable "ssh_public_key" {
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4rkr7PjV2b7uISWT+a/PBlgLWSKND9Ynw6Uwnr+rbu+ivykgBuUN1Xkk8EQZYaM0y9o40mgkm4fYtFrt5+RB8mebF4wbxVrFrFE/GxEusyiu97184HdER2Cc05re8Wr2tH+skC0rnZR7DeSk8MQFjDI5pi0TU3WE6NbvxKi1s+UBf3Bo0Hv5uhU1/enz/LI+3Y1/DQZrk5iXHNbhLI2TTVrHuyAzgvQb6qKHxObhPZL7Ovt+hB3ZTHC+NFtS+gG3EPD3JYYryHdjKmBr07F7eE8nvzqk9aEDt2mHNUwF+UTHD0E3Z1G+QeixqODHsuPUK+q//XG9v/5P30ir+Egaqef/QPe/j0mdOfonTeFWG77c+5ibX/EzulzAP/wzEf3/5yDDbev6x7iRnGYpOFGd6idccVM/Q4u35jhha8lb4J+f4Lnsp+xQ6dIkB1aCYb9hv0OLyRihetHTZuriQbilqeQYb55z2sE+CKda1jU6PPbj5/a9u3D1WfgHWxvF3fh8= mistorid@mistorid-pc"
  description = "Публичный SSH ключ для доступа к ВМ"
}
