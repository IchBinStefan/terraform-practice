provider "docker" {
  host = "tcp://127.0.0.1:2375"
}

provider "docker" {
  alias = "local"
  host  = "unix:///var/run/docker.sock"
}
