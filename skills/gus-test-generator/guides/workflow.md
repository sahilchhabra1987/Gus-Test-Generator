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
   - Ask: "What is the GUS Product Tag for this feature?"
   - Format: Exact tag name as it appears in GUS
   - Example: "Revenue Cloud", "CPQ", "Industries"

### Optional Inputs
3. **HLD (High-Level Design)**
   - Ask: "Do you have an HLD document? (optional - improves integration test coverage)"
   - Accept: File path, URL, paste, or "no"
   - Use: Enhances integration and technical test scenarios

4. **Work Item**
   - Ask: "Do you want to link this test suite to a GUS work item? (optional)"
   - Format: W-######## (8-digit work item number)
   - Validate: Check work item exists in GUS before upload

### Input Collection Script

```
I'll help you generate test cases for GUS Taleggio.

Required:
- PRD: [provide path, URL, or paste content]
- Product Tag: [exact GUS product tag name]

Optional:
- HLD: [provide if available, or skip]
- Work Item: [W-######## to link suite, or skip]
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

**Example:**
- TS-001: User successfully creates new record with valid data
- TS-002: User edits existing record and saves changes
- TS-003: User views record details page

#### 2. Integration Tests (25-30% of scenarios)
- **Component interactions**: How modules communicate
- **API integrations**: External service calls, webhooks
- **Data flow**: Data moving between systems
- **Priority**: P1-P2 (depends on integration criticality)

**Example:**
- TS-008: Record creation triggers workflow rule execution
- TS-009: API call to external service returns expected data
- TS-010: Data syncs correctly between Service A and Service B

#### 3. Edge Cases & Negative Tests (20-25% of scenarios)
- **Boundary conditions**: Min/max values, empty states, limits
- **Error handling**: Invalid inputs, missing data, system errors
- **Validation rules**: Field validation, permission checks
- **Priority**: P2-P3 (unless security/data integrity, then P0-P1)

**Example:**
- TS-015: System rejects record creation with invalid email format
- TS-016: User without permissions sees appropriate error message
- TS-017: System handles special characters in text fields correctly

#### 4. Performance Tests (15-20% of scenarios)
- **Load testing**: Multiple concurrent users
- **Scalability**: Large data volumes
- **Response time**: Page load, query execution benchmarks
- **Priority**: P2-P3 (unless performance is key requirement, then P1)

**Example:**
- TS-020: System handles 100 concurrent users without degradation
- TS-021: Query returns results in <2 seconds with 1M records
- TS-022: Page loads in <3 seconds under normal load

### Test Scenario Structure

Each scenario must include:

```json
{
  "scenario_id": "TS-001",
  "title": "Concise descriptive title (max 255 chars)",
  "description": "Detailed test objective and what's being validated",
  "priority": "P0|P1|P2|P3",
  "test_type": "Functional|Integration|Edge Case|Performance",
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
  "automation_feasibility": "Manual|Automatable|Automated",
  "estimated_time": "5 minutes",
  "tags": ["tag1", "tag2"]
}
```

### Generation Prompt Template

Use this structure when generating with Claude API or in conversation:

```
Analyze this PRD [and HLD] to generate comprehensive test cases.

Product Tag: [tag]

[PRD content]

[HLD content if provided]

Generate test suite with:
- Suite name and description
- 15-25 scenarios covering:
  * Functional (30-40%): happy path, workflows
  * Integration (25-30%): component interactions, APIs
  * Edge cases (20-25%): boundaries, errors, validation
  * Performance (15-20%): load, scale, response time

Each scenario needs:
- Unique ID (TS-001, TS-002...)
- Title, description, priority (P0-P3), test type
- Preconditions list
- Test steps with action + expected result
- Test data, automation feasibility, estimated time
```

---

## Phase 3: Preview & Validation

### Before Upload Checklist

Show user a preview with these checks:

#### 1. Coverage Validation
- [ ] At least 15 scenarios generated
- [ ] All 4 test types represented (functional, integration, edge, performance)
- [ ] Priority distribution reasonable (some P0/P1 for critical paths)
- [ ] Each functional requirement has test coverage

#### 2. Structure Validation
- [ ] All scenario IDs unique and sequential
- [ ] Titles under 255 characters
- [ ] Preconditions formatted as list
- [ ] Test steps have both action and expected result
- [ ] Priority values are valid (P0/P1/P2/P3)

#### 3. Format Validation
- [ ] Preconditions ready for HTML `<ul>` conversion
- [ ] Test steps ready for HTML `<ol>` conversion
- [ ] No special characters that need escaping for GUS
- [ ] Test data includes realistic examples

### Preview Format

Show preview like this:

```
Test Suite: [Suite Name]
Description: [Suite Description]
Product Tag: [Tag]
Total Scenarios: [Count]

Coverage Breakdown:
- Functional: X scenarios
- Integration: Y scenarios
- Edge Cases: Z scenarios
- Performance: W scenarios

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

3. **Validate work item exists** (if provided)
```bash
sf data query --target-org gus --query "SELECT Id, Name, Subject__c FROM ADM_Work__c WHERE Name = 'W-########' LIMIT 1" --json
```

### Upload Sequence

Refer to [GUS Integration Guide](gus-integration.md) for detailed field mappings and commands.

**Order matters:**
1. Create ADM_Test_Suite__c record (get suite ID)
2. Create each ADM_Test_Scenario__c record (linked to suite ID)
3. Return GUS URLs for viewing

### Post-Upload Confirmation

Provide user:
```
✅ Test suite created successfully!

Test Suite ID: [Salesforce ID]
Test Suite URL: https://gus.lightning.force.com/lightning/r/ADM_Test_Suite__c/[ID]/view

Created Scenarios: [X]/[Y successful]
Work Item Link: [W-######## if applicable]

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

### Issue: Work item not found
**Symptom**: GUS query returns no results for W-########
**Solution**:
- Verify work item number is correct
- Check user has access to work item in GUS
- Create test suite without work item link
- User can manually link later in GUS UI

### Issue: Upload fails midway
**Symptom**: Suite created but some scenarios fail
**Solution**:
- Note successful scenario count
- Identify failure pattern (field too long? invalid char?)
- Fix remaining scenarios and re-upload
- GUS allows manual scenario addition via UI

### Issue: HTML formatting broken in GUS
**Symptom**: Test steps show raw HTML tags
**Solution**:
- Verify preconditions use `<ul><li>` tags
- Verify test steps use `<ol><li>` tags
- Ensure proper escaping of quotes and special chars
- See [GUS Integration Guide](gus-integration.md) for examples

---

## Best Practices

### For Better Test Scenarios
1. **Be specific**: "User clicks Save button" not "User saves"
2. **One assertion per step**: Don't combine multiple validations
3. **Include realistic test data**: Actual email formats, IDs, values
4. **Consider user personas**: Admin vs standard user vs guest
5. **Think failure modes**: What could go wrong?

### For Better GUS Integration
1. **Preview before upload**: Always show formatted output
2. **Batch similar scenarios**: Group by test type for easier review
3. **Use consistent naming**: TS-001, TS-002 (not TC-01, Test1)
4. **Tag appropriately**: Help future search and filtering
5. **Link to work items**: Improves traceability

### For Team Adoption
1. **Start small**: Generate 15 scenarios, get feedback, iterate
2. **Review together**: First few runs should be team-reviewed
3. **Refine coverage**: Adjust test type percentages for your domain
4. **Document patterns**: Capture team-specific conventions
5. **Share results**: Post GUS URLs in team channels for visibility
