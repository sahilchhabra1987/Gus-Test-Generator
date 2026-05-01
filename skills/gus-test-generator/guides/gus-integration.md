# GUS Integration Guide

Technical reference for uploading test suites and scenarios to GUS Taleggio using Salesforce CLI.

> **Schema verified against live GUS org on 2026-04-30.** All field names and constraints below are confirmed by `sf sobject describe`.

---

## GUS Objects

### ADM_Test_Suite__c
Container for related test scenarios.

**Createable Fields:**
| Field API Name | Type | Required | Notes |
|----------------|------|----------|-------|
| `Suite_Name__c` | Long Text Area | Yes | The human-readable name of the suite |
| `Description__c` | Long Text Area | No | Suite description and scope |
| `Team__c` | Lookup → ADM_Scrum_Team__c | Yes (nillable: false) | **Must be derived from the product tag** — see below |
| `Labels__c` | Multi-Picklist | No | Values: `Regression`, `Customer`, `Release` |
| `Source__c` | Picklist | No | Values: `CMD`, `CSV`, `Google`, `Quip` |

**Read-only / Auto-generated Fields (do NOT set on create):**
| Field API Name | Notes |
|----------------|-------|
| `Name` | Auto-generated suite ID (e.g. TS-1100606) |
| `Total_Test_Scenarios__c` | Calculated — auto-updated, not writable |
| `Unique_Test_Suite_Name__c` | Auto-generated |
| `Unique_Test_Suite_Id__c` | Auto-generated |

**Fields that do NOT exist (common mistakes):**
- ~~`Product_Tag__c`~~ — not a field on this object
- ~~`Work_Item__c`~~ — not a field on this object
- ~~`Status__c`~~ — not a field on this object
- ~~`Created_By__c`~~ / ~~`Created_Date__c`~~ — use standard `CreatedById` / `CreatedDate`

#### Deriving Team__c from the Product Tag

`Team__c` is required on `ADM_Test_Suite__c` and should always match the product tag's owning team. Query it before creating the suite:

```bash
TEAM_ID=$(sf data query --target-org gus \
  --query "SELECT Team__c FROM ADM_Product_Tag__c WHERE Id = '<PRODUCT_TAG_ID>'" \
  --json | jq -r '.result.records[0].Team__c')
```

---

### ADM_Test_Scenario__c
Individual test case (standalone — linked to a suite via junction object, not a direct lookup).

**Createable Fields:**
| Field API Name | Type | Required | Notes |
|----------------|------|----------|-------|
| `Name` | Text (80) | Yes | Scenario ID: `TS-001`, `TS-002`, etc. |
| `Test_Name__c` | Long Text Area | Yes | Scenario title / name |
| `Product_Tag__c` | Lookup → ADM_Product_Tag__c | Yes (nillable: false) | Must supply the product tag ID |
| `Execution_Type__c` | Picklist | Yes (nillable: false) | `Manual`, `Automated`, `Cannot be automated` |
| `Test_Details__c` | Long Text Area | No | Full test steps + details (HTML formatted) |
| `Prerequisite__c` | Long Text Area | No | HTML formatted preconditions list |
| `Expected_Results__c` | Long Text Area | No | Overall expected outcome |
| `Priority__c` | Picklist | No | `P0`, `P1`, `P2`, `P3`, `P4` |
| `Quadrant__c` | Picklist | No | `Q1`, `Q2`, `Q3`, `Q4 Performance`, `Q4 Security` |
| `Scrum_Team__c` | Lookup → ADM_Scrum_Team__c | No | Optional — set to same team as suite |
| `Label__c` | Multi-Picklist | No | `API`, `Deploy`, `End-to-End`, `Regression`, `Sanity`, `UI` |
| `Regression__c` | Boolean | No | Default false |
| `Comments__c` | Text | No | Free-form comments |

