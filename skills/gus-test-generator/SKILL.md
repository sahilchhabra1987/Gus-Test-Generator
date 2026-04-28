---
name: gus-test-generator
description: Generate comprehensive test cases from PRD/HLD and upload to GUS Taleggio. Covers test suite creation, scenario generation (functional, integration, edge, performance), GUS field mapping, and sf CLI upload. Not for manual test execution or test result tracking.
---

# GUS Test Generator

> Generate comprehensive test suites from PRD/HLD documents and upload to GUS Taleggio with proper field mapping and coverage

## Scope

**This expert handles:**
- Collecting PRD/HLD inputs and generating test scenarios
- Ensuring comprehensive coverage (functional, integration, edge cases, performance)
- Formatting test cases for GUS ADM_Test_Suite__c and ADM_Test_Scenario__c
- Uploading test suites via Salesforce CLI to GUS
- Linking test suites to work items

**NOT for:**
- Manual test execution or tracking test results (use GUS Taleggio UI)
- Automated test script generation (use appropriate test framework expert)
- Test plan review or approval workflows (use standard GUS workflow)
- Unit test or integration test code generation (use code generation tools)

## Critical Rules

| Rule | Consequence of Violation |
|------|--------------------------|
| **MUST collect PRD and product tag before generating** | WHY: Test scenarios must be grounded in actual requirements and tagged correctly in GUS |
| **MUST generate at least 15 scenarios covering all 4 test types** | WHY: Incomplete coverage leads to missed bugs and escape defects |
| **MUST format preconditions as HTML `<ul>` and steps as HTML `<ol>`** | WHY: GUS Taleggio renders these fields as HTML; plain text breaks formatting |
| **MUST verify sf CLI authentication before upload** | WHY: Upload will fail silently if not authenticated to GUS org |
| **MUST show preview before creating records in GUS** | WHY: GUS records are difficult to bulk-delete; preview prevents mistakes |

## Routing — situation → response

**"Generate test cases for this PRD"** → use [Test Generation Workflow](guides/workflow.md). Collect inputs, generate comprehensive scenarios, show preview.

**"Upload test suite to GUS"** or **"Create test cases in GUS"** → use [GUS Integration Guide](guides/gus-integration.md). Verify CLI auth, format fields, upload via sf data create.

**"How do I structure test scenarios?"** or **"What test types should I include?"** → use [Test Generation Workflow](guides/workflow.md) — explains coverage requirements.

**"Link test suite to work item W-#######"** → use [GUS Integration Guide](guides/gus-integration.md) — explains Work_Item__c field mapping.

**"What GUS fields do I need?"** or **"How do I format for Taleggio?"** → use [GUS Integration Guide](guides/gus-integration.md) — lists all ADM_Test_Scenario__c fields.

## Guides

| Guide | Purpose |
|-------|---------|
| [Test Generation Workflow](guides/workflow.md) | Step-by-step process: collect inputs → generate scenarios → preview → upload |
| [GUS Integration Guide](guides/gus-integration.md) | GUS object schema, field mappings, sf CLI commands, HTML formatting rules |

## Quick Start

1. **Collect inputs**: PRD (required), HLD (optional), product tag (required), work item (optional)
2. **Generate test suite**: Create 15-25 scenarios across functional, integration, edge cases, performance
3. **Preview**: Show formatted test suite with all scenarios
4. **Verify GUS auth**: Check `sf data query --target-org gus --query "SELECT Id FROM User LIMIT 1"`
5. **Upload**: Create ADM_Test_Suite__c, then ADM_Test_Scenario__c records
6. **Confirm**: Provide GUS URL to view test suite
