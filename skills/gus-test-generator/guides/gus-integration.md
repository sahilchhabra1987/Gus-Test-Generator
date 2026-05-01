# GUS Integration Guide

Technical reference for uploading test suites and scenarios to GUS Taleggio using Salesforce CLI.

---

## GUS Objects

### ADM_Test_Suite__c
Container for related test scenarios.

**Key Fields:**
| Field API Name | Type | Required | Max Length | Description |
|----------------|------|----------|------------|-------------|
| `Name` | Text | Yes | 80 | Test suite name (auto-truncated if longer) |
| `Description__c` | Long Text Area | No | 32,768 | Suite description and scope |
| `Product_Tag__c` | Lookup | No | - | Link to ADM_Product_Tag__c record |
| `Work_Item__c` | Lookup | No | - | Link to ADM_Work__c (User Story, Epic, etc.) |
| `Total_Test_Scenarios__c` | Number | No | - | Count of scenarios in suite |
| `Status__c` | Picklist | No | - | Draft, Ready for Review, Approved, etc. |
| `Created_By__c` | Lookup | Auto | - | User who created suite |
| `Created_Date__c` | DateTime | Auto | - | Creation timestamp |

### ADM_Test_Scenario__c
Individual test case within a suite.

**Key Fields:**
| Field API Name | Type | Required | Max Length | Description |
|----------------|------|----------|------------|-------------|
| `Name` | Text | Yes | 80 | Scenario ID (TS-001, TS-002, etc.) |
| `Test_Suite__c` | Lookup | Yes | - | Parent ADM_Test_Suite__c record |
| `Title__c` | Text | Yes | 255 | Scenario title (concise description) |
| `Description__c` | Long Text Area | No | 32,768 | Detailed test objective |
| `Priority__c` | Picklist | Yes | - | P0, P1, P2, P3 |
| `Type__c` | Picklist | Yes | - | Functional, Integration, Edge Case, Performance |
| `Preconditions__c` | Rich Text Area | No | 32,768 | HTML formatted list of preconditions |
| `Test_Steps__c` | Rich Text Area | Yes | 32,768 | HTML formatted ordered list of steps |
| `Expected_Results__c` | Long Text Area | No | 32,768 | Overall expected outcome (optional if in steps) |
| `Test_Data__c` | Long Text Area | No | 32,768 | Sample data needed for test |
| `Execution_Type__c` | Picklist | No | - | Manual, Automatable, Automated |
| `Estimated_Time__c` | Text | No | 50 | "5 minutes", "30 minutes", etc. |
| `Tags__c` | Text | No | 255 | Comma-separated tags for filtering |
| `Status__c` | Picklist | No | - | Not Started, In Progress, Passed, Failed, Blocked |

---

## HTML Formatting Rules

GUS Taleggio renders `Preconditions__c` and `Test_Steps__c` as HTML. **Always format as HTML lists.**

### Preconditions: Unordered List

**Format:**
```html
<ul>
  <li>User is authenticated as admin</li>
  <li>Test data is seeded in sandbox org</li>
  <li>Feature flag XYZ is enabled</li>
</ul>
```

**Generation pattern:**
```python
preconditions = ["User is authenticated", "Test data exists", "Feature enabled"]
html = "<ul>\n"
for pre in preconditions:
    html += f"  <li>{pre}</li>\n"
html += "</ul>"
```

### Test Steps: Ordered List with Action + Expected

**Format:**
```html
<ol>
  <li><strong>Action:</strong> Navigate to Settings page<br/>
      <strong>Expected:</strong> Settings page loads with user preferences displayed</li>
  <li><strong>Action:</strong> Click "Edit Profile" button<br/>
      <strong>Expected:</strong> Profile edit modal opens</li>
  <li><strong>Action:</strong> Update email field and click Save<br/>
      <strong>Expected:</strong> Email is updated and success message appears</li>
</ol>
```

**Generation pattern:**
```python
test_steps = [
    {"step": 1, "action": "Navigate to page", "expected": "Page loads"},
    {"step": 2, "action": "Click button", "expected": "Modal opens"}
]
html = "<ol>\n"
for step in test_steps:
    html += f"  <li><strong>Action:</strong> {step['action']}<br/>\n"
    html += f"      <strong>Expected:</strong> {step['expected']}</li>\n"
html += "</ol>"
```

### Special Character Escaping

When using sf CLI, escape quotes in HTML:

```bash
# Single quotes inside double quotes - escape with backslash
sf data create record --target-org gus \
  --sobject ADM_Test_Scenario__c \
  --values "Test_Steps__c='<ol><li>Step with \"quotes\"</li></ol>'"
```

**Python escaping:**
```python
def escape_for_cli(value: str) -> str:
    """Escape string for sf CLI --values parameter."""
    return value.replace("'", "\\'")
```

---

## Salesforce CLI Commands

### Check Authentication

```bash
sf data query --target-org gus \
  --query "SELECT Id, Username FROM User WHERE Id = UserInfo.getUserId()" \
  --json
```

### Authenticate to GUS

```bash
sf org login web \
  --instance-url https://gus.my.salesforce.com \
  --alias gus
```

