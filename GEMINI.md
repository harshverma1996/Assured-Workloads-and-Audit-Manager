# Assured Workloads & Audit Manager Extension for Gemini CLI

This extension provides integration with Google Cloud Assured Workloads and Audit Manager.

## Purpose

The Assured Workloads & Audit Manager extension enables you to:
- **Manage Assured Workloads**: Create and manage regulated environments (FedRAMP, IL4/5, CJIS, etc.) and monitor violations.
- **Manage Compliance Audits**: Enroll resources in Audit Manager, generate compliance reports, and analyze report findings.

## Available Tools

### Framework Management
- `@assured-workloads-and-audit-manager-mcp list_frameworks` - List all available compliance frameworks for assured workloads and audit manager (built-in and custom)
- `@assured-workloads-and-audit-manager-mcp get_framework` - Get detailed information about a specific framework
- `@assured-workloads-and-audit-manager-mcp create_framework` - Create a custom compliance framework
- `@assured-workloads-and-audit-manager-mcp delete_framework` - Delete a custom framework

### Cloud Control Management
- `@assured-workloads-and-audit-manager-mcp list_cloud_controls` - List all cloud controls (built-in and custom)
- `@assured-workloads-and-audit-manager-mcp get_cloud_control` - Get detailed information about a specific cloud control
- `@assured-workloads-and-audit-manager-mcp create_cloud_control` - Create a custom cloud control
- `@assured-workloads-and-audit-manager-mcp update_cloud_control` - Update a custom cloud control
- `@assured-workloads-and-audit-manager-mcp delete_cloud_control` - Delete a custom cloud control

### Framework Deployment
- `@assured-workloads-and-audit-manager-mcp list_framework_deployments` - List framework deployments
- `@assured-workloads-and-audit-manager-mcp get_framework_deployment` - Get details of a specific deployment
- `@assured-workloads-and-audit-manager-mcp create_framework_deployment` - Deploy a framework to a resource
- `@assured-workloads-and-audit-manager-mcp delete_framework_deployment` - Remove a framework deployment

### Cloud Control Deployment
- `@assured-workloads-and-audit-manager-mcp list_cloud_control_deployments` - List cloud control deployments
- `@assured-workloads-and-audit-manager-mcp get_cloud_control_deployment` - Get details of a specific cloud control deployment

### Assured Workloads Management
- `@assured-workloads-and-audit-manager-mcp create_workload` - Create a new Assured Workload
- `@assured-workloads-and-audit-manager-mcp update_workload` - Update an existing Assured Workload
- `@assured-workloads-and-audit-manager-mcp restrict_allowed_resources` - Restrict allowed resources for a workload
- `@assured-workloads-and-audit-manager-mcp delete_workload` - Delete a workload
- `@assured-workloads-and-audit-manager-mcp get_workload` - Get workload details
- `@assured-workloads-and-audit-manager-mcp list_workloads` - List workloads
- `@assured-workloads-and-audit-manager-mcp list_violations` - List violations for a workload
- `@assured-workloads-and-audit-manager-mcp get_violation` - Get violation details
- `@assured-workloads-and-audit-manager-mcp acknowledge_violation` - Acknowledge a violation

### Audit Manager Management
- `@assured-workloads-and-audit-manager-mcp enroll_resource` - Enroll a resource in Audit Manager
- `@assured-workloads-and-audit-manager-mcp get_resource_enrollment_status` - Get enrollment status
- `@assured-workloads-and-audit-manager-mcp list_resource_enrollment_statuses` - List enrollment statuses
- `@assured-workloads-and-audit-manager-mcp generate_audit_scope_report` - Generate an audit scope report
- `@assured-workloads-and-audit-manager-mcp generate_audit_report` - Generate a full audit report
- `@assured-workloads-and-audit-manager-mcp list_audit_reports` - List audit reports
- `@assured-workloads-and-audit-manager-mcp get_audit_report` - Get details of a specific audit report

## Example Prompts

### Discovery
- "List all available compliance frameworks for organization 123456789012"
- "Show me details of the CIS framework"
- "What cloud controls are available in my organization?"
- "Show me both built-in and custom cloud controls"
- "List all custom frameworks I've created"

### Creating Custom Controls and Frameworks
- "Create a custom cloud control called 'require-encryption' that checks for encryption"
- "I want to create a custom framework for my company's security policies"
- "Add the CIS and NIST cloud controls to a new custom framework"
- "Create a cloud control to check for public bucket access"
- "Build a custom framework with controls for data residency requirements"

