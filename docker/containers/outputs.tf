output "container_name" {
  description = "Name of the Web Server Container"
  value = docker_container.caddy_container.name
}
