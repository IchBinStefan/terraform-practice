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

variable "swarm_service_port" {
  type        = number
  description = "Docker Swarm Service Port"
  default     = 8080
}
