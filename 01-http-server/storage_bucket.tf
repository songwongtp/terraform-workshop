resource "google_storage_bucket" "nat-image-store" {
  name          = "nat-image-store-bucket"
  location      = "asia-southeast2"
  storage_class = "STANDARD"
}

resource "google_storage_default_object_access_control" "public_rule" {
  bucket = google_storage_bucket.nat-image-store.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket_object" "image" {
  name   = "exampl"
  source = "images/example.png"
  bucket = google_storage_bucket.nat-image-store.name
}

// For using with multiple project, i.e., apply this tf, then access this with `terraform_remote_state`
# output "bucket_path" {
#   value = "gs://${google_storage_bucket.nat-image-store.name}/${google_storage_bucket_object.image.name}"
# }
