resource "google_compute_network" "vpc_network" {
    name = "gke-vpc"
    auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "subnetwork" {
    name = "gke-subnet"
    ip_cidr_range = "10.0.0.0/16"
    region = "us-central1"
    network = google_compute_network.vpc_network.id
}

resource "google_container_cluster" "gke_cluster1" {
  name     = "nikhil-cluster1"
  location = "us-central1"

  remove_default_node_pool = true  
  enable_shielded_nodes = true
  logging_service       = "logging.googleapis.com/kubernetes"
  monitoring_service    = "monitoring.googleapis.com/kubernetes"

  
  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.subnetwork.name

  node_pool {
    name       = "virtusa-pool"
    node_count = 1

    autoscaling {
      min_node_count = 1
      max_node_count = 1
    }

    node_config {
      machine_type  = "e2-small"
      disk_size_gb  = 20
      disk_type     = "pd-standard"   
      preemptible   = false

      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
      ]
    }
  }
}