**Fields that do NOT exist (common mistakes):**
- ~~`Test_Suite__c`~~ — scenarios are NOT directly linked to suite; use junction object `ADM_Related_Test_Scenario__c`
- ~~`Title__c`~~ — use `Test_Name__c`
- ~~`Description__c`~~ — use `Test_Details__c`
- ~~`Type__c`~~ — use `Quadrant__c`
- ~~`Preconditions__c`~~ — use `Prerequisite__c`
- ~~`Test_Steps__c`~~ — use `Test_Details__c`
- ~~`Test_Data__c`~~ — include test data inline in `Test_Details__c`
- ~~`Estimated_Time__c`~~ — does not exist
- ~~`Tags__c`~~ — use `Label__c` (multi-picklist, not free text)
- ~~`Status__c`~~ — does not exist

#### Quadrant Mapping (test type → Quadrant__c)

| Conceptual Type | Quadrant__c Value |
|-----------------|-------------------|
| Functional / Happy Path | `Q1` |
| Integration / API | `Q2` |
| Edge Cases / Negative | `Q3` |
| Performance | `Q4 Performance` |
| Security | `Q4 Security` |

---

### ADM_Related_Test_Scenario__c
Junction object that links a scenario to a suite.

**Createable Fields:**
| Field API Name | Type | Required | Notes |
|----------------|------|----------|-------|
| `Test_Suite__c` | Lookup → ADM_Test_Suite__c | Yes | The suite ID |
| `Test_Scenario__c` | Lookup → ADM_Test_Scenario__c | Yes | The scenario ID |
| `Order__c` | Number | No | Display order within suite |

---

## HTML Formatting Rules

GUS Taleggio renders `Prerequisite__c` and `Test_Details__c` as HTML. **Always format as HTML lists.**

### Prerequisite__c: Unordered List

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

### Test_Details__c: Ordered List with Action + Expected

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

When using sf CLI, escape single quotes in HTML:

```bash
sf data create record --target-org gus \
  --sobject ADM_Test_Scenario__c \
  --values "Test_Details__c='<ol><li>Step with \"quotes\"</li></ol>'"
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
  --query "SELECT Id, Username FROM User LIMIT 1" \
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

### Resolve Team ID from Product Tag

**Always do this before creating the suite:**

```bash
TEAM_ID=$(sf data query --target-org gus \
  --query "SELECT Team__c FROM ADM_Product_Tag__c WHERE Id = '<PRODUCT_TAG_ID>'" \
  --json | jq -r '.result.records[0].Team__c')
```

### Create Test Suite

```bash
sf data create record --target-org gus \
  --sobject ADM_Test_Suite__c \
  --values "Suite_Name__c='User Login Test Suite' Description__c='Comprehensive login flow tests' Team__c='${TEAM_ID}'" \
  --json
```

**Response:**
```json
{
  "status": 0,
  "result": {
    "id": "a81EE000005LhjpYAC",
    "success": true,
    "errors": []
  }
}
```

Save the `id` — you need it for the junction records.

### Create Test Scenario

```bash
PRODUCT_TAG_ID="a1aEE000002H2InYAK"

sf data create record --target-org gus \
  --sobject ADM_Test_Scenario__c \
  --values "Name='TS-001' \
Test_Name__c='User logs in with valid credentials' \
Product_Tag__c='${PRODUCT_TAG_ID}' \
Priority__c='P0' \
Quadrant__c='Q1' \
Execution_Type__c='Manual' \
Prerequisite__c='<ul><li>User account exists</li><li>Password is valid</li></ul>' \
Test_Details__c='<ol><li><strong>Action:</strong> Navigate to login page<br/><strong>Expected:</strong> Login form displayed</li><li><strong>Action:</strong> Enter username and password<br/><strong>Expected:</strong> Credentials accepted</li><li><strong>Action:</strong> Click Login<br/><strong>Expected:</strong> User redirected to home page. Test data: Username: testuser@example.com</li></ol>'" \
  --json
```

### Link Scenario to Suite (Junction Record)

```bash
SUITE_ID="a81EE000005LhjpYAC"
SCENARIO_ID="<scenario_id_from_above>"

sf data create record --target-org gus \
  --sobject ADM_Related_Test_Scenario__c \
  --values "Test_Suite__c='${SUITE_ID}' Test_Scenario__c='${SCENARIO_ID}' Order__c=1" \
  --json