### Query Work Item

```bash
sf data query --target-org gus \
  --query "SELECT Id, Name, Subject__c, Status__c FROM ADM_Work__c WHERE Name = 'W-12345678' LIMIT 1" \
  --json
```

### Create Test Suite

**Basic (no work item):**
```bash
sf data create record --target-org gus \
  --sobject ADM_Test_Suite__c \
  --values "Name='User Login Test Suite' Description__c='Comprehensive login flow tests' Total_Test_Scenarios__c=20" \
  --json
```

**With work item link:**
```bash
# First get work item ID
WORK_ITEM_ID=$(sf data query --target-org gus \
  --query "SELECT Id FROM ADM_Work__c WHERE Name = 'W-12345678'" \
  --json | jq -r '.result.records[0].Id')

# Then create suite
sf data create record --target-org gus \
  --sobject ADM_Test_Suite__c \
  --values "Name='Login Tests' Description__c='Login flow' Work_Item__c='${WORK_ITEM_ID}'" \
  --json
```

**Response:**
```json
{
  "status": 0,
  "result": {
    "id": "a1X5e000000AbcdEAC",
    "success": true,
    "errors": []
  }
}
```

Save the `id` field — you'll need it for creating scenarios.

### Create Test Scenario

**Example:**
```bash
SUITE_ID="a1X5e000000AbcdEAC"

sf data create record --target-org gus \
  --sobject ADM_Test_Scenario__c \
  --values "Name='TS-001' \
Test_Suite__c='${SUITE_ID}' \
Title__c='User logs in with valid credentials' \
Description__c='Verify successful login with correct username/password' \
Priority__c='P0' \
Type__c='Functional' \
Preconditions__c='<ul><li>User account exists</li><li>Password is valid</li></ul>' \
Test_Steps__c='<ol><li><strong>Action:</strong> Navigate to login page<br/><strong>Expected:</strong> Login form displayed</li><li><strong>Action:</strong> Enter username and password<br/><strong>Expected:</strong> Credentials accepted</li><li><strong>Action:</strong> Click Login<br/><strong>Expected:</strong> User redirected to home page</li></ol>' \
Test_Data__c='Username: testuser@example.com, Password: Test123!' \
Execution_Type__c='Automatable' \
Estimated_Time__c='5 minutes' \
Tags__c='login,authentication,happy-path'" \
  --json
```

**Response:**
```json
{
  "status": 0,
  "result": {
    "id": "a1Y5e000000XyzaEAB",
    "success": true,
    "errors": []
  }
}
```

### Bulk Create Pattern

```bash
SUITE_ID="a1X5e000000AbcdEAC"

# Loop through scenarios
for i in {1..20}; do
  SCENARIO_ID=$(printf "TS-%03d" $i)
  
  sf data create record --target-org gus \
    --sobject ADM_Test_Scenario__c \
    --values "Name='${SCENARIO_ID}' \
Test_Suite__c='${SUITE_ID}' \
Title__c='Test scenario ${i}' \
..." \
    --json
    
  echo "Created ${SCENARIO_ID}"
done
```

---

## Python Integration Example

Based on your existing script at `/Users/sahil.chhabra/.aisuite/notebook/.agents/artifacts/gus_test_case_generator.py`:

```python
import subprocess
import json
from typing import Dict, Any, Optional

class GUSUploader:
    """Upload test suites to GUS via sf CLI."""
    
    def __init__(self, target_org: str = "gus"):
        self.target_org = target_org
        self.verify_auth()
    
    def verify_auth(self):
        """Check GUS org authentication."""
        result = subprocess.run(
            ['sf', 'data', 'query', '--target-org', self.target_org,
             '--query', 'SELECT Id FROM User LIMIT 1', '--json'],
            capture_output=True,
            text=True,
            check=True
        )
        data = json.loads(result.stdout)
        if data['status'] != 0:
            raise RuntimeError("Not authenticated to GUS")
    
    def create_suite(self, suite_data: Dict[str, Any], 
                    work_item_id: Optional[str] = None) -> str:
        """Create ADM_Test_Suite__c record."""
        values = {
            'Name': suite_data['name'][:80],
            'Description__c': suite_data['description'],
            'Total_Test_Scenarios__c': suite_data['total_scenarios']
        }
        if work_item_id:
            values['Work_Item__c'] = work_item_id
        
        values_str = ' '.join([f"{k}='{v}'" for k, v in values.items()])
        
        result = subprocess.run(
            ['sf', 'data', 'create', 'record', '--target-org', self.target_org,
             '--sobject', 'ADM_Test_Suite__c', '--values', values_str, '--json'],
            capture_output=True,
            text=True,
            check=True
        )
        
        data = json.loads(result.stdout)
        return data['result']['id']
    
    def create_scenario(self, scenario: Dict[str, Any], suite_id: str) -> str:
        """Create ADM_Test_Scenario__c record."""
        # Format preconditions as HTML
        preconditions_html = "<ul>\n"
        for pre in scenario.get('preconditions', []):
            preconditions_html += f"  <li>{pre}</li>\n"
        preconditions_html += "</ul>"
        
        # Format test steps as HTML
        steps_html = "<ol>\n"
        for step in scenario['test_steps']:
            steps_html += f"  <li><strong>Action:</strong> {step['action']}<br/>\n"
            steps_html += f"      <strong>Expected:</strong> {step['expected']}</li>\n"
        steps_html += "</ol>"
        
        values = {
            'Name': scenario['scenario_id'],
            'Test_Suite__c': suite_id,
            'Title__c': scenario['title'][:255],
            'Description__c': scenario['description'],
            'Priority__c': scenario['priority'],
            'Type__c': scenario['test_type'],
            'Preconditions__c': preconditions_html,
            'Test_Steps__c': steps_html,
            'Test_Data__c': scenario.get('test_data', ''),
            'Execution_Type__c': scenario.get('automation_feasibility', 'Manual'),
            'Estimated_Time__c': scenario.get('estimated_time', ''),
            'Tags__c': ','.join(scenario.get('tags', []))
        }
        
        # Escape for CLI
        values_str = ' '.join([
            f"{k}='{str(v).replace(chr(39), chr(92)+chr(39))}'"
            for k, v in values.items()
        ])
        
        result = subprocess.run(
            ['sf', 'data', 'create', 'record', '--target-org', self.target_org,
             '--sobject', 'ADM_Test_Scenario__c', '--values', values_str, '--json'],
            capture_output=True,
            text=True,
            check=True
        )
        
        data = json.loads(result.stdout)
        return data['result']['id']
```

