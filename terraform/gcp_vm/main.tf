# Configure GCP project
provider "google" {
  project = var.google_cloud_project
}


resource "google_compute_network" "terraform_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = "true"
}


resource "google_compute_instance" "telltime" {
  name         = "telltime-vm"
  machine_type = "f1-micro"
  zone         = "us-central1-a"
  tags         = ["ssh"]

  metadata = {
    enable-oslogin = "TRUE"
  }
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  # Install Flask
  #metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

  network_interface {
    network = google_compute_network.terraform_network.self_link

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}


resource "google_compute_firewall" "ssh" {
  name = "allow-ssh"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.terraform_network.self_link
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}


resource "google_compute_firewall" "app_traffic" {
  name    = "app-firewall"
  network = google_compute_network.terraform_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  source_ranges = ["0.0.0.0/0"]
}
