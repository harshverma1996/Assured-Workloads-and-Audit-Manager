# Usage Guide: Assured Workloads & Audit Manager Gemini Extension

This guide covers how to use natural language to manage regulated cloud environments, run compliance audits, and deploy security frameworks via the Gemini CLI.

*(Note: Before using these commands, ensure you have completed the setup and authentication steps in the README).*

---

## 1. Conversational Basics & Getting Help

### General Compliance & Discovery
```text
Help me understand what compliance frameworks are available

What's the difference between CIS and FedRAMP?

What frameworks are recommended for financial services?

Show me the current compliance posture of my organization

I need to ensure my project meets NIST compliance requirements
```

### Getting Setup Help
```text
What do I need to get started with Compliance Manager?

How do I enable Compliance Manager?

How do I find my organization ID?

Can you explain what Security Command Center Enterprise is?

I'm getting permission denied errors, what should I do?
```

---

## 2. Compliance Frameworks & Controls

You can explore, create, and deploy compliance frameworks across your environment. *(Note: Replace `[ORGANIZATION_ID]` and `[PROJECT_ID]` with your actual IDs).*

### Exploring Frameworks & Controls
```text
List all compliance frameworks in organization [ORGANIZATION_ID]

Show me both built-in and custom frameworks

Show me details of the CIS framework

Tell me about the NIST framework

What cloud controls are available in my organization?

Show me all cloud controls (built-in and custom)

List only custom cloud controls
```

### Creating Custom Frameworks
```text
Create a custom framework called "company-baseline" using CIS and NIST controls

Build a framework with controls for PCI DSS compliance

I want to create a framework combining built-in controls for data protection

Create a framework called "eu-data-residency" with custom controls for EU compliance

Build a custom framework for financial services with specific controls

Create a framework that includes both built-in and my custom controls
```

### Deploying Frameworks
```text
Deploy the NIST framework to project [PROJECT_ID]

I want to deploy CIS to my production project

How do I deploy compliance controls to a folder?

What frameworks are currently deployed?

Show me all framework deployments in organization [ORGANIZATION_ID]

What's the status of my compliance deployments?

Show me deployment details for the CIS framework

Remove the NIST framework deployment from project [PROJECT_ID]
```

---

## 3. Managing Assured Workloads

Assured Workloads help automatically enforce compliance requirements (like HIPAA, FedRAMP, or CJIS) on your Google Cloud resources. Note: Workload creation is a long-running operation and might take several minutes to complete.

### Listing & Creating Workloads
```text
List all Assured Workloads in organization [ORGANIZATION_ID] for region us-central1

Show me workloads in region europe-west1

Create a new Assured Workload for FedRAMP Moderate in us-central1 with name "fedramp-workload" and billing account "billingAccounts/012345-567890-ABCDEF"

I want to create a CJIS workload in us-east1
```

### Updating & Deleting Workloads
```text
Change the display name of workload "my-workload-id" to "production-workload" in us-central1

Update the labels for workload "workload-123" in europe-west1 to include "env=prod"

Restrict allowed resources for workload "workload-id" in us-central1 to "ALLOW_COMPLIANT_RESOURCES"

Delete the Assured Workload "workload-id" in us-central1
```

### Managing Violations
```text
List all violations for workload "workload-id" in us-central1

Show me violations for my workload in europe-west1

Tell me more about violation "violation-id" for workload "workload-id" in us-central1

Acknowledge violation "violation-id" for workload "workload-id" in us-central1 with comment "Authorized exception by security team"
```

---

## 4. Audit Manager

Audit Manager simplifies your compliance process by allowing you to run automated audits against built-in and custom frameworks.

### Working with Audit Manager
```text
Enroll project [PROJECT_ID] in Audit Manager

Check enrollment status for organization [ORGANIZATION_ID]

Generate a PCI DSS 4.0 audit report for project [PROJECT_ID]

List all audit reports in my project
```

### Built-in AI Skills
The extension includes interactive workflows for complex tasks. Prompt Gemini naturally to trigger them:
```text
Summarize the state changes and violations across frameworks in my latest audit report

Help me gather the parameters I need to generate an audit report

Guide me through fixing the policy violations in my Assured Workload
```

---

## 5. Creating Custom Cloud Controls (CEL)

If built-in frameworks do not meet your exact requirements, you can instruct Gemini to create custom cloud controls using **CEL (Common Expression Language)**.

### Asking Gemini to Generate Controls
You can describe the rule you want in natural language. Here are examples by resource type:

**Compute Engine**
```text
Create a cloud control to ensure all VMs have Secure Boot enabled

I need a control to check if Compute Engine instances use custom service accounts

Create a control to verify all VM disks are encrypted with customer-managed keys

Make a control to check if VMs follow our naming convention: gcp-vm-prod-*
```

