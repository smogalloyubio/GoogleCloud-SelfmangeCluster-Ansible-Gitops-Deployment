# Google Cloud GKE Cluster Deployment with Terraform

This repository contains production-ready Terraform scripts to deploy a single-node GKE (Google Kubernetes Engine) cluster on Google Cloud.

## Local Development with Docker

For a consistent development environment, use the provided Docker setup:

### Prerequisites
- [Docker](https://docs.docker.com/get-docker/) installed

### Quick Start
```bash
# Build and run the development container
./build-and-run.sh
```

### Manual Commands
```bash
# Build the image
docker build -f Dockerfile.local -t terraform-gcloud-local .

# Run the container
docker run -it --rm \
  --name terraform-dev \
  -v $(pwd):/workspace \
  -v ~/.config/gcloud:/root/.config/gcloud \
  -v ~/.ssh:/root/.ssh \
  terraform-gcloud-local
```

### What's Included
- **Terraform CLI** - Latest version from HashiCorp repository
- **Google Cloud SDK** - Full gcloud, gsutil, and bq CLIs
- **Git** - Version control
- **Text editors** - vim and nano
- **Bash completion** - For both terraform and gcloud commands

### Authentication
Inside the container, authenticate with Google Cloud:
```bash
# Login interactively
gcloud auth login

# Or use service account key (if you have one)
gcloud auth activate-service-account --key-file=/workspace/service-account-key.json

# Set your project
gcloud config set project YOUR_PROJECT_ID
```

## Prerequisites (Without Docker)

- [Terraform](https://www.terraform.io/downloads.html) installed (version ~> 1.0)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed
- A Google Cloud Project with billing enabled
- Appropriate permissions to create GKE clusters

## Setup

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd GoogleCloud-SelfmangeCluster-Ansible-Gitops-Deployment
   ```

2. Authenticate with Google Cloud:
   ```bash
   gcloud auth login
   gcloud config set project YOUR_PROJECT_ID
   ```

3. Edit `terraform/terraform.tfvars` and replace `your-project-id` with your actual Google Cloud project ID.

4. Navigate to the terraform directory and initialize Terraform:
   ```bash
   cd terraform
   terraform init
   ```

## Deployment

1. Plan the deployment:
   ```bash
   terraform plan
   ```

2. Apply the changes:
   ```bash
   terraform apply
   ```

   Confirm with `yes` when prompted.

## Accessing the Cluster

After deployment, use the output `kubectl_config_command` from the compute module to configure kubectl:

```bash
terraform output -module=compute kubectl_config_command
# Run the command it outputs
```

## Module Outputs

Outputs are organized by module:

### Network Module
- `vpc_name`, `subnet_name` - Resource names
- `vpc_self_link`, `subnet_self_link` - Self-links
- `vpc_id`, `subnet_id` - Resource IDs
- `subnet_gateway_address` - Gateway IP
- `pods_secondary_range_name`, `services_secondary_range_name` - Secondary ranges

### Compute Module
- `cluster_name`, `cluster_endpoint` - Cluster details
- `cluster_ca_certificate` - CA certificate (sensitive)
- `kubectl_config_command` - kubectl setup command
- `cluster_location`, `cluster_self_link` - Location info
- `cluster_master_version` - Kubernetes version
- `service_account_email` - Service account
- `node_pool_name`, `node_pool_instance_group_urls` - Node pool info
- `workload_identity_pool` - Workload identity

Access outputs using: `terraform output -module=<module_name> <output_name>`

## Cleanup

To destroy the cluster and all resources:

```bash
terraform destroy
```

## Configuration

The cluster is configured with:
- 1 node pool with 1 preemptible node (e2-medium)
- VPC network and subnet
- Service account with cloud-platform scope

You can modify `variables.tf` and `main.tf` to customize the setup.

## Troubleshooting

- Ensure your Google Cloud project has the Kubernetes Engine API enabled.
- Check that your account has the necessary IAM roles (e.g., Kubernetes Engine Admin).
- If you encounter quota issues, request increases in the Google Cloud Console.