```

### Upload Sequence

**Order matters:**
1. Resolve `TEAM_ID` from product tag
2. Create `ADM_Test_Suite__c` → get `SUITE_ID`
3. For each scenario: create `ADM_Test_Scenario__c` → get `SCENARIO_ID`
4. For each scenario: create `ADM_Related_Test_Scenario__c` linking `SUITE_ID` + `SCENARIO_ID`

---

## Python Integration Example

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
            capture_output=True, text=True, check=True
        )
        data = json.loads(result.stdout)
        if data['status'] != 0:
            raise RuntimeError("Not authenticated to GUS")

    def get_team_from_product_tag(self, product_tag_id: str) -> str:
        """Resolve Team__c from ADM_Product_Tag__c."""
        result = subprocess.run(
            ['sf', 'data', 'query', '--target-org', self.target_org,
             '--query', f"SELECT Team__c FROM ADM_Product_Tag__c WHERE Id = '{product_tag_id}'",
             '--json'],
            capture_output=True, text=True, check=True
        )
        data = json.loads(result.stdout)
        return data['result']['records'][0]['Team__c']

    def create_suite(self, suite_name: str, description: str, team_id: str) -> str:
        """Create ADM_Test_Suite__c record. Returns suite ID."""
        values_str = (
            f"Suite_Name__c='{self._esc(suite_name)}' "
            f"Description__c='{self._esc(description)}' "
            f"Team__c='{team_id}'"
        )
        result = subprocess.run(
            ['sf', 'data', 'create', 'record', '--target-org', self.target_org,
             '--sobject', 'ADM_Test_Suite__c', '--values', values_str, '--json'],
            capture_output=True, text=True, check=True
        )
        data = json.loads(result.stdout)
        return data['result']['id']

    def create_scenario(self, scenario: Dict[str, Any], product_tag_id: str) -> str:
        """Create ADM_Test_Scenario__c record. Returns scenario ID."""
        prereq_html = "<ul>\n"
        for pre in scenario.get('preconditions', []):
            prereq_html += f"  <li>{pre}</li>\n"
        prereq_html += "</ul>"

        steps_html = "<ol>\n"
        for step in scenario['test_steps']:
            steps_html += f"  <li><strong>Action:</strong> {step['action']}<br/>\n"
            steps_html += f"      <strong>Expected:</strong> {step['expected']}</li>\n"
        if scenario.get('test_data'):
            steps_html += f"  <li><strong>Test Data:</strong> {scenario['test_data']}</li>\n"
        steps_html += "</ol>"

        quadrant_map = {
            'Functional': 'Q1', 'Integration': 'Q2', 'Edge Case': 'Q3',
            'Performance': 'Q4 Performance', 'Security': 'Q4 Security',
        }
        quadrant = quadrant_map.get(scenario.get('test_type', 'Functional'), 'Q1')

        exec_map = {
            'Manual': 'Manual', 'Automatable': 'Manual',
            'Automated': 'Automated', 'Cannot be automated': 'Cannot be automated',
        }
        exec_type = exec_map.get(scenario.get('automation_feasibility', 'Manual'), 'Manual')

        values_str = (
            f"Name='{self._esc(scenario['scenario_id'])}' "
            f"Test_Name__c='{self._esc(scenario['title'][:255])}' "
            f"Product_Tag__c='{product_tag_id}' "
            f"Priority__c='{scenario.get('priority', 'P2')}' "
            f"Quadrant__c='{quadrant}' "
            f"Execution_Type__c='{exec_type}' "
            f"Prerequisite__c='{self._esc(prereq_html)}' "
            f"Test_Details__c='{self._esc(steps_html)}'"
        )
        result = subprocess.run(
            ['sf', 'data', 'create', 'record', '--target-org', self.target_org,
             '--sobject', 'ADM_Test_Scenario__c', '--values', values_str, '--json'],
            capture_output=True, text=True, check=True
        )
        data = json.loads(result.stdout)
        return data['result']['id']

    def link_scenario_to_suite(self, suite_id: str, scenario_id: str, order: int) -> str:
        """Create ADM_Related_Test_Scenario__c junction record."""
        values_str = (
            f"Test_Suite__c='{suite_id}' "
            f"Test_Scenario__c='{scenario_id}' "
            f"Order__c={order}"
        )
        result = subprocess.run(
            ['sf', 'data', 'create', 'record', '--target-org', self.target_org,
             '--sobject', 'ADM_Related_Test_Scenario__c', '--values', values_str, '--json'],
            capture_output=True, text=True, check=True
        )
        data = json.loads(result.stdout)
        return data['result']['id']

    @staticmethod
    def _esc(value: str) -> str:
        """Escape single quotes for sf CLI --values parameter."""
        return str(value).replace("'", "\\'")
```