**Cloud Storage**
```text
Create a cloud control to check if Cloud Storage buckets have public access prevention enforced

I need a control to verify all buckets have versioning enabled

Create a control to ensure buckets are not publicly accessible

Make a control to check if buckets use customer-managed encryption keys
```

**Cloud SQL**
```text
Create a cloud control to ensure Cloud SQL instances don't have public IP addresses

I need a control to check if Cloud SQL instances have automated backups enabled

Create a control to verify SSL/TLS is required for Cloud SQL connections

Make a control to check if Cloud SQL instances are in high-availability configuration
```

**Cloud KMS**
```text
Create a cloud control to ensure KMS keys are rotated every 90 days or less

I need a control to check if KMS keys have destruction scheduled

Create a control to verify KMS keys are in specific regions only
```

**Networking & IAM**
```text
Create a cloud control to check if VPC networks have flow logs enabled

I need a control to verify firewall rules don't allow 0.0.0.0/0 ingress on sensitive ports

Create a cloud control to check if service accounts have key rotation policies

Make a control to check if service accounts follow naming conventions
```

### Writing CEL Syntax Manually
If you are passing your own CEL expressions to Gemini, ensure you follow these rules:

1. **Triggering Findings:** The expression must return **FALSE** to trigger a finding (meaning the resource is non-compliant).
2. **Always Check Existence:** Use `has()` to check if a field exists before evaluating it to prevent execution errors.
3. **Strings for Enums:** All enums must be formatted as strings.

#### Examples of valid CEL expressions:

**Check if a field exists and has a specific value:**
```cel
has(resource.data.shieldedInstanceConfig) && resource.data.shieldedInstanceConfig.enableSecureBoot
```

**Check duration/time periods (90 days = 7776000 seconds):**
```cel
has(resource.data.rotationPeriod) && resource.data.rotationPeriod <= duration('7776000s')
```

**Pattern matching with regex & substring:**
```cel
resource.data.name.matches('^gcp-vm-(prod|staging)-v\\d+$')
resource.data.projectId.contains('production')
```

**Combine multiple conditions:**
```cel
resource.data.state == 'ENABLED' && !(resource.data.name.matches('approved-api.googleapis.com'))
```

#### Common Mistakes to Avoid:

❌ **Don't forget `has()` checks:**
```cel
resource.data.encryptionKey.kmsKeyName != '' // May fail if encryptionKey doesn't exist
```

✅ **Always check existence first:**
```cel
has(resource.data.encryptionKey) && resource.data.encryptionKey.kmsKeyName != ''
```

❌ **Don't use enum values without quotes:**
```cel
resource.data.state == ENABLED // Wrong!
```

✅ **Use string values for enums:**
```cel
resource.data.state == 'ENABLED' // Correct!
```

---

## 6. Troubleshooting Common Issues

If you encounter unexpected behavior, check the following common issues:

* **"Compliance Manager is not enabled" or "No frameworks found"**
  The required APIs likely have not been enabled in your organization. Ask Gemini: *"How do I enable Compliance Manager?"* or refer to the API setup section in the README.

* **"Permission Denied" Errors**
  Ensure your Google Cloud credentials have not expired and you possess the correct IAM roles. Refresh your login via your terminal:
  ```bash
  gcloud auth application-default login
  ```
  *(You can also ask Gemini: "What permissions do I need for Compliance Manager?")*

* **Command Not Understood**
  Ensure you are providing sufficient context. For example, instead of just saying *"Deploy NIST"*, say *"Deploy the NIST framework to project [PROJECT_ID]"*.

## 7. 💡 Tips for Best Results

1. **Use Natural Language:** The CLI interprets conversational prompts. There is no need for rigid terminal syntax; simply formulate your operational requests clearly and directly.
2. **Provide Explicit Context:** Ensure your prompts include necessary identifiers—such as Organization ID, Project ID, Region, or Workload ID—to guarantee accurate execution against the correct resources.
3. **Leverage AI for Guidance:** Beyond executing commands, you can prompt the AI to clarify complex compliance concepts, compare security frameworks, or provide step-by-step configuration workflows.
4. **Adopt a Read-First Approach:** When managing unfamiliar environments, begin with exploratory queries (e.g., listing active frameworks or workloads) to assess current states before executing structural changes (e.g., deploying controls or creating workloads).
5. **Verify Environment Prerequisites:** Confirm that foundational Google Cloud services (such as the Compliance Manager, Assured Workloads, and Audit Manager APIs) are fully enabled and properly permitted in your organization before initiating deployment commands.
