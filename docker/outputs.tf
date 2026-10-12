output "service_name" {
  description = "The name of the Swarm service"
  value = docker_service.web-service.name
}

output "moule_container_name" {
  description = "Name of the container name from the Child Module"
  value = module.containers.container_name
}
