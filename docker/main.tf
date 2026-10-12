terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.6.0"
    }
  }
}

provider "docker" {
  // config
}

variable "nginx_image" {
  type        = string
  description = "NGINX Image"
  sensitive   = true
}

variable "nginx_container_name" {
  type        = string
  description = "NGINX Container Name"
  default     = "nginx"
}

variable "nginx_container_port" {
  type        = number
  description = "NGINX Container Port"
  default     = 8080
}

resource "docker_image" "nginx" {
  name         = var.nginx_image
  keep_locally = false
}

resource "docker_container" "nginx_server" {
  image = docker_image.nginx.image_id
  name  = var.nginx_container_name

  ports {
    internal = var.nginx_container_port
    external = 8080
  }
}
