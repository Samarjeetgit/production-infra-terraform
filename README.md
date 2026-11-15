# production-infra-terraform


[![CI/CD Pipeline Status](https://github.com/Samarjeetgit/production-infra-k3s/actions/workflows/ci.yml/badge.svg)](https://github.com/Samarjeetgit/production-infra-k3s/actions)
![Infrastructure](https://img.shields.io/badge/Orchestration-Local%20K3s%20%2F%20Docker-blue)
![Security Gate](https://img.shields.io/badge/Security-Trivy%20%26%20Checkov-success)
![Cost Optimization](https://img.shields.io/badge/Cost-%240.00%2Fmo-orange)

An enterprise-grade, production-simulated Kubernetes and Infrastructure-as-Code platform built to demonstrate high-availability patterns, automated configuration management, centralized observability, and automated rollback deployment pipelines on a cost-optimized local k3s stack.

---

## 🎯 Problem Statement & Design Rationale

Design, provision, and manage a complete production-grade environment combining infrastructure automation, container orchestration, configuration management, and full observability. This capstone project integrates core DevOps principles into a cohesive, resilient architecture.

* **Path Selection:** To eliminate ongoing cloud costs and work within local development constraints, this project is built on a high-performance local **k3s / Docker** substrate. This mirrors cloud architecture patterns (namespaces, network policies, RBAC, Ingress routing, and Prometheus scraping) while proving disciplined engineering trade-offs and cost awareness.
* **Interview Framing:** *"I built this platform locally on k3s to keep operational costs at zero while mastering cluster primitives; here is how the Terraform and security layers map directly to an enterprise AWS/EKS production architecture."*

---

## 🏗️ Architecture & Data Flow

```text
GitHub Actions (OIDC / CI Pipeline)
    │
    ├─► 1. Static Analysis & Security Scans (Checkov, Trivy, Gitleaks)
    ├─► 2. Build & Push Immutable Container Image (SHA-tagged)
    └─► 3. Automated Kubernetes Deployment & Rollout Verification
          ├── Traefik / Nginx Ingress Controller
          ├── Dual Microservices (With Probes & Strict Resource Limits)
          ├── Prometheus & Grafana (In-Cluster Observability Stack)
          └── Zero-Trust NetworkPolicies & Scoped RBAC Boundaries

🛠️ Tech Stack & Engineering Decisions
Infrastructure as Code (IaC): Terraform for local resource orchestration, network definitions, and state management.

Configuration Management: Ansible for server bootstrapping, common security hardening, and firewall baselines.

Container Orchestration: Lightweight k3s Kubernetes cluster providing full control plane compatibility.

Observability Suite: Prometheus for metrics collection, Grafana for visual dashboards, and Loki for log aggregation.

CI/CD & Security: GitHub Actions executing automated linting, vulnerability scanning (Trivy), policy-as-code checks (Checkov), and automated rollback verification (kubectl rollout status).


📂 Repository Layout 
├── README.md                     # Master project documentation
├── docs/
│   ├── architecture.md           # Network topology and component data flows
│   ├── adr/                      # Architecture Decision Records (k3s vs EKS, Helm vs Manifests)
│   ├── runbook.md                # Incident response playbook (symptom -> check -> fix)
│   ├── cost.md                   # Economic analysis and resource breakdown ($0 local vs cloud)
│   ├── troubleshooting.md        # Documented debugging logs for real infrastructure issues
│   └── failure-notes.md          # Induced chaos engineering scenarios & recovery evidence
├── terraform/
│   ├── bootstrap/                # Isolated state backend configuration
│   ├── modules/                  # Reusable infrastructure components
│   └── environments/             # Environment-specific declarations (dev/prod)
├── ansible/
│   ├── inventory/                # Static and dynamic server inventories
│   ├── group_vars/               # Encrypted secrets managed via Ansible Vault
│   └── roles/                    # System hardening, firewall, and common packages
├── kubernetes/
│   ├── base/                     # Core deployments, services, ingress, and configmaps
│   ├── overlays/                 # Environment variants (dev vs prod configurations)
│   ├── observability/            # Prometheus, Grafana, and Loki manifests
│   └── policy/                   # RBAC roles, NetworkPolicies, and admission labels
└── .github/workflows/
    ├── ci.yml                    # Test, build, scan, and push pipeline
    └── deploy.yml                # Rollout deployment with automated verification & rollback

🚀 8-Phase Build & Execution Sequence
Bootstrap: Initialized isolated root modules and state management to guarantee secure execution locks.

Network Topology: Provisioned local bridge networks and simulated multi-AZ subnet routing models.

Cluster Provisioning: Deployed local k3s cluster nodes and verified cluster health via kubectl get nodes.

Configuration Hardening: Executed Ansible playbooks (common and hardening roles) ensuring idempotent system configuration states.

Application Workloads: Deployed dual microservices equipped with strict CPU/memory resource requests/limits and liveness/readiness probes.

Observability Stack: Configured Prometheus and Grafana dashboards tracking live CPU, memory, and HTTP request metrics.

CI/CD Pipeline & Rollout Verification: Implemented automated deployment checks using kubectl rollout status --timeout, triggering automatic rollback upon detecting failing health probes.

Security Lockdown: Enforced RBAC boundary limitations, Pod Security Admission labels, and strict Namespace NetworkPolicies.

🛡️ Security & Compliance Highlights
Automated Gating: Pull requests and builds are halted if Trivy or Checkov detects critical CVEs or security misconfigurations.

Least Privilege RBAC: Service accounts and user roles are strictly scoped using kubectl auth can-i --as= boundaries.

Network Isolation: Namespace-level NetworkPolicies prevent unauthorized cross-service pod communication.

Immutable Security Contexts: All application pods run as non-root unprivileged users with read-only root filesystems.

💥 Simulated Failure Scenarios & Recovery
Pod CrashLoopBackOff: Deployed a misconfigured container image; diagnosed root cause using kubectl describe and kubectl logs, followed by a patch fix.

Failed Deployment Rollback: Pushed a broken image tag that failed readiness checks; the CI/CD pipeline intercepted the stuck rollout and executed an automated rollback to the previous stable version.

Resource Exhaustion & HPA: Constrained pod memory limits and ran load generation tests, observing Horizontal Pod Autoscaler (HPA) scale-out behavior in real-time.

📝 What I Learned
Mastering the intricacies of Kubernetes rollout verification (kubectl rollout status) to prevent broken builds from silently staging.

Designing idempotent Ansible roles that eliminate configuration drift across infrastructure nodes.

Enforcing strict compliance boundaries using Kubernetes NetworkPolicies and Pod Security Admission standards.

🔄 What I'd Do Differently
Integrate ArgoCD for true GitOps continuous synchronization rather than imperative pipeline pushes.

Implement distributed tracing (Jaeger/Tempo) to track request latencies across asynchronous microservices.

🧹 Cleanup & Teardown
To completely purge local cluster workloads and free host resources:

Bash
kubectl delete svc --all-namespaces --all
kubectl delete pvc --all --all-namespaces
docker stop k3s-default && docker rm k3s-default
