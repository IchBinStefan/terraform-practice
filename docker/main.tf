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

resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = false
}

resource "docker_image" "caddy" {
  name         = "caddy:alpine"
  keep_locally = false
}

resource "docker_container" "nginx_server" {
  image = docker_image.nginx.image_id
  name  = "nginx-server"

  ports {
    internal = 80
    external = 8080
  }
}

resource "docker_container" "caddy_server" {
  image = docker_image.caddy.image_id
  name  = "caddy-server"

  ports {
    internal = 80
    external = 8081
  }
}
