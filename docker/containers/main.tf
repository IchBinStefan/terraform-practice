resource "docker_image" "caddy" {
  name = "caddy:alpine"
  keep_locally = false
}

resource "docker_container" "caddy_container" {
  image = docker_image.caddy.image_id
  name = var.container_name

  ports {
    internal = 80
    external = var.port
  }
}
