resource "google_service_account" "nat-sa" {
  account_id   = "nat-tf-custom-sa"
  display_name = "Custom SA for VM Instance"
}
