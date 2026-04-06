provider "oci" {
  region = var.region
}

resource "oci_containerengine_cluster" "generated_oci_containerengine_cluster" {
	cluster_pod_network_options {
		cni_type = "OCI_VCN_IP_NATIVE"
	}
	compartment_id = var.engine_compartment_id
	endpoint_config {
		subnet_id = var.endpoint_subnet_id
	}
	kubernetes_version = var.kubernetes_version
	name = "prod_arm_pool"
	options {
        service_lb_subnet_ids = [var.nlb_subnet_id]
		kubernetes_network_config {
			services_cidr = "10.96.0.0/16"
		}
	}
	type = "BASIC_CLUSTER"
	vcn_id = var.vcn_id
}

resource "oci_containerengine_node_pool" "create_node_pool_details0" {
	cluster_id = oci_containerengine_cluster.generated_oci_containerengine_cluster.id
	compartment_id = var.nodes_compartment_id
	initial_node_labels {
		key = "name"
		value = "prod_arm_pool"
	}
	kubernetes_version = var.node_kubernetes_version
	name = "prod_arm_pool"
	node_config_details {
		is_pv_encryption_in_transit_enabled = "true"
		node_pool_pod_network_option_details {
			cni_type = "OCI_VCN_IP_NATIVE"
			max_pods_per_node = "93"
			pod_subnet_ids = [var.pod_subnet_id]
		}
		placement_configs {
			availability_domain = var.availability_domain
			subnet_id = var.pod_subnet_id
		}
		size = "1"
	}
	node_eviction_node_pool_settings {
		eviction_grace_duration = "PT60M"
		is_force_delete_after_grace_duration = "true"
	}
	node_shape = "VM.Standard.A1.Flex"
	node_shape_config {
		memory_in_gbs = "24"
		ocpus = "4"
	}
	node_source_details {
		boot_volume_size_in_gbs = "50"
		image_id = var.node_image_id
		source_type = "IMAGE"
	}
	ssh_public_key = var.ssh_public_key
}
