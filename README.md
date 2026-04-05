
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
![Google cloud diagram](https://github.com/smogalloyubio/GoogleCloud-Loadbalancing-Autoscaling/blob/main/picture/my-docker-image.jpeg)


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

![terraform modules](https://github.com/smogalloyubio/GoogleCloud-Loadbalancing-Autoscaling/blob/main/picture/Screenshot%202026-04-05%20at%2001.57.08.png)

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
![terraform provisioning](https://github.com/smogalloyubio/GoogleCloud-Loadbalancing-Autoscaling/blob/main/picture/Screenshot%202026-04-04%20at%2023.25.29.png)
---

### Step 3: Setting Up Terraform Execution Environment on the VM
To ensure a consistent and reproducible Terraform execution environment, I created a custom Docker-based toolchain that includes both Terraform and the Google Cloud SDK (gcloud CLI). This approach eliminates version conflicts, and it works on my machine 
What I Did:
- Created a custom Dockerfile (Dockerfile.install)
- This Dockerfile is based on an official Ubuntu image and installs:
- Latest stable version of Terraform
- Latest Google Cloud SDK (gcloud CLI)
- Required dependencies and tools for GCP authentication

---
![terraform outpu](https://github.com/smogalloyubio/GoogleCloud-Loadbalancing-Autoscaling/blob/main/picture/Screenshot%202026-04-05%20at%2001.55.47.png)
---

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


### Step 4: Ansible Configuration Management and Application Deployment

After the Terraform infrastructure was fully provisioned (VPC, Subnet, two Compute Engine VMs, Artifact Registry, Load Balancer, and Firewall rules), I moved to the **Configuration-as-Code (CaC)** phase using **Ansible**.  

This step handled everything that is “mutable” — installing Docker, building the application image, pushing it to the private Artifact Registry, and finally deploying and running the container on both VMs. I used Ansible because it is agentless, idempotent, and perfect for zero-downtime application updates.

#### What I Did (Exact Steps I Carried Out):

1. **Prepared the Ansible Environment**  
   - Created a clean Ansible project structure with playbooks, host, and inventory.  
   - Installed  Docker on  vm

![ansible tesing vm connection](https://github.com/smogalloyubio/GoogleCloud-Loadbalancing-Autoscaling/blob/main/picture/Screenshot%202026-04-05%20at%2000.03.58.png)

2. **Playbook 1 – Install Docker on Both VMs** (`playbook.yaml`)  
   - Targeted the host group  virtual machine   
   - Installed Docker Engine, added the official Docker repository, started and enabled the Docker service.  
   - Made the playbook fully idempotent (safe to run multiple times).

```
- name: Install docker on google cloud
  hosts: webservers
  become: yes
  tasks:
    - name: Update the virtual machine
      apt:
        update_cache: yes

    - name: Install docker
      apt:
        name: docker.io
        state: present

    - name: Start docker daemon
      service:
        name: docker
        state: started
        enabled: yes

    - name: Add machine user to docker
      user:
        name: ubuntu
        groups: docker
        append: yes

    - name: Verify docker user
      command: docker ps
      become_user: ubuntu

    - name: Reset connection to apply group changes
      meta: reset_connection
```

---
![ansible deployment](https://github.com/smogalloyubio/GoogleCloud-Loadbalancing-Autoscaling/blob/main/picture/Screenshot%202026-04-05%20at%2000.58.24.png)
---

3. **Playbook 2 – Build & Push Docker Image** (`builddocker.yaml`)  
   - Ran from my **local machine** (or the Terraform Docker container).   
   - Built the Docker image locally from the  root directory folder.  
   - Tagged and pushed the image to the private Artifact Registry created by Terraform.
  
```
---
- name: Build and Push Docker Image
  hosts: localhost
  connection: local
  vars:
    project_id: "ubioworo-project"
    region: "us-central1"
    repo_name: "googla-app-deploy"
    image_name: "my-app"
    image_tag: "latest"
    full_image_path: "{{ region }}-docker.pkg.dev/{{ project_id }}/{{ repo_name }}/{{ image_name }}:{{ image_tag }}"

  tasks:
    - name: Authenticate Docker to Google Artifact Registry
      shell: "gcloud auth configure-docker {{ region }}-docker.pkg.dev --quiet"

    - name: Build Docker image locally
      community.docker.docker_image:
        name: "{{ full_image_path }}"
        build:
          path: ../ l
        source: build

    - name: Push image to Google Artifact Registry
      community.docker.docker_image:
        name: "{{ full_image_path }}"
        push: yes
        source: local

- name: Deploy Image to GCP VMs
  hosts: webservers
  become: yes
  vars:
    full_image_path: "us-central1-docker.pkg.dev/ubioworo-project/googla-app-deploy/my-app:latest"

  tasks:
    - name: Authenticate remote Docker to GCP
      shell: "gcloud auth configure-docker us-central1-docker.pkg.dev --quiet"

    - name: Pull and Run the new container
      community.docker.docker_container:
        name: my-web-service
        image: "{{ full_image_path }}"
        state: started
        restart: yes
        pull: yes
        ports:
          - "80:80"
```
![ansible deployment](https://github.com/smogalloyubio/GoogleCloud-Loadbalancing-Autoscaling/blob/main/picture/Screenshot%202026-04-05%20at%2000.58.28.png)
---
4. **Playbook 3 – Deploy & Run the Container on Both VMs** (`pullinstalldockerimage.yaml`)  
   - Targeted the  virtual  machine.  
   - Pulled the latest image from Artifact Registry.  
   - Started the container with `restart_policy: always`, port mapping `80:80`, and detached mode.  
   - The Load Balancer (already provisioned by Terraform) immediately started routing traffic to both healthy containers.
   - ansible-playbook -i inventory.ini  pullinstalldockerimage.yaml  to deploy the docker image  to teh virtual machine
![ansible  deployment to te virtual machine]()

```
---
- name: Deploy Image to GCP VMs
  hosts: webservers2
  become: yes
  vars_files:
    - secrets.yml  
  vars:
    image_path: "rukevweubio/ecommerce-app"

  tasks:
    - name: Ensure Docker is installed and running
      service:
        name: docker
        state: started

    - name: Login to Docker Hub
      shell: "echo {{ DOCKER_PASSWORD }} | docker login -u {{DOCKER_USER }} --password-stdin"

    - name: Pull the latest image from Docker Hub
      shell: "docker pull {{ image_path }}"

    - name: Stop and remove existing container
      shell: "docker rm -f my-web-app2 || true"


    - name: Run new container on port 8080
      shell: "docker run -d --name my-web-app2 -p 80:80 rukevweubio/ecommerce-app"

    - name: Verify container is running
      shell: "docker ps --filter 'name=my-web-app2'"
      register: container_status

    - name: Print status
      debug:
        var: container_status.stdout_lines
```

5. **Firewall Validation**  
   - Verified that the VPC firewall rules (created in Terraform) correctly allow TCP 80 traffic **only** from the Load Balancer proxy ranges and health-check ranges.

#### Commands Executed:

```
# 1. Prepare Ansible (run once)
cd Ansible 
pip install ansible -y                  

# 2. Install Docker on the two VMs
ansible-playbook  -i inventory.ini  dockerbuild.yaml
ansible-playbook -i inventory.ini dockerbuild.yaml

# 3. Build and push the Docker image from localhost
ansible-playbook -i inventory.ini  installandconfiguredocker.yaml

# 4. Deploy the container to both VMs
ansible-playbook playbooks/vms-deploy-app.yml

#5 test the  virtual machine   if the docker is running
ansible-playbook -i inventory.ini -m  shell -a "docker ps -a"

```

## 5. Project Screenshots & Results

Below are real screenshots from the deployed project, proving that the infrastructure and application are working as expected.

### 1. Web Application Running Successfully (via Load Balancer)

![Google  virtual machine](https://github.com/smogalloyubio/GoogleCloud-Loadbalancing-Autoscaling/blob/main/picture/Screenshot%202026-04-05%20at%2002.03.17.png)

### 2. GCP Load Balancer Configuration and Health Check Status

![GCP Load Balancer virtual machine ](https://github.com/smogalloyubio/GoogleCloud-Loadbalancing-Autoscaling/blob/main/picture/Screenshot%202026-04-05%20at%2001.19.42.png)

**Description:**  
The Global HTTP(S) Load Balancer is healthy, with both backend VMs showing **Healthy** status. You can see the forwarding rule, backend service, and health checks all configured correctly by Terraform.

---
![ Google cloud  loadbalancer health check](https://github.com/smogalloyubio/GoogleCloud-Loadbalancing-Autoscaling/blob/main/picture/Screenshot%202026-04-05%20at%2002.02.49.png)
---
** web application running**
- web appliaction running using loadbalacer
  ![web application](https://github.com/smogalloyubio/GoogleCloud-Loadbalancing-Autoscaling/blob/main/picture/Screenshot%202026-04-05%20at%2001.44.17.png)

![web applixation 2](https://github.com/smogalloyubio/GoogleCloud-Loadbalancing-Autoscaling/blob/main/picture/Screenshot%202026-04-05%20at%2001.44.31.png)