### Deployment
- "Deploy the NIST framework to my project"
- "Show me all framework deployments in my organization"
- "Create a deployment of the FedRAMP framework to folder 987654321"
- "Deploy my custom framework to project my-prod-project"

### Monitoring
- "What frameworks are currently deployed to my project?"
- "Show me the status of all cloud control deployments"
- "Get details of the CIS framework deployment"

### Audit Management
- "Enroll project my-prod-project in Audit Manager"
- "Check enrollment status for organization 123456789"
- "Generate an audit scope report for project my-proj using FEDRAMP_MODERATE"
    *   **Note:** For audit report generation, ALWAYS use the `run-audit-helper` skill to ensure all parameters (Scope, Framework, Bucket) are correctly identified.
- "Analyze the recent audit reports for project my-proj to find top violations"
    *   **Note:** To analyze recent audit reports in a folder, org or project scope and find the most frequent violations, ALWAYS use the `analyze-audit-reports` skill.
- "List all audit reports in folder 987654"
- "Get details of audit report report-id-123"

### Assured Workloads

- "List all Assured Workloads in us-central1 for organization 123"
- "Create a new FedRAMP Moderate workload in us-central1"
- "Show me violations for workload 'workload-id'"
- "Acknowledge violation 'violation-id' for workload 'workload-id' with comment 'Exception approved'"

## Prerequisites

### Compliance and Audit Manager Prerequisites

#### 1. Enable Compliance Manager

Before using this extension, you must enable Compliance Manager in your Google Cloud organization:

**Requirements:**
- Security Command Center Enterprise tier (required for Compliance Manager)
- Organization-level access
- IAM permissions to enable services

**Steps to Enable:**

1. **Enable Security Command Center Enterprise** (if not already enabled):
   - Go to the [Security Command Center page](https://console.cloud.google.com/security/command-center)
   - Select your organization
   - Enable Security Command Center Enterprise tier

2. **Enable Compliance Manager**:
   - Navigate to [Compliance Manager](https://console.cloud.google.com/security/compliance-manager)
   - Select your organization
   - Click "Enable Compliance Manager"
   - Accept the terms of service

3. **Verify Enablement**:
   - You should see available compliance frameworks
   - The Compliance Manager dashboard should be accessible

**Alternative: Enable via gcloud CLI**:
```bash
# Enable Security Command Center API
gcloud services enable securitycenter.googleapis.com --project=YOUR_PROJECT_ID

# Note: Compliance Manager enablement requires Enterprise tier
# This must be done through the Console or contact Google Cloud Sales
```

**Troubleshooting Enablement:**
- If you don't see the option to enable, you may need Security Command Center Enterprise
- Contact your Google Cloud account team to upgrade to Enterprise tier
- Ensure you have `roles/securitycenter.admin` or organization admin permissions

For detailed instructions, see: https://cloud.google.com/security-command-center/docs/compliance-manager-enable

#### 2. Authentication

Ensure you have Google Cloud credentials configured:
- Run `gcloud auth application-default login`, OR
- Set `GOOGLE_APPLICATION_CREDENTIALS` environment variable

#### 3. IAM Permissions

You need appropriate permissions:
- `roles/securitycenter.complianceManager` or `roles/securitycenter.adminEditor` for full access
- `roles/securitycenter.adminViewer` for read-only operations

#### 4. Organization ID

Know your Google Cloud organization ID (numeric, e.g., '123456789012')

### Assured Workloads Prerequisites

To use the Assured Workloads tools, you must meet the following requirements:

#### 1. Google Cloud Organization
You must have an active Google Cloud Organization (cannot be used with standalone projects).

#### 2. Billing Account
A valid billing account must be linked to your organization.

#### 3. API Enablement
- Enable `assuredworkloads.googleapis.com` (Main API).
- Enable APIs for individual services (e.g., `compute.googleapis.com`) inside the workload folder.

#### 4. IAM Roles
- `roles/assuredworkloads.admin` (Assured Workloads Admin)
- `roles/axt.admin` (Access Transparency Admin)
- `roles/resourcemanager.organizationViewer` (Organization Viewer)

## Workflows

### Running an Audit Report
When a user wants to generate an audit report, verify they specify:
- Scope (Project/Folder/Org)
- Standard (e.g. NIST_800_53_R4)
- Destination GCS bucket

If missing, prompt for them.

## Skills

Skills are specialized prompts and instructions for complex tasks. They are located in the `skills/` directory.

### Available Skills

- **analyze-audit-reports**: Summarize control states and analyze violations across frameworks.
- **run-audit-helper**: Guide users through generating audit reports, ensuring all parameters are gathered.
- **org-policy-remediation**: Safely fix organization policy violations by presenting scope and impact before proceeding.
