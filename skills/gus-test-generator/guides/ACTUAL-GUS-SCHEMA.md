# ACTUAL GUS Schema Reference

**Last Updated:** 2026-04-28  
**Verified Against:** Production GUS org

This document contains the **actual, verified GUS object schema** discovered through testing. Use this as the authoritative reference.

---

## ⚠️ Key Differences from Expected Schema

| What You Expect | What Actually Exists | Solution |
|----------------|---------------------|----------|
| `Name` field is writable | `Name` is auto-generated (TS-#######) | Use `Suite_Name__c` instead |
| Direct `Test_Suite__c` lookup on scenarios | No direct relationship exists | Use `ADM_Related_Test_Scenario__c` junction object |
| `Title__c` on test scenarios | Field does not exist | Use `Test_Name__c` instead |
| `Description__c` on test scenarios | Field does not exist | Use `Test_Details__c` instead |
| Separate `Preconditions__c`, `Test_Steps__c` fields | Fields do not exist | Combine all in `Test_Details__c` with HTML |
| `Team__c` is optional | `Team__c` is REQUIRED | Must query ADM_Scrum_Team__c first |

---

## ADM_Test_Suite__c Schema

### Required Fields
```json
{
  "Team__c": "a00xxxxxxxxxxxxx"  // REQUIRED - ADM_Scrum_Team__c ID
}
```

### Commonly Used Fields
```json
{
  "Suite_Name__c": "User Profile Picture Upload Test Suite",
  "Description__c": "Comprehensive test coverage for...",
  "Team__c": "a00B0000000w1FFIAY"
}
```

### Auto-Generated (Read-Only)
- `Name` - Auto-generated as "TS-#######"
- `Total_Test_Scenarios__c` - Auto-calculated

### Example Creation Command
```bash
sf data create record --target-org gus \
  --sobject ADM_Test_Suite__c \
  --values "Suite_Name__c='My Test Suite' \
Description__c='Suite description' \
Team__c='a00B0000000w1FFIAY'" \
  --json
```

---

## ADM_Test_Scenario__c Schema

### Required Fields
```json
{
  "Test_Name__c": "TS-001: Scenario title",
  "Product_Tag__c": "a1aEE000002H2InYAK",  // REQUIRED
  "Execution_Type__c": "Manual",            // REQUIRED: Manual|Automated|Cannot be automated
  "Regression__c": true,                    // REQUIRED: boolean
  "Obsolete__c": false                      // REQUIRED: boolean
}
```

### Commonly Used Fields
```json
{
  "Test_Name__c": "TS-001: User successfully uploads profile picture",
  "Test_Details__c": "<p><strong>Description:</strong>...</p><ul><li>...</li></ul>",  // SUPPORTS HTML
  "Expected_Results__c": "User successfully uploads image...",
  "Priority__c": "P0",                      // P0|P1|P2|P3
  "Product_Tag__c": "a1aEE000002H2InYAK",
  "Execution_Type__c": "Manual",
  "Regression__c": true,
  "Obsolete__c": false,
  "Scrum_Team__c": "a00B0000000w1FFIAY"
}
```

### Auto-Generated (Read-Only)
- `Name` - Auto-generated as "T-#######"

### Example Creation Command
```bash
sf data create record --target-org gus \
  --sobject ADM_Test_Scenario__c \
  --values "Test_Name__c='TS-001: Title' \
Product_Tag__c='a1aEE000002H2InYAK' \
Execution_Type__c='Manual' \
Regression__c=true \
Obsolete__c=false \
Test_Details__c='<p>Description here</p>'" \
  --json
```

---

## ADM_Related_Test_Scenario__c (Junction Object)

**Purpose:** Links test scenarios to test suites in a many-to-many relationship.

### Required Fields
```json
{
  "Test_Suite__c": "a81xxxxxxxxxxxxx",    // ADM_Test_Suite__c ID
  "Test_Scenario__c": "a80xxxxxxxxxxxxx"   // ADM_Test_Scenario__c ID
}
```

### Example Creation Command
```bash
sf data create record --target-org gus \
  --sobject ADM_Related_Test_Scenario__c \
  --values "Test_Suite__c='a81EE000005LBbtYAG' \
Test_Scenario__c='a80EE000006kGUXYA2'" \
  --json
```

### Verification Query
```bash
sf data query --target-org gus \
  --query "SELECT Id, Name, Suite_Name__c, \
(SELECT Test_Scenario__r.Name, Test_Scenario__r.Test_Name__c \
FROM Test_Suite_Associations__r) \
FROM ADM_Test_Suite__c WHERE Id = 'a81xxxxxxxxxxxxx'" \
  --json
```

---

## HTML Formatting in Test_Details__c

⚠️ **CRITICAL:** The `Test_Details__c` field renders HTML. Plain text will display as one unformatted paragraph.

### Recommended HTML Structure

```html
<p><strong>Description:</strong> Brief description of what this test validates.</p>

<p><strong>Preconditions:</strong></p>
<ul>
<li>User is authenticated and logged in</li>
<li>User is on profile settings page</li>
<li>Valid test data is available</li>
</ul>

<p><strong>Test Steps:</strong></p>
<ol>
<li><strong>Action:</strong> Click the button<br/><strong>Expected:</strong> Dialog opens</li>
<li><strong>Action:</strong> Enter valid data<br/><strong>Expected:</strong> Data is accepted</li>
<li><strong>Action:</strong> Click Save<br/><strong>Expected:</strong> Record is saved successfully</li>
</ol>

<p><strong>Test Data:</strong> username@example.com, password: Test123!</p>
<p><strong>Estimated Time:</strong> 5 minutes</p>
<p><strong>Tags:</strong> functional, happy-path, core-feature</p>
```

### Python Template for Generation

```python
def format_test_details_html(scenario):
    """Format test scenario as HTML for Test_Details__c field."""
    
    html = f"<p><strong>Description:</strong> {scenario['description']}</p>\n\n"
    
    # Preconditions
    if scenario.get('preconditions'):
        html += "<p><strong>Preconditions:</strong></p>\n<ul>\n"
        for precond in scenario['preconditions']:
            html += f"<li>{precond}</li>\n"
        html += "</ul>\n\n"
    
    # Test Steps
    if scenario.get('test_steps'):
        html += "<p><strong>Test Steps:</strong></p>\n<ol>\n"
        for step in scenario['test_steps']:
            html += f"<li><strong>Action:</strong> {step['action']}<br/>"
            html += f"<strong>Expected:</strong> {step['expected']}</li>\n"
        html += "</ol>\n\n"
    
    # Additional Info
    if scenario.get('test_data'):
        html += f"<p><strong>Test Data:</strong> {scenario['test_data']}</p>\n"
    if scenario.get('estimated_time'):
        html += f"<p><strong>Estimated Time:</strong> {scenario['estimated_time']}</p>\n"
    if scenario.get('tags'):
        tags = ', '.join(scenario['tags'])
        html += f"<p><strong>Tags:</strong> {tags}</p>\n"
    
    return html
```

---

## Complete Upload Workflow

### Step 1: Find Required IDs

```bash
# Find Scrum Team
sf data query --target-org gus \
  --query "SELECT Id, Name FROM ADM_Scrum_Team__c WHERE Name LIKE '%Platform%' LIMIT 10" \
  --json

# Find Product Tag
sf data query --target-org gus \
  --query "SELECT Id, Name FROM ADM_Product_Tag__c WHERE Name LIKE '%Authentication%' LIMIT 10" \
  --json
```

### Step 2: Create Test Suite

```bash
sf data create record --target-org gus \
  --sobject ADM_Test_Suite__c \
  --values "Suite_Name__c='Password Reset Flow Test Suite' \
Description__c='Test coverage for password reset' \
Team__c='a00AH000000imYDYAY'" \
  --json

# Save the returned ID: a81xxxxxxxxxxxxx
```

### Step 3: Create Test Scenario

```bash
sf data create record --target-org gus \
  --sobject ADM_Test_Scenario__c \
  --values "Test_Name__c='TS-001: User resets password successfully' \
Product_Tag__c='a1aB000000006quIAA' \
Execution_Type__c='Manual' \
Regression__c=true \
Obsolete__c=false \
Priority__c='P0' \
Test_Details__c='<p><strong>Description:</strong> Test password reset flow</p><ul><li>User is logged out</li></ul><ol><li><strong>Action:</strong> Click Forgot Password<br/><strong>Expected:</strong> Form displays</li></ol>' \
Expected_Results__c='Password reset successfully'" \
  --json

# Save the returned ID: a80xxxxxxxxxxxxx
```

### Step 4: Link Scenario to Suite

```bash
sf data create record --target-org gus \
  --sobject ADM_Related_Test_Scenario__c \
  --values "Test_Suite__c='a81xxxxxxxxxxxxx' \
Test_Scenario__c='a80xxxxxxxxxxxxx'" \
  --json
```

### Step 5: Verify

```bash
sf data query --target-org gus \
  --query "SELECT Id, Name, Suite_Name__c, \
(SELECT Test_Scenario__r.Name, Test_Scenario__r.Test_Name__c FROM Test_Suite_Associations__r) \
FROM ADM_Test_Suite__c WHERE Id = 'a81xxxxxxxxxxxxx'" \
  --json
```

---

## Common Errors and Solutions

### Error: "Required fields are missing: [Team__c]"
**Solution:** Must provide Team__c when creating test suite. Query ADM_Scrum_Team__c first.

### Error: "No such column 'Test_Suite__c' on ADM_Test_Scenario__c"
**Solution:** Don't try to set Test_Suite__c directly. Use ADM_Related_Test_Scenario__c junction object after creating both records.

### Error: "No such column 'Description__c' on ADM_Test_Scenario__c"
**Solution:** Use `Test_Details__c` instead of `Description__c`.

### Error: "No such column 'Title__c' on ADM_Test_Scenario__c"
**Solution:** Use `Test_Name__c` instead of `Title__c`.

### Test Details Display as One Long Paragraph
**Solution:** Use HTML formatting in `Test_Details__c` field (see HTML section above).

### Error: "INVALID_FIELD_FOR_INSERT_UPDATE: Name"
**Solution:** Don't try to set the `Name` field - it's auto-generated. Use `Suite_Name__c` for suites or `Test_Name__c` for scenarios.

---

## Quick Reference Card

```
TEST SUITE CREATION
===================
Object: ADM_Test_Suite__c
Required: Team__c
Title Field: Suite_Name__c (NOT Name)
Auto-Generated: Name (TS-#######)

TEST SCENARIO CREATION
======================
Object: ADM_Test_Scenario__c
Required: Test_Name__c, Product_Tag__c, Execution_Type__c, Regression__c, Obsolete__c
Title Field: Test_Name__c (NOT Title__c)
Description Field: Test_Details__c (NOT Description__c) - USE HTML!
Auto-Generated: Name (T-#######)

LINKING SCENARIOS TO SUITES
============================
Object: ADM_Related_Test_Scenario__c
Required: Test_Suite__c, Test_Scenario__c
Create AFTER both suite and scenario exist

VERIFICATION
============
Query: SELECT Id, (SELECT Test_Scenario__r.Name FROM Test_Suite_Associations__r) FROM ADM_Test_Suite__c WHERE Id = 'xxx'
```
