#!/usr/bin/env bash
set -e

echo "=== Updating system packages ==="
apt-get update -y
apt-get install -y wget unzip apt-transport-https ca-certificates gnupg

echo "=== Installing Terraform CLI ==="
# Download latest Terraform (update version if needed)
TERRAFORM_VERSION="1.6.12"
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
mv terraform /usr/local/bin/
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

echo "Terraform installed at: $(which terraform)"
terraform version

echo "=== Installing Google Cloud CLI ==="
# Add the Cloud SDK distribution URI as a package source
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
    | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Import Google Cloud public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

apt-get update -y
apt-get install -y google-cloud-cli

echo "gcloud installed at: $(which gcloud)"
gcloud version

echo "=== All tools installed successfully ==="