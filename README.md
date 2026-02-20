# Support for Social Workers - Infrastructure

This repository contains the Infrastructure-as-Code (IaC) for the Support for Social Workers service. It is managed by the Department for Education (DfE).

## Overview

The purpose of this repository is to define, provision, and manage the cloud resources required to run the Support for Social Workers service. We use Terraform to ensure our environments are reproducible, version-controlled, and secure.

### Architecture

The infrastructure is hosted on Azure. Key components are:

- Compute: Microsoft Web Application
- Networking: Application Gateway, private subnets
- Security: WAF

## Project Structure

```text
.
├── acrhitecture/         # documentation
├── error-pages/          # error pages used on the site
├── kql-queries/          # example kql queries that can be used for troubleshooting
├── scripts/              # example scripts
├── terraform-app-infra/  # a terraform project to deploy all app related resources
├── terraform-core-infra/ # a terraform project to deploy core resources
├── terraform-state/      # a terraform project to create the terraform state resources
```

## Getting Started

```bash
git clone https://github.com/dfe-digital/SfSW-Infra.git
cd SfSW-Infra
```

## Security & Compliance

### Secrets Management

Never commit secrets to this repository. Use Azure Key Vault for sensitive data.

### Security Scanning

We use [insert tool] in our CI pipeline to scan for common misconfigurations.

## Licence

Unless otherwise stated, this codebase is released under the MIT License. Documentation is subject to the Open Government Licence v3.0.
