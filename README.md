# Flask App — AWS ECS Deployment

A minimal Flask web application built for learning containerization and deployment to AWS ECS (Elastic Container Service).

*Part of the **TrainWithShubham — DevOps Zero To Hero** course.*

![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![Flask](https://img.shields.io/badge/flask-%23000.svg?style=for-the-badge&logo=flask&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)

---

## ✨ Features
- **Modern UI:** Responsive landing page featuring a modern glassmorphism UI design.
- **Health Monitoring:** Dedicated `/health` endpoint for AWS ECS health checks and monitoring.
- **Dual Docker Architecture:** Includes two Dockerfile approaches:
    - **Simple:** Basic single-stage build for quick testing.
    - **Multi-stage (Distroless-style):** High-security, lightweight production build.
- **Infrastructure as Code:** Fully automated AWS environment using Terraform.
- **DevSecOps:** Integrated automated security scanning in the CI/CD pipeline.

---

## 🛠 Tech Stack
| Component | Technology |
| :--- | :--- |
| **Framework** | Flask 3.1.1 |
| **Runtime** | Python 3.14 (Slim) |
| **Container** | Docker (python-slim / Multi-stage) |
| **Security** | Aqua Security Trivy |
| **CI/CD** | GitHub Actions |
| **Deploy** | AWS ECS (Fargate) |
| **IaC** | Terraform |

---

## 🚀 DevOps Pipeline (CI/CD)
The project implements a full automation lifecycle:
1. **Continuous Integration:** GitHub Actions builds the image on every push to `main`.
2. **Security Scanning:** **Trivy** inspects the image. If `CRITICAL` or `HIGH` vulnerabilities are found, the pipeline stops to protect production.
3. **Artifact Management:** Verified images are versioned with **Git SHAs** and pushed to Docker Hub.
4. **IaC Provisioning:** **Terraform** ensures the AWS Cluster, Service, and Networking are correctly configured.
5. **Continuous Deployment:** Automated rolling update to **AWS ECS Fargate**, ensuring zero downtime.

---

## 📁 Project Structure
```text
.
├── .github/workflows/   # CI/CD Pipeline (Build, Scan, Deploy)
├── terraform/           # IaC: AWS ECS Cluster & Service
│   └── main.tf
├── templates/           # UI: Glassmorphism Frontend
├── app.py               # Flask Application Logic
├── run.py               # Production Entry Point (Port 8080)
├── Dockerfile           # Optimized Multi-stage Build
├── docker-compose.yml   # Local Development Orchestration
└── task-definition.json # AWS ECS Blueprint
