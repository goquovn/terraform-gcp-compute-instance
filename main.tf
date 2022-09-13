resource "random_string" "name_suffix" {
  length  = 6
  upper   = false
  special = false
}
resource "google_compute_firewall" "firewall" {
  name    = "${var.instance_name}-${random_string.name_suffix.result}"
  network = var.vpc
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = var.instance_tcp_ports
  }
  allow {
    protocol = "udp"
    ports    = var.instance_udp_ports
  }
  source_ranges = var.source_ranges
  target_tags   = ["${var.instance_name}-${random_string.name_suffix.result}"]
}

resource "google_compute_address" "static" {
  count      = var.static_ip ? 1 : 0
  name       = "${var.instance_name}-${random_string.name_suffix.result}"
  project    = var.project_id
  region     = var.region
  depends_on = [google_compute_firewall.firewall]
}
resource "google_compute_instance" "instance" {
  name         = "${var.instance_name}-${random_string.name_suffix.result}"
  machine_type = var.machine_type
  zone         = var.machine_zone != null ? var.machine_zone : "${var.region}-a"
  project      = var.project_id
  tags         = ["${var.instance_name}-${random_string.name_suffix.result}"]
  boot_disk {
    initialize_params {
      image = var.machine_image
    }
  }
  network_interface {
    network    = var.vpc
    subnetwork = var.subnet
    dynamic "access_config" {
      for_each = var.static_ip == true ? [
        {
          ip = google_compute_address.static[0]
        }
      ] : []

      content {
        nat_ip = ip
      }
    }
  }
  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  metadata_startup_script = var.startup_script

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }
  metadata = var.metadata
}