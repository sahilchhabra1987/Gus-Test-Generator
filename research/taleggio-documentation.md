# Taleggio Research Notes

Source materials for GUS Test Generator expert.

---

## Taleggio Overview

**Source**: [Taleggio Tool Usecase](https://drive.google.com/file/d/1xHsvbr2WY0ykIJCn7Rqeq_aljYcz6j2h6WAa31CNkJQ) (Google Doc)

**Key Points**:
- Taleggio is Salesforce's centralized test management system
- Stores test cases in GUS (not scattered in Quip/Google Sheets)
- Enables traceability, visibility, and standardization
- Integration with Taleggio Chrome Plugin for easier authoring
- Agentforce integration for AI-powered test case generation

**Problem Being Solved**:
- 80% of defects are escape bugs (missed test coverage)
- Test cases scattered across Quip docs (hard to track)
- Blitz testing is superficial without centralized test plans
- Poor test case reuse (60% reuse possible with central storage)
- Manual test tracking costs hours of dev work

**Taleggio Workflow**:
1. Generate test cases (Taleggio Agentforce)
2. Associate with User Story
3. Assign reviewers
4. Complete feature → Move to QA
5. QA executes scenarios & marks status in GUS
6. DEV Blitz testing references central test suites
7. Track execution across multiple blitz runs

---

## GUS Objects

**From codesearch**: `git.soma.salesforce.com/Industries-Q3Q4/uf-trdc-sync/trdc/services/gus_client.py`

### ADM_Test_Scenario__c

Used for individual test scenarios. Key fields:
- `Execution_Type__c`: "Manual", "Automated", "Automatable"
- Linked to test suites (relationship field)

**Patterns**:
- Taleggio IDs: `T-XXXXXXX` (7+ digits)
- Test Case IDs: `W-XXXXXXX` (7+ digits)
- Both patterns accepted in GUS

---

## Test Coverage Principles

**From domain knowledge**:

### Test Types & Distribution

Based on industry best practices and Taleggio use cases:

1. **Functional Tests (30-40%)**
   - Happy path workflows
   - Core feature validation
   - User journeys end-to-end

2. **Integration Tests (25-30%)**
   - Component interactions
   - API calls and responses
   - Data flow between systems
   - Webhook triggers

3. **Edge Cases & Negative Tests (20-25%)**
   - Boundary values (min/max, empty, null)
   - Invalid inputs
   - Error handling
   - Permission checks
   - Security scenarios

4. **Performance Tests (15-20%)**
   - Load testing (concurrent users)
   - Scalability (large data volumes)
   - Response time benchmarks
   - Memory/CPU under load

**Rationale**: This distribution ensures comprehensive coverage while maintaining practical test execution time. Too many performance tests slow down blitz runs; too few miss scalability issues.

---

## HTML Formatting in GUS

**GUS Rich Text Fields**: 
- `Preconditions__c`: Rich Text Area
- `Test_Steps__c`: Rich Text Area

These render HTML in the GUS UI. **Plain text breaks formatting.**

### Standard Patterns

**Preconditions** (unordered list):
```html
<ul>
  <li>User is logged in as admin</li>
  <li>Test data exists in org</li>
  <li>Feature flag enabled</li>
</ul>
```

**Test Steps** (ordered list with action/expected):
```html
<ol>
  <li><strong>Action:</strong> Navigate to page<br/>
      <strong>Expected:</strong> Page loads</li>
  <li><strong>Action:</strong> Click button<br/>
      <strong>Expected:</strong> Modal opens</li>
</ol>
```

**Rationale**: 
- `<ul>` for preconditions → easy to scan setup requirements
- `<ol>` for test steps → shows execution sequence
- Bold labels → visual distinction between action and expected result
- `<br/>` → keeps action/expected together in same list item

---

## Salesforce CLI Patterns

**From testing**:

### Authentication
```bash
sf org login web --instance-url https://gus.my.salesforce.com --alias gus
```

### Create Records
```bash
sf data create record --target-org gus \
  --sobject ADM_Test_Suite__c \
  --values "Name='Suite' Description__c='Description'" \
  --json
```

**Key learnings**:
- Always use `--json` flag for parseable output
- Extract `result.id` from JSON response
- Escape single quotes in values: `\'`
- Field length limits enforced at GUS level

---

## Limitations & Known Issues

**From Taleggio doc**:

1. **PRD Quality Dependency**: Good PRDs → good test cases. Vague PRDs → generic tests.
2. **File Format Support**: Currently Quip-focused. Google Sheets via CSV only (not native). Excel support planned.
3. **Manual Upload**: Users must manually upload or use Chrome plugin. No automated Agentforce → GUS flow yet.
4. **Reporting Gap**: Multiple test runs tracked, but no built-in report generation.

**First-Hand Experience** (1C Yoddhas team):
- Taleggio can attach to work items, not epics directly
- Quip integration via Chrome plugin works well
- Google Sheets integration missing from installed plugin (despite docs claiming support)
- Error handling needs improvement (shows errors even after successful upload)

---

## Related Tools

### Taleggio Chrome Plugin
- Facilitates test case authoring from Quip
- Upload to GUS via browser
- Format conversion (Quip → GUS fields)

### Taleggio Agentforce
- AI-powered test case generation from PRD
- Currently in development
- Prompt engineering ongoing to improve thoroughness

### sf CLI
- Standard Salesforce command-line interface
- Supports GUS org connection
- SOQL queries and DML operations

---

## Open Questions

1. **Product Tag Lookup**: Can sf CLI query ADM_Product_Tag__c by name, or only by ID? (Answer: Need to test)
2. **Test Suite Status Values**: What picklist values exist for ADM_Test_Suite__c.Status__c? (Need GUS schema query)
3. **Taleggio ID Format**: When to use T- vs W- prefix? (T- appears to be Taleggio-specific, W- is standard GUS work item)
4. **Batch Upload Limits**: Is there a max number of scenarios per suite or per sf CLI call? (Unknown, need testing)

---

## Next Research Tasks

- [ ] Query GUS for ADM_Test_Suite__c schema to get all picklist values
- [ ] Query GUS for ADM_Test_Scenario__c schema to confirm field names
- [ ] Test bulk scenario creation (20-30 scenarios) to find performance limits
- [ ] Identify if Product_Tag__c is a lookup or text field
- [ ] Find example of Taleggio T-ID vs GUS W-ID usage patterns
