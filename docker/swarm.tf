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
      published_port = var.swarm_service_port
    }
  }
}
