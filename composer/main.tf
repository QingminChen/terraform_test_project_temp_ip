# -------------------------- PROVIDERs --------------------------
provider "google-beta" {
  credentials = file("gke-cluster-testing-1-ff7ecb751452.json")
  project     = "gke-cluster-testing-1"
  region      = "us-east1"
  zone        = "us-east1-d"
}

provider "google" {
  credentials = file("gke-cluster-testing-1-ff7ecb751452.json")
  project     = "gke-cluster-testing-1"
  region      = "us-east1"
  zone        = "us-east1-d"
}

terraform {
  backend "gcs" {
    bucket      = "tf-state"
    prefix      = "terraform/gke-cluster-testing-1"
    credentials = file("gke-cluster-testing-1-ff7ecb751452.json")
  }
}

# -------------------------- Project Configuration --------------------------
# Getting project resource

data "google_project" "project" {
  project_id = "gke-cluster-testing-1"
}

# --------------------------------------------  Composer Module   -------------------------------------------------------------

module "my_composer"{
 source                      = "acnciotfregistry.accenture.com/accenture-cio/vpc/google"
 version                     = "1.0.1"
 environment_service_account = file("gke-cluster-testing-1-ff7ecb751452.json")
 zone_name                   = "us-east1-d"
 vpc_name                    = "acn-cio-project-vpc"

 # Optional input variables
 composer_instances_type     = "n1-standard-2"
 composer_worknode_count     = 3
 image_version               = "composer-1.12.2-airflow-1.10.9"
 
}


################### locals ################

 locals {
     bucket_name = trimsuffix(trimprefix(module.my_composer.gcp_composer_dags_prefix, "gs://"), "/dags")
     
 }

