variable "ports" {
  description = "Ports to be opened in the security group"
  type = map(object({
    description = string
    cidr_blocks = list(string)
    protocol    = string
  }))
  default = {
    22 = {
      description = "ssh port 22"
      cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
      protocol    = "tcp"
    }
    80 = {
      description = "web server port 80"
      cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
      protocol    = "tcp"
    }
    443 = {
      description = "web server port 443"
      cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
      protocol    = "tcp"
    }
    3306 = {
      description = "mysql port 3306"
      cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
      protocol    = "tcp"
    }
    5432 = {
      description = "postgresql port 5432"
      cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
      protocol    = "tcp"
    }
    6379 = {
      description = "redis port 6379"
      cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
      protocol    = "tcp"
    }
    8080 = {
      description = "php port 8080"
      cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
      protocol    = "tcp"
    }
  }
}