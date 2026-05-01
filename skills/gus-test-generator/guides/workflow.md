# Test Generation Workflow

Complete workflow for generating comprehensive test cases from PRD/HLD and uploading to GUS Taleggio.

---

## Phase 1: Input Collection

### Required Inputs
1. **PRD (Product Requirements Document)**
   - Ask: "Please provide the PRD document (path, URL, or paste content)"
   - Accept: File path, Google Doc link, direct paste
   - Validate: Must contain functional requirements

2. **Product Tag**
   - Ask: "What is the GUS Product Tag for this feature? Please provide the GUS URL or Salesforce ID."
   - Format: GUS URL (`https://gus.lightning.force.com/lightning/r/ADM_Product_Tag__c/<ID>/view`) or 18-char Salesforce ID
   - **Immediately query the tag to resolve its Name and Team__c** — both are needed for upload:
     ```bash
     sf data query --target-org gus \
       --query "SELECT Id, Name, Team__c, Team__r.Name FROM ADM_Product_Tag__c WHERE Id = '<ID>'" \
       --json
     ```
   - The `Team__c` value from this query is used as `Team__c` on `ADM_Test_Suite__c`

### Optional Inputs
3. **HLD (High-Level Design)**
   - Ask: "Do you have an HLD document? (optional - improves integration test coverage)"
   - Accept: File path, URL, paste, or "no"
   - Use: Enhances integration and technical test scenarios

4. **Work Item**
   - Ask: "Do you want to link this test suite to a GUS work item? (optional)"
   - Format: W-######## (8-digit work item number)
   - Note: Can be referenced in suite description; there is no direct Work_Item__c field on ADM_Test_Suite__c

### Input Collection Script

```
I'll help you generate test cases for GUS Taleggio.

Required:
- PRD: [provide path, URL, or paste content]
- Product Tag: [GUS URL or Salesforce ID for the product tag]

Optional:
- HLD: [provide if available, or skip]
- Work Item: [W-######## to note in description, or skip]
```

---

## Phase 2: Test Scenario Generation

### Coverage Requirements

Generate **minimum 15-25 test scenarios** covering:

#### 1. Functional Tests (30-40% of scenarios)
- **Happy path**: Core feature workflows that should succeed
- **User workflows**: End-to-end user journeys
- **Feature validation**: Each requirement gets at least one test
- **Priority**: Mix of P0 (critical path) and P1 (important features)
- **Quadrant__c**: `Q1`

**Example:**
- TS-001: User successfully creates new record with valid data
- TS-002: User edits existing record and saves changes
- TS-003: User views record details page

#### 2. Integration Tests (25-30% of scenarios)
- **Component interactions**: How modules communicate
- **API integrations**: External service calls, webhooks
- **Data flow**: Data moving between systems
- **Priority**: P1-P2 (depends on integration criticality)
- **Quadrant__c**: `Q2`

**Example:**
- TS-008: Record creation triggers workflow rule execution
- TS-009: API call to external service returns expected data
- TS-010: Data syncs correctly between Service A and Service B

#### 3. Edge Cases & Negative Tests (20-25% of scenarios)
- **Boundary conditions**: Min/max values, empty states, limits
- **Error handling**: Invalid inputs, missing data, system errors
- **Validation rules**: Field validation, permission checks
- **Priority**: P2-P3 (unless security/data integrity, then P0-P1)
- **Quadrant__c**: `Q3`

**Example:**
- TS-015: System rejects record creation with invalid email format
- TS-016: User without permissions sees appropriate error message
- TS-017: System handles special characters in text fields correctly

#### 4. Performance Tests (15-20% of scenarios)
- **Load testing**: Multiple concurrent users
- **Scalability**: Large data volumes
- **Response time**: Page load, query execution benchmarks
- **Priority**: P2-P3 (unless performance is key requirement, then P1)
- **Quadrant__c**: `Q4 Performance`

**Example:**
- TS-020: System handles 100 concurrent users without degradation
- TS-021: Query returns results in <2 seconds with 1M records
- TS-022: Page loads in <3 seconds under normal load

### Test Scenario Structure

Each scenario must include:

