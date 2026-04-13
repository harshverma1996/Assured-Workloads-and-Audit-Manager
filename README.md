# Assured Workloads & Audit Manager Gemini CLI Extension

A Gemini CLI extension for Google Cloud Assured Workloads and Audit Manager.

## What It Does

Talk to Gemini CLI in natural language to manage your regulated cloud environments and compliance audits:
- **Assured Workloads**: Create and manage regulated environments (NIST, PCI DSS, etc.) and monitor violations.
- **Audit Manager**: Enroll resources, generate compliance reports, and analyze report findings.

## Installation

### Prerequisites

1. **Gemini CLI**
   ```bash
   npm install -g @google/gemini-cli
   ```

2. **Python 3.11+** (check with `python3 --version`)

3. **Set Quota Project**
   ```bash
   export GOOGLE_CLOUD_PROJECT="YOUR_PROJECT_ID"
   ```

4. **Google Cloud Authentication**
   ```bash
   gcloud auth application-default login
   ```

### Install

```bash
git clone https://github.com/gemini-cli-extensions/assured-workloads-and-audit-manager.git
cd assured-workloads-and-audit-manager
chmod +x install.sh
./install.sh
```

That's it! The script will:
- Create a virtual environment with Python's built-in venv
- Install dependencies using pip (no need for uv or other tools)
- Set up the extension in `~/.gemini/extensions/assured-workloads-and-audit-manager`

### Alternative: Manual Installation with pip

If you prefer to install manually or use pip directly:

```bash
# Clone the repository
git clone https://github.com/gemini-cli-extensions/assured-workloads-and-audit-manager.git
cd assured-workloads-and-audit-manager

# Create extension directory
mkdir -p ~/.gemini/extensions/assured-workloads-and-audit-manager

# Create virtual environment
python3 -m venv ~/.gemini/extensions/assured-workloads-and-audit-manager/.venv

# Install dependencies using requirements.txt
~/.gemini/extensions/assured-workloads-and-audit-manager/.venv/bin/pip install -r requirements.txt

# Copy files
cp assured_workloads_and_audit_manager_mcp.py ~/.gemini/extensions/assured-workloads-and-audit-manager/
cp GEMINI.md ~/.gemini/extensions/assured-workloads-and-audit-manager/

# Create run script and config (see install.sh for details)
```

## Usage

Start Gemini CLI and talk to it naturally:

```bash
gemini
```

### Example Conversations

**Assured Workloads:**
```
> List all Assured Workloads in us-central1

> Show violations for workload 'my-workload-id'

> Create a FedRAMP Moderate workload in us-central1
```

**Audit Manager:**
```
> Enroll project my-project in Audit Manager

> Check enrollment status for organization 123456789

> Generate a PCI DSS 4.0 audit report for project my-project

> List all audit reports in project my-project
```

The extension understands natural language - just ask what you need!

## Advanced Skills

The extension includes specialized "skills" for complex workflows. These are stored in the `skills/` directory and provide guided instructions for the AI:

- **Analyze Audit Reports**: Summarize state changes and violations across frameworks in a given audit scope.
- **Audit Helper**: Interactive guide for gathering parameters to generate audit reports.
- **Organization Policy Remediation**: Guided remediation for policy violations with impact assessment for a given assured workload violation.

To use these skills, simply ask Gemini CLI about these topics naturally!

## Requirements

### Before You Start

To use the Assured Workloads and Audit Manager tools, you must meet the following requirements:

1. **Google Cloud Organization**: You must have an active Google Cloud Organization.
2. **Billing Account**: A valid billing account must be linked to your organization.
3. **API Enablement**: Enable the following APIs:
   - Assured Workloads:
      - `assuredworkloads.googleapis.com`
      - `cloudasset.googleapis.com`
      - `orgpolicy.googleapis.com`
   - Audit Manager:
      - `auditmanager.googleapis.com`
   You can simply run:
   ```bash
      gcloud services enable \
         assuredworkloads.googleapis.com \
         cloudasset.googleapis.com \
         orgpolicy.googleapis.com \
         auditmanager.googleapis.com
   ```
4. **IAM Roles & permissions**:
   - Assured Workloads:
      - Roles: `roles/assuredworkloads.admin`, `roles/resourcemanager.organizationViewer`.
      - Permissions: `cloudasset.assets.searchAllResources`
   - Audit Manager:
      - Roles: `roles/auditmanager.admin` or `roles/auditmanager.auditor`.
   You can simply run:
   ```bash
      # Replace YOUR_ORGANIZATION_ID and YOUR_EMAIL
      gcloud organizations add-iam-policy-binding YOUR_ORGANIZATION_ID --member=user:YOUR_EMAIL --role=roles/assuredworkloads.admin
      gcloud organizations add-iam-policy-binding YOUR_ORGANIZATION_ID --member=user:YOUR_EMAIL --role=roles/resourcemanager.organizationViewer
      # `cloudasset.assets.searchAllResources` permission is included in `roles/cloudasset.viewer`.
      gcloud organizations add-iam-policy-binding YOUR_ORGANIZATION_ID --member=user:YOUR_EMAIL --role=roles/cloudasset.viewer
      gcloud organizations add-iam-policy-binding YOUR_ORGANIZATION_ID --member=user:YOUR_EMAIL --role=roles/auditmanager.admin
      # OR
      # gcloud organizations add-iam-policy-binding YOUR_ORGANIZATION_ID --member=user:YOUR_EMAIL --role=roles/auditmanager.auditor
   ```

## Troubleshooting

**Extension not loading?**
```bash
ls -la ~/.gemini/extensions/assured-workloads-and-audit-manager/
```

**Authentication issues?**
```bash
gcloud auth application-default print-access-token
```

**Need to reinstall?**
```bash
rm -rf ~/.gemini/extensions/assured-workloads-and-audit-manager
./install.sh
```

## License

Apache 2.0

## Links

- [Audit Manager Documentation](https://docs.cloud.google.com/audit-manager/docs/overview)
- [Compliance Manager Documentation](https://cloud.google.com/security-command-center/docs/compliance-manager-overview)
- [Assured Workloads Documentation](https://docs.cloud.google.com/assured-workloads/docs/overview)
- [Gemini CLI](https://github.com/google-gemini/gemini-cli)
- [gcloud] (https://docs.cloud.google.com/sdk/docs/install-sdk)

