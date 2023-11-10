resource "google_cloud_run_service" "demo" {
  name     = "demo-terraform"
  location = "asia-southeast1"

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
        env {
          name  = "DB_URL"
          value = "postgres://user:password@host/db"
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# data "google_iam_policy" "noauth" {
#   binding {
#     role = "roles/run.invoker"
#     members = [
#       "allUsers",
#     ]
#   }
# }

# resource "google_cloud_run_service_iam_policy" "demo" {
#   location = google_cloud_run_service.demo.location
#   project  = google_cloud_run_service.demo.project
#   service  = google_cloud_run_service.demo.name

#   policy_data = data.google_iam_policy.noauth.policy_data
# }
