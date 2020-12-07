# -------------------------- Terraform Providers -------------------------- 
#
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

# -------------------------- BACKEND --------------------------
terraform {
  backend "gcs" {
    bucket      = "tf-state"
    prefix      = "terraform/gke-cluster-testing-1"
    credentials = "gke-cluster-testing-1-ff7ecb751452.json"
  }
}


resource "null_resource" "auth_gcloud" {   //used
  provisioner "local-exec" {
    command = "gcloud auth activate-service-account 778026181558-compute@developer.gserviceaccount.com --key-file=/Users/chenqingmin/Codes/terraform_test_project_temp_ip/gke-cluster-testing-1-ff7ecb751452.json --project=gke-cluster-testing-1"
    //command = "gcloud auth activate-service-account 742690957765-compute@developer.gserviceaccount.com --key-file=/Users/chenqingmin/Codes/terraform_test_project_temp_small_2/dataprod-cluster-testing-1-7444c4c90649.json --project=dataprod-cluster-testing-1"
  }
}
# -------------------------- VPC MODULE --------------------------
#  I need to customize a module of my vpc and publish it to the terraform registry
//module "gcp_create_vpc"{
//   source       = "acnciotfregistry.accenture.com/accenture-cio/vpc/google"
//   version      = "1.0.0"
//   project_id   = "gke-cluster-testing-1"
//   region_name  = ['us-east1']
//}

module "gcp_create_vpc" {
  source = "terraform-google-modules/network/google//modules/vpc"
  version = "2.0.0"

  project_id = "gke-cluster-testing-1"
  network_name = "acn-cio-project-vpc"

  shared_vpc_host = false
}