---

## Viewing Test Suites in GUS

### Test Suite URL Format
```
https://gus.lightning.force.com/lightning/r/ADM_Test_Suite__c/[SUITE_ID]/view
```

### Test Scenario URL Format
```
https://gus.lightning.force.com/lightning/r/ADM_Test_Scenario__c/[SCENARIO_ID]/view
```

### Query Uploaded Suite

```bash
SUITE_ID="a81EE000005LhjpYAC"

sf data query --target-org gus \
  --query "SELECT Id, Name, Suite_Name__c, Description__c, Total_Test_Scenarios__c,
  (SELECT Id, Name, Test_Scenario__r.Test_Name__c, Test_Scenario__r.Priority__c, Test_Scenario__r.Quadrant__c FROM Related_Test_Scenarios__r)
  FROM ADM_Test_Suite__c WHERE Id = '${SUITE_ID}'" \
  --json
```

---

## Troubleshooting

### Error: "Not authenticated to target org gus"

```bash
sf org login web --instance-url https://gus.my.salesforce.com --alias gus
```

### Error: "Required fields are missing: [Team__c]"

`Team__c` is required on `ADM_Test_Suite__c`. Always resolve it from the product tag first:
```bash
TEAM_ID=$(sf data query --target-org gus \
  --query "SELECT Team__c FROM ADM_Product_Tag__c WHERE Id = '<PRODUCT_TAG_ID>'" \
  --json | jq -r '.result.records[0].Team__c')
```

### Error: "Required fields are missing: [Product_Tag__c]"

`Product_Tag__c` is required on `ADM_Test_Scenario__c`. Always pass it when creating scenarios.

### Error: "No such column 'X'" / INVALID_FIELD

You are using a field name from old documentation that does not exist. Correct field names:

| Wrong | Correct |
|-------|---------|
| `Name` (suite) | `Suite_Name__c` |
| `Title__c` | `Test_Name__c` |
| `Description__c` (scenario) | `Test_Details__c` |
| `Type__c` | `Quadrant__c` |
| `Preconditions__c` | `Prerequisite__c` |
| `Test_Steps__c` | `Test_Details__c` |
| `Tags__c` | `Label__c` |

### Error: "Unable to create/update fields: Total_Test_Scenarios__c"

This is a read-only calculated field. Remove it from the create payload.

### HTML not rendering in GUS

1. Use `<ul>` for `Prerequisite__c`, `<ol>` for `Test_Details__c`
2. Ensure proper closing tags
3. Single quotes inside field values must be escaped: `\'`

---

## Best Practices

### 1. Always derive Team__c from the product tag
Never hardcode a team ID. Derive it from `ADM_Product_Tag__c.Team__c` at upload time.

### 2. Always validate before bulk upload
Test with 1 scenario first, verify HTML renders in GUS UI, then proceed with the rest.

### 3. Handle failures gracefully
Log successful scenario IDs; continue on individual failures; report summary of successes vs failures.

### 4. Use consistent naming
- Suite names: `"[Feature] Test Suite"`
- Scenario IDs: `TS-001`, `TS-002` (zero-padded, sequential)

### 5. Provide clear URLs after upload
```python
suite_url = f"https://gus.lightning.force.com/lightning/r/ADM_Test_Suite__c/{suite_id}/view"
print(f"View in GUS: {suite_url}")
```
