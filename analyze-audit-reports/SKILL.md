---
name: analyze-audit-reports
description: Analyzes the last 100 audit reports for a given scope, finds the latest run per framework, and summarizes the control statues.
license: Apache-2.0
---

# Analyze Audit Reports

**MANDATORY**: Use this skill when a user asks to analyze recent audit reports or summarize control states (passing, violations, manual) across frameworks for a specific scope.

## 1. Requirement Gathering

Ensure you have the target **Scope** (Project, Folder, or Organization) to analyze. If the user hasn't provided one, ask for it.

## 2. Fetch Audit Reports

Call the `list_audit_reports` tool with the provided scope to fetch the recent audit reports. Pass 100 as page size to get the last 100 reports.

## 3. Identify Latest Runs

From the 100 fetched reports:
1. Group the reports by their compliance framework.
2. For each unique framework, identify the single most recent (latest) audit report run which will be the first one for that framework in the list.

## 4. Retrieve Detailed Reports

For each of the latest reports identified in step 3 (up to a maximum of **10** reports):
1. Call the `get_audit_report` tool using the specific report's ID.
2. Extract the violations or findings from the report details.

## 5. Compile Framework Summaries

For each of the detailed reports retrieved:
1. Identify the framework name.
2. Summarize the overall status of the controls, explicitly counting the number of:
   - Passing controls
   - Failing controls (violations)
   - Manual controls
   - Skipped controls
   - Nonauditable controls
3. Present this summary clearly to the user, grouped by framework, giving them a high-level overview of their compliance posture.