```json
{
  "scenario_id": "TS-001",
  "title": "Concise descriptive title (used for Test_Name__c)",
  "priority": "P0|P1|P2|P3",
  "test_type": "Functional|Integration|Edge Case|Performance",
  "quadrant": "Q1|Q2|Q3|Q4 Performance|Q4 Security",
  "preconditions": [
    "User is authenticated",
    "Test data is seeded",
    "Feature flag is enabled"
  ],
  "test_steps": [
    {"step": 1, "action": "Navigate to X page", "expected": "Page loads successfully"},
    {"step": 2, "action": "Click Y button", "expected": "Modal opens"},
    {"step": 3, "action": "Enter data Z", "expected": "Data is validated and saved"}
  ],
  "test_data": "Username: testuser@example.com, Record ID: 12345",
  "automation_feasibility": "Manual|Automated|Cannot be automated"
}
```

**GUS Field Mapping:**

| Scenario Field | GUS Field on ADM_Test_Scenario__c |
|----------------|-----------------------------------|
| `scenario_id` | `Name` (max 80 chars) |
| `title` | `Test_Name__c` |
| `priority` | `Priority__c` (P0–P4) |
| `quadrant` | `Quadrant__c` |
| `preconditions` (HTML `<ul>`) | `Prerequisite__c` |
| `test_steps` + `test_data` (HTML `<ol>`) | `Test_Details__c` |
| `automation_feasibility` | `Execution_Type__c` (Manual/Automated/Cannot be automated) |

### Generation Prompt Template

```
Analyze this PRD [and HLD] to generate comprehensive test cases.

Product Tag: [tag name]

[PRD content]

[HLD content if provided]

Generate test suite with:
- Suite name and description
- 15-25 scenarios covering:
  * Functional / Q1 (30-40%): happy path, workflows
  * Integration / Q2 (25-30%): component interactions, APIs
  * Edge cases / Q3 (20-25%): boundaries, errors, validation
  * Performance / Q4 Performance (15-20%): load, scale, response time

Each scenario needs:
- Unique ID (TS-001, TS-002...)
- Title (Test_Name__c), priority (P0-P3), quadrant (Q1/Q2/Q3/Q4 Performance)
- Preconditions list
- Test steps with action + expected result
- Test data (include inline in steps)
- Execution type (Manual/Automated/Cannot be automated)
```

---

## Phase 3: Preview & Validation

### Before Upload Checklist

Show user a preview with these checks:

#### 1. Coverage Validation
- [ ] At least 15 scenarios generated
- [ ] All 4 test types represented (Q1/Q2/Q3/Q4 Performance)
- [ ] Priority distribution reasonable (some P0/P1 for critical paths)
- [ ] Each functional requirement has test coverage

#### 2. Structure Validation
- [ ] All scenario IDs unique and sequential (TS-001, TS-002…)
- [ ] `Name` field (scenario_id) under 80 characters
- [ ] `Test_Name__c` (title) is concise
- [ ] Preconditions formatted as list
- [ ] Test steps have both action and expected result
- [ ] Priority values are valid (P0/P1/P2/P3)
- [ ] Quadrant values are valid (Q1/Q2/Q3/Q4 Performance/Q4 Security)

#### 3. GUS Field Validation
- [ ] `Product_Tag__c` ID is known and valid
- [ ] `Team__c` resolved from product tag (`ADM_Product_Tag__c.Team__c`)
- [ ] `Execution_Type__c` is one of: `Manual`, `Automated`, `Cannot be automated`
- [ ] Preconditions ready for HTML `<ul>` → `Prerequisite__c`
- [ ] Steps + test data ready for HTML `<ol>` → `Test_Details__c`

### Preview Format

```
Test Suite: [Suite Name]
Description: [Suite Description]
Product Tag: [Tag Name] (ID: [Tag ID])
Team: [Team Name] (ID: [Team ID])
Total Scenarios: [Count]

Coverage Breakdown:
- Functional (Q1): X scenarios
- Integration (Q2): Y scenarios
- Edge Cases (Q3): Z scenarios
- Performance (Q4): W scenarios

Sample Scenarios:
[Show first 3-5 scenarios with full detail]

Ready to upload to GUS?
- [ ] Coverage looks good
- [ ] Scenarios are accurate
- [ ] GUS authentication verified
```

---

