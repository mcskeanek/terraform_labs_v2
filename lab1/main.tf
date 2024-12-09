provider "docker" {
  host = "tcp://localhost:2375"
}

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.1"
    }
  }
}

# Pulls the image
resource "docker_image" "apache_web" {
  name = "httpd:latest"
}

resource "docker_container" "web_server" {
  image = docker_image.apache_web.image_id
  name  = "web_server"
  ports {
    internal = 80
    external = 8080
  }
}
