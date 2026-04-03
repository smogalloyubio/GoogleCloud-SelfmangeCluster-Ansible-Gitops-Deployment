terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.26.0"
    }
  }
}

provider "google" {
  project = "ubioworo-project"
  region  = "us-central1"
}