## Phase 4: GUS Upload

### Pre-Upload Verification

1. **Check sf CLI installed**
```bash
sf --version
```

2. **Verify GUS authentication**
```bash
sf data query --target-org gus --query "SELECT Id FROM User LIMIT 1" --json
```

If authentication fails:
```bash
sf org login web --instance-url https://gus.my.salesforce.com --alias gus
```

3. **Resolve Team ID from product tag** (required for suite creation)
```bash
TEAM_ID=$(sf data query --target-org gus \
  --query "SELECT Team__c FROM ADM_Product_Tag__c WHERE Id = '<PRODUCT_TAG_ID>'" \
  --json | jq -r '.result.records[0].Team__c')
```

### Upload Sequence

Refer to [GUS Integration Guide](gus-integration.md) for detailed field mappings and commands.

**Order matters:**
1. Resolve `TEAM_ID` from product tag
2. Create `ADM_Test_Suite__c` (using `Suite_Name__c`, `Description__c`, `Team__c`) → get `SUITE_ID`
3. Create each `ADM_Test_Scenario__c` (using `Name`, `Test_Name__c`, `Product_Tag__c`, `Priority__c`, `Quadrant__c`, `Execution_Type__c`, `Prerequisite__c`, `Test_Details__c`) → get `SCENARIO_ID`
4. Create `ADM_Related_Test_Scenario__c` junction record linking `SUITE_ID` + `SCENARIO_ID` for each scenario
5. Return GUS URLs for viewing

### Post-Upload Confirmation

Provide user:
```
✅ Test suite created successfully!

Test Suite ID: [Salesforce ID]
Test Suite URL: https://gus.lightning.force.com/lightning/r/ADM_Test_Suite__c/[ID]/view

Created Scenarios: [X]/[Y total]
Junction Records: [X]/[Y linked]

Next steps:
- Review test suite in GUS Taleggio
- Assign reviewers if needed
- Execute test scenarios when feature is ready for testing
```

---

## Common Issues & Solutions

### Issue: PRD is too vague
**Symptom**: Generated test cases are generic or miss coverage areas
**Solution**:
- Ask user to clarify specific requirements
- Focus on explicit functional statements
- Generate fewer but more specific scenarios
- Flag ambiguous requirements for user to clarify

### Issue: Product tag ID not found
**Symptom**: GUS query returns no results
**Solution**:
- Confirm user provided a valid product tag URL or ID
- Search by name: `SELECT Id, Name FROM ADM_Product_Tag__c WHERE Name LIKE '%keyword%'`

### Issue: Upload fails midway
**Symptom**: Suite created but some scenarios fail
**Solution**:
- Note successful scenario IDs
- Identify failure pattern (field too long? invalid value? escaping?)
- Fix remaining scenarios and re-upload
- GUS allows manual scenario addition via UI

### Issue: HTML formatting broken in GUS
**Symptom**: Test steps show raw HTML tags
**Solution**:
- Verify `Prerequisite__c` uses `<ul><li>` tags
- Verify `Test_Details__c` uses `<ol><li>` tags
- Ensure single quotes inside field values are escaped: `\'`
- See [GUS Integration Guide](gus-integration.md) for examples

---

## Best Practices

### For Better Test Scenarios
1. **Be specific**: "User clicks Save button" not "User saves"
2. **One assertion per step**: Don't combine multiple validations
3. **Include realistic test data**: Actual email formats, IDs, values (embed in `Test_Details__c`)
4. **Consider user personas**: Admin vs standard user vs guest
5. **Think failure modes**: What could go wrong?

### For Better GUS Integration
1. **Preview before upload**: Always show formatted output and get confirmation
2. **Derive Team__c from product tag**: Never hardcode a team ID
3. **Use consistent naming**: TS-001, TS-002 (not TC-01, Test1)
4. **Always create junction records**: Scenarios are not visible in the suite without `ADM_Related_Test_Scenario__c`

### For Team Adoption
1. **Start small**: Generate 15 scenarios, get feedback, iterate
2. **Review together**: First few runs should be team-reviewed
3. **Refine coverage**: Adjust test type percentages for your domain
4. **Document patterns**: Capture team-specific conventions
5. **Share results**: Post GUS URLs in team channels for visibility