---

## Viewing Test Suites in GUS

### Test Suite URL Format
```
https://gus.lightning.force.com/lightning/r/ADM_Test_Suite__c/[SUITE_ID]/view
```

**Example:**
```
https://gus.lightning.force.com/lightning/r/ADM_Test_Suite__c/a1X5e000000AbcdEAC/view
```

### Test Scenario URL Format
```
https://gus.lightning.force.com/lightning/r/ADM_Test_Scenario__c/[SCENARIO_ID]/view
```

### Query Uploaded Suite

```bash
SUITE_ID="a1X5e000000AbcdEAC"

sf data query --target-org gus \
  --query "SELECT Id, Name, Description__c, Total_Test_Scenarios__c, Status__c, 
  (SELECT Id, Name, Title__c, Priority__c, Type__c FROM Test_Scenarios__r) 
  FROM ADM_Test_Suite__c WHERE Id = '${SUITE_ID}'" \
  --json
```

---

## Troubleshooting

### Error: "Not authenticated to target org gus"

**Solution:**
```bash
sf org login web --instance-url https://gus.my.salesforce.com --alias gus
```

### Error: "Required fields are missing: [Field]"

**Solution:** Check ADM_Test_Scenario__c required fields:
- `Name`, `Test_Suite__c`, `Title__c`, `Priority__c`, `Type__c`, `Test_Steps__c`

### Error: "String too long" / Field exceeds max length

**Solution:** Truncate before upload:
- `Name`: 80 chars
- `Title__c`: 255 chars
- `Test_Steps__c`: 32,768 chars (unlikely to hit)

```python
values['Title__c'] = scenario['title'][:255]
```

### Error: "Invalid ID" / Suite not found

**Solution:** Verify suite was created successfully and ID is correct:
```bash
sf data query --target-org gus \
  --query "SELECT Id, Name FROM ADM_Test_Suite__c ORDER BY CreatedDate DESC LIMIT 1" \
  --json
```

### HTML not rendering in GUS

**Check:**
1. Using `<ul>` for preconditions, `<ol>` for steps
2. Proper closing tags
3. No syntax errors in HTML

**Test HTML locally:**
```html
<!DOCTYPE html>
<html>
<body>
[paste your HTML here]
</body>
</html>
```

### Work Item Link not showing

**Verify:**
1. Work item ID is correct (18-char Salesforce ID, not W-number)
2. Field name is `Work_Item__c` (not `Work_Item__r`)
3. User has access to both suite and work item

**Convert W-number to ID:**
```bash
sf data query --target-org gus \
  --query "SELECT Id FROM ADM_Work__c WHERE Name = 'W-12345678'" \
  --json | jq -r '.result.records[0].Id'
```

---

## Best Practices

### 1. Always validate before bulk upload
- Test with 1-2 scenarios first
- Verify HTML renders correctly in GUS UI
- Check field lengths and escaping

### 2. Handle failures gracefully
- Log successful scenario IDs
- Continue on individual failures
- Provide summary of successes vs failures

### 3. Provide clear URLs
```python
suite_url = f"https://gus.lightning.force.com/lightning/r/ADM_Test_Suite__c/{suite_id}/view"
print(f"View in GUS: {suite_url}")
```

### 4. Use consistent naming
- Suite names: "[Feature] Test Suite"
- Scenario IDs: TS-001, TS-002 (zero-padded, sequential)
- Tags: lowercase, hyphen-separated

### 5. Test in sandbox first
If available, test upload in GUS sandbox before production:
```bash
sf org login web --instance-url https://gus--sandbox.my.salesforce.com --alias gus-sandbox
sf data create record --target-org gus-sandbox ...
```
