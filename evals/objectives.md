# Eval Objectives

Evaluation objectives for GUS Test Generator expert. These will be refined after first real usage.

---

## Status

⚠️ **Preliminary**: These objectives are speculative (tier 4 evidence). After first 5-10 real usage sessions, update these objectives based on:
- Actual user prompts observed
- Common failure modes discovered
- Coverage gaps identified
- GUS integration issues encountered

---

## Objective 1: Trigger Recognition

**Task**: Recognize when user wants to generate test cases for GUS

**Success Criteria**:
- Expert triggers on "generate test cases", "create test suite", "test scenarios for GUS"
- Expert triggers when PRD is provided with request for tests
- Expert does NOT trigger for automated test code generation (unit tests, integration test code)
- Expert does NOT trigger for test execution or result tracking

**Failure Modes**:
- Triggers on unit test generation requests (should route to code generation tools)
- Doesn't trigger on valid test case generation requests
- Triggers when user just wants to view existing GUS test suites

**Eval Tasks**: `trigger-generate-tests`, `trigger-boundary-unit-tests`, `trigger-boundary-execution`

---

## Objective 2: Input Collection

**Task**: Collect all required inputs before generating test cases

**Success Criteria**:
- Always asks for PRD (required)
- Always asks for Product Tag (required)
- Asks for HLD (optional, but prompts user)
- Asks for Work Item (optional, but prompts user)
- Does NOT proceed with generation until PRD and Product Tag are provided

**Failure Modes**:
- Generates test cases without PRD (produces generic, unusable tests)
- Skips Product Tag (test suite can't be properly tagged in GUS)
- Doesn't offer HLD option (misses opportunity for better integration test coverage)
- Proceeds with incomplete inputs

**Eval Tasks**: `routing-input-collection`, `boundary-missing-prd`, `boundary-missing-tag`

---

## Objective 3: Comprehensive Coverage

**Task**: Generate test scenarios covering all 4 test types with proper distribution

**Success Criteria**:
- Generates minimum 15 scenarios
- Includes functional tests (30-40% of total)
- Includes integration tests (25-30% of total)
- Includes edge cases/negative tests (20-25% of total)
- Includes performance tests (15-20% of total)
- Each scenario has unique ID, title, description, priority, test type

**Failure Modes**:
- Generates only happy-path functional tests (misses edge cases, integration, performance)
- Generates fewer than 15 scenarios (insufficient coverage)
- Skips performance tests entirely
- All scenarios marked P0 (priority distribution unrealistic)
- Scenario IDs not unique or sequential

**Eval Tasks**: `effectiveness-coverage-types`, `effectiveness-coverage-count`, `effectiveness-priority-distribution`

---

## Objective 4: GUS Field Formatting

**Task**: Format test scenarios correctly for GUS ADM_Test_Scenario__c

**Success Criteria**:
- Preconditions formatted as HTML `<ul><li>` list
- Test steps formatted as HTML `<ol><li>` list with Action/Expected
- Titles under 255 characters
- Priority values are valid (P0, P1, P2, P3)
- Test type values are valid (Functional, Integration, Edge Case, Performance)
- Special characters escaped for sf CLI

**Failure Modes**:
- Plain text preconditions/steps (breaks GUS UI rendering)
- Invalid priority values (e.g., "Critical" instead of "P0")
- Invalid test type values (e.g., "Unit Test" instead of "Functional")
- Title exceeds 255 chars (truncated or upload fails)
- Unescaped quotes break sf CLI command

**Eval Tasks**: `effectiveness-html-formatting`, `effectiveness-field-validation`, `boundary-long-titles`

---

## Objective 5: Preview Before Upload

**Task**: Show formatted test suite preview and get user confirmation before GUS upload

**Success Criteria**:
- Displays test suite summary (name, total scenarios, coverage breakdown)
- Shows sample scenarios (at least 3) with full formatting
- Checks GUS authentication status before offering upload
- Waits for explicit user confirmation before executing sf CLI commands
- Does NOT upload automatically without preview

**Failure Modes**:
- Uploads to GUS immediately without showing preview
- Doesn't verify sf CLI authentication (upload fails silently)
- Preview doesn't show HTML formatting (user can't validate)
- Proceeds with upload even if user said "wait"

**Eval Tasks**: `effectiveness-preview-shown`, `effectiveness-auth-check`, `boundary-auto-upload`

---

## Objective 6: GUS Upload Success

**Task**: Successfully create test suite and scenarios in GUS via sf CLI

**Success Criteria**:
- Creates ADM_Test_Suite__c record first
- Creates ADM_Test_Scenario__c records linked to suite
- Links to work item if provided and work item exists
- Provides GUS URLs for viewing created suite
- Handles partial failures gracefully (reports which scenarios succeeded/failed)

**Failure Modes**:
- Creates scenarios before suite (fails because Test_Suite__c is required)
- Doesn't link to work item even when provided
- Silent failure (no error message when upload fails)
- Doesn't provide GUS URL to view results
- Stops entirely on first scenario failure (should continue and report summary)

**Eval Tasks**: `effectiveness-upload-order`, `effectiveness-work-item-link`, `effectiveness-url-provided`

---

## Baseline Comparison

### To establish baseline:

1. **Select 5 representative PRDs** from different domains (e.g., auth, payments, analytics, UI components, API integrations)

2. **For each PRD, run without expert**:
   - Fresh Claude conversation, no expert loaded
   - Prompt: "Generate comprehensive test cases for this PRD that I can upload to GUS Taleggio: [PRD content]. Product tag: [tag]"
   - Record: number of scenarios, test type distribution, HTML formatting, coverage gaps

3. **Run with expert loaded**:
   - Same PRDs, same base prompt
   - Record: same metrics as baseline
   - Compare: did expert improve coverage, formatting, workflow?

4. **Metrics to compare**:
   - Total scenarios generated (target: ≥15)
   - Test type distribution (target: 30/25/20/15 functional/integration/edge/performance)
   - HTML formatting correctness (target: 100%)
   - Field validation (priority, test type values) (target: 100%)
   - Workflow completeness (collect inputs → generate → preview → upload) (target: all steps present)

### Expected improvements:

- **Coverage**: Baseline likely generates 5-10 scenarios (mostly functional), expert generates 15-25 (balanced across types)
- **Formatting**: Baseline likely uses plain text, expert uses proper HTML
- **Workflow**: Baseline likely generates and outputs, expert adds preview and GUS upload orchestration
- **Field validation**: Baseline may use invalid values, expert ensures GUS-compatible values

---

## Next Steps

1. **Run baseline**: Test Claude without expert on 5 PRDs, record results
2. **First real usage**: Get 5-10 teams to use expert for actual PRD test generation
3. **Analyze traces**: Read `~/.claude/projects/` traces to identify patterns
4. **Refine objectives**: Update this doc based on observed behavior
5. **Write eval tasks**: Create Harbor tasks for each objective
6. **Score against baseline**: Measure improvement vs no-expert baseline
