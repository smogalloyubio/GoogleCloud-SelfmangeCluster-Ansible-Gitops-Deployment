
# GCP Terraform + Ansible: Production-Ready Dockerized Web Application Deployment

**Project Title:** End-to-End Automated Infrastructure Deployment on Google Cloud Platform (GCP) using Terraform and Ansible for a Highly Available Dockerized Web Application
**Technologies:** Terraform (IaC), Ansible (Configuration-as-Code), Docker, Google Cloud Platform (VPC, Subnets, Artifact Registry, Compute Engine, Cloud Load Balancing, IAM, Firewall Rules)  


---

## 1. Introduction

As a professional DevOps and Cloud Engineer, I designed and implemented this project to demonstrate **real-world expertise** in building secure, scalable, and fully automated cloud infrastructure from scratch.  

The solution deploys a **containerized web application**  across **two Compute Engine VMs** in Google Cloud Platform. Everything is provisioned using **Terraform** for immutable infrastructure and configured using **Ansible** for application deployment. A **Global HTTP Load Balancer** distributes traffic, and the entire stack is secured with least-privilege IAM, private Artifact Registry, and tightly controlled firewall rules.

**Live Demo (after deployment):**  
Access the application via the Load Balancer public IP on port 80. Traffic is automatically balanced between the two VMs running the Docker container.

---
Google cloud Digram
![Google cloud diagram]


---
## 2. Problem Statement

- **Manual infrastructure provisioning** leads to inconsistent environments, configuration drift, and long deployment times (hours or days).
- **Lack of automation** for Docker image building, pushing, and deployment results in human error and downtime during updates.
- **Security risks** from overly permissive IAM roles, open firewalls, and public container registries.
- **Scalability & High Availability** issues: single VM deployments cannot handle traffic spikes or provide fault tolerance.
- **Reproducibility** problems: developers and operations cannot reliably recreate the same stack across dev, staging, and production.
- **Operational overhead**: No clear separation between infrastructure (Terraform) and application configuration (Ansible), making maintenance painful.

**Business Impact:**  
These issues increase costs, slow down feature delivery, raise security vulnerabilities, and make it difficult to pass compliance audits or scale the application.

**My Solution:**  
I solved all of the above by building a **fully automated, modular, secure, and highly available** GCP stack that can be deployed with just a few commands. This project proves I can design solutions that eliminate manual work, enforce security best practices, and enable rapid, reliable scaling.

---

## 3. Step-by-Step Implementation (Exact Process I Carried Out)

I followed a disciplined, professional workflow that I use on real client projects. Here is **exactly** what I did, in the order I executed it:

### Step 1: Requirements Gathering & Architecture Design (Planning Phase)
- Defined functional requirements: 2 VMs, Docker runtime, private image registry, global load balancing, port 80 access.
- Designed modular Terraform architecture (7 modules) for reusability.
- Created Ansible playbooks for idempotent configuration.
- Documented security controls (least-privilege IAM, firewall restricted to Load Balancer proxy ranges only).
- Chose GCP services: Custom VPC, Artifact Registry, Compute Engine, Global HTTP(S) Load Balancer.

### Step 2: Terraform Infrastructure Provisioning (IaC Phase)
I created and applied the following **modular Terraform resources**:

1. **VPC Module** – Created a custom Virtual Private Cloud with `auto_create_subnetworks = false`.
2. **Subnet Module** – Provisioned a regional subnet inside the VPC.
3. **Artifact Registry Module** – Created a private Docker repository (`docker` format).
4. **Service Account Module** – Created a dedicated service account for the VMs with minimal permissions.
5. **IAM Module** – Assigned least-privilege roles (e.g., `roles/artifactregistry.reader`, `roles/logging.logWriter`).
6. **Compute Module** – Provisioned **two** Compute Engine VMs:
   - Attached the custom service account.
   - Placed them in an unmanaged Instance Group.
   - Used the subnet from Step 2.
7. **Load Balancer Module** – Created a complete Global HTTP Load Balancer:
   - Health check (HTTP on port 80).
   - Backend service linked to the Instance Group.
   - URL map, target HTTP proxy, and global forwarding rule.
8. **Firewall Module** – Opened **only**:
   - TCP 80 from Load Balancer proxy ranges (`130.211.0.0/22` and `35.191.0.0/16`) + health-check ranges.
   - TCP 22 (SSH) restricted to my IP for Ansible.

---

### Step 3: Setting Up Terraform Execution Environment on the VM
To ensure a consistent and reproducible Terraform execution environment, I created a custom Docker-based toolchain that includes both Terraform and the Google Cloud SDK (gcloud CLI). This approach eliminates version conflicts, and it works on my machine 
What I Did:
- Created a custom Dockerfile (Dockerfile.install)
- This Dockerfile is based on an official Ubuntu image and installs:
- Latest stable version of Terraform
- Latest Google Cloud SDK (gcloud CLI)
- Required dependencies and tools for GCP authentication

1. Built the Docker image
- I built the custom image locally using the following command:
```
docker build -f Dockerfile.install -t my-terraform-env:latest .
```
2. Created a Docker workspace container
- I launched a container from the built image and mounted my entire project repository inside it. This gave me a clean, isolated
- environment with Terraform and gcloud already configured and ready to use.
- Executed Terraform commands inside the container
- All Terraform operations (init, plan, and apply) were performed inside this Docker container to maintain consistency.
  
``` Build the custom Terraform + gcloud environment image
docker build -f Dockerfile.install -t my-terraform-env:latest .

# 2. Run the container with the project mounted
docker run -it --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  my-terraform-env:latest /bin/bash
Once inside the container, I executed the standard Terraform workflow:

cd Terraform
terraform init
terraform plan -out=plan.tfplan
terraform apply plan.tfplan
```
![ terraform version and gcloud version](https://github.com/smogalloyubio/GoogleCloud-Loadbalancing-Autoscaling/blob/main/picture/Screenshot%202026-04-03%20at%2023.32.42.png)
### why chose this method
- Consistency: Same Terraform and gcloud versions every time, regardless of the host machine.
- Portability: The environment can be shared with team members or used in CI/CD pipelines.
- Isolation: No pollution of the host VM with multiple tool versions.
- Security: gcloud authentication can be handled safely via mounted credentials or workload identity.
