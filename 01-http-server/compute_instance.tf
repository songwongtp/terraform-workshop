locals {
  port = 80
}

resource "google_compute_firewall" "default" {
  name    = "nat-firewall"
  network = "default" // google_compute_network.default.name

  #   allow {
  #     protocol = "icmp"
  #   }

  allow {
    protocol = "tcp"
    ports    = [local.port]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["nat-web"]
}

resource "google_compute_instance" "default" {
  name = "nat-tf-instance"
  // `gcloud compute machine-types list`
  machine_type = "n2-standard-2"
  // `gcloud compute zones list`
  zone = "asia-southeast1-b"

  tags = google_compute_firewall.default.target_tags

  boot_disk {
    initialize_params {
      // `gcloud compute images list`
      image = "ubuntu-os-cloud/ubuntu-2310-mantic-amd64-v20231031"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  # Environment variables
  metadata_startup_script = templatefile("./startup.tpl", {
    "project" : "HELLO_nat",
    "port" : local.port,
    "image" : google_storage_bucket_object.image.media_link
  })

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.nat-sa.email
    scopes = ["cloud-platform"]
  }
}
