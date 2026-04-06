variable "region" {}
variable "engine_compartment_id" {}
variable "nodes_compartment_id" {}
variable "vcn_id" {}
variable "endpoint_subnet_id" {}
variable "pod_subnet_id" {}
variable "kubernetes_version" { default = "v1.35.0" }
variable "node_kubernetes_version" { default = "v1.34.2" }
variable "node_image_id" {}
variable "availability_domain" {}
variable "ssh_public_key" {}