# Glossary

Domain terms for GUS Test Generator expert.

---

## Test Management Terms

**Test Suite**
A collection of related test scenarios, typically covering one feature or user story. Stored in GUS as ADM_Test_Suite__c record.

**Test Scenario**
An individual test case with preconditions, steps, and expected results. Stored in GUS as ADM_Test_Scenario__c record.

**Test Coverage**
The extent to which test scenarios exercise different aspects of the feature (functional, integration, edge cases, performance).

**Blitz Testing**
Rapid manual testing phase where multiple team members execute test scenarios before release. Common at Salesforce after feature freeze.

---

## Test Types

**Functional Test**
Validates core feature functionality and user workflows. Focuses on "does it work as designed?" Examples: user login, record creation, data display.

**Integration Test**
Validates interactions between components, services, or systems. Examples: API calls, webhook triggers, data synchronization.

**Edge Case / Negative Test**
Validates boundary conditions, error handling, and invalid inputs. Examples: empty form submission, special characters, permission checks, max length fields.

**Performance Test**
Validates system behavior under load, scale, or time constraints. Examples: 100 concurrent users, 1M record query, page load under 2 seconds.

---

## Priority Levels

**P0 (Critical)**
Must-pass tests for core functionality. Failure blocks release. Examples: user can log in, payment processing works.

**P1 (High)**
Important tests for key features. Failure should be fixed before release but may not block in emergencies. Examples: profile editing, report generation.

**P2 (Medium)**
Standard tests for typical workflows. Failure should be fixed soon but doesn't block release. Examples: UI polish, non-critical integrations.

**P3 (Low)**
Nice-to-have tests for edge cases or rarely-used features. Failure can be addressed in future release. Examples: obscure configurations, cosmetic issues.

---

## GUS Terms

**GUS (Global User Story)**
Salesforce's work tracking system. Stores bugs, user stories, epics, sprints, test suites, and test scenarios.

**ADM_Work__c**
GUS object for work items (bugs, user stories, investigations, tasks). Identified by W-numbers (e.g., W-12345678).

**ADM_Test_Suite__c**
GUS object for test suites. Container for related test scenarios.

**ADM_Test_Scenario__c**
GUS object for individual test cases. Linked to a test suite via Test_Suite__c lookup field.

**ADM_Product_Tag__c**
GUS object for product/feature area categorization. Examples: "CPQ", "Revenue Cloud", "Industries".

**Work Item**
Generic term for ADM_Work__c records. Can be User Story, Bug, Epic, Investigation, etc.

---

## Taleggio Terms

**Taleggio**
Salesforce's centralized test management system built on GUS. Provides UI, Chrome plugin, and Agentforce integration for test case management.

**Taleggio Chrome Plugin**
Browser extension for authoring test cases in Quip and uploading to GUS.

**Taleggio Agentforce**
AI-powered test case generator that analyzes PRDs and produces test scenarios. Currently in development.

**Taleggio ID**
Test scenario identifier with T- prefix (e.g., T-1234567). Used within Taleggio system. Distinct from GUS W-numbers.

---

## Document Types

**PRD (Product Requirements Document)**
Describes what feature should do, who uses it, and why. Contains functional requirements, user workflows, and acceptance criteria.

**HLD (High-Level Design)**
Describes how feature is architected and implemented. Contains component diagrams, API specs, data models, and technical decisions.

**User Story**
Agile work item describing feature from user perspective. Format: "As a [role], I want [goal], so that [benefit]".

---

## Salesforce CLI Terms

**sf CLI**
Official Salesforce command-line interface. Used for SOQL queries, DML operations, org authentication, and metadata deployment.

**Target Org**
Salesforce org specified via `--target-org` flag. For GUS operations, use `--target-org gus`.

**SOQL (Salesforce Object Query Language)**
SQL-like language for querying Salesforce records. Example: `SELECT Id, Name FROM ADM_Work__c WHERE Name = 'W-12345678'`.

**DML (Data Manipulation Language)**
Operations that modify Salesforce records: create, update, delete.

---

## HTML Terms (for GUS Rich Text Fields)

**Rich Text Area**
Salesforce field type that stores and renders HTML. Used for Preconditions__c and Test_Steps__c in ADM_Test_Scenario__c.

**Ordered List (`<ol>`)**
HTML element for numbered lists. Used for test steps to show execution sequence.

**Unordered List (`<ul>`)**
HTML element for bulleted lists. Used for preconditions.

**List Item (`<li>`)**
HTML element for individual list items. Nested within `<ol>` or `<ul>`.

---

## Test Execution Terms

**Manual Test**
Test executed by human tester following written test steps. Not automated.

**Automatable Test**
Test that could be automated (has clear steps, deterministic outcomes) but hasn't been automated yet.

**Automated Test**
Test executed by automated test framework (Selenium, Playwright, etc.) without human intervention.

**Test Run**
Single execution of a test suite. Can result in pass, fail, or blocked for each scenario.

**Execution Status**
Current state of test scenario: Not Started, In Progress, Passed, Failed, Blocked.

---

## Coverage Metrics

**Functional Coverage**
Percentage of functional requirements that have test scenarios. Target: 100% of stated requirements.

**Code Coverage**
Percentage of code executed by automated tests. Different from test scenario coverage (not directly tracked in Taleggio).

**Escape Defect**
Bug found in production that wasn't caught during testing. Often indicates missing test scenario coverage.

---

## Workflow Terms

**Feature Freeze**
Point in release cycle when no new features are added. Focus shifts to testing and bug fixing.

**QA Phase**
Testing phase after development is complete. QA engineers execute test scenarios and report bugs.

**Sign-Off**
Formal approval that feature meets requirements and is ready for release. Based on test execution results.

**Regression Testing**
Re-executing test scenarios after code changes to ensure existing functionality still works.
