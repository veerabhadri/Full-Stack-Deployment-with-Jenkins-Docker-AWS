locals {
  project_name = var.project_name

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  frontend_container_name = "frontend"
  backend_container_name  = "backend"

  frontend_port = 80
  backend_port  = 8080

  frontend_health_check = "/"
  backend_health_check  = "/"

  frontend_cpu    = var.frontend_cpu
  frontend_memory = var.frontend_memory

  backend_cpu    = var.backend_cpu
  backend_memory = var.backend_memory
}