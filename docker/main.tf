terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.6.0"
    }
  }
}

provider "docker" {
  host = "tcp://127.0.0.1:2375"
}

variable "swarm_web_server_image" {
  type        = string
  description = "Web Server Image"
  sensitive   = true
}

variable "swarm_service_name" {
  type        = string
  description = "Docker Swarm Service Name"
  default     = "swarm-web-service"
}

variable "swarn_service_port" {
  type        = number
  description = "Docker Swarm Service Port"
  default     = 8080
}

resource "docker_service" "web-service" {
  name = var.swarm_service_name

  task_spec {
    container_spec {
      image = var.swarm_web_server_image
    }
    placement {
      constraints = [
        "node.role == worker"
      ]
    }
  }

  mode {
    replicated {
      replicas = 6
    }
  }

  endpoint_spec {
    ports {
      target_port    = 80
      published_port = var.swarn_service_port
    }
  }
}
