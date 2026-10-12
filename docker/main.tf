terraform {
  required_version = ">=1.16.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.6.0"
    }
  }
}

module "containers" {
  source = "./containers"

  providers = {
    docker = docker.local
  }

  container_name = "caddy-server"
  port           = 8083
}
