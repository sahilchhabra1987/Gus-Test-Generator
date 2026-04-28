# GUS Test Generator Expert

AI Suite expert for generating comprehensive test cases from PRD/HLD documents and uploading to GUS Taleggio.

⚠️ **Draft Status**: This expert was built with tier-4 evidence (written examples, no failure traces). Expect heavy revision after first real usage. See [Maturity](#maturity) section.

---

## What This Expert Does

Guides Claude through the complete workflow of:
1. Collecting PRD/HLD inputs and product tag
2. Generating 15-25 comprehensive test scenarios covering:
   - Functional tests (happy path, workflows)
   - Integration tests (component interactions, APIs)
   - Edge cases (boundaries, errors, validation)
   - Performance tests (load, scale, response time)
3. Formatting test cases for GUS ADM_Test_Suite__c and ADM_Test_Scenario__c
4. Uploading via Salesforce CLI with proper field mappings and HTML formatting
5. Linking to work items when applicable

---

## Installation

### For Local Testing

```bash
# Clone this repo
git clone <repo-url>
cd gus-test-generator

# Add as local plugin in AI Suite
# Settings → Plugins → Add local plugin → Select this directory
```

### From Registry (when published)

```bash
# Install via AI Suite marketplace
# Search for "gus-test-generator"
```

---

## Usage

### Basic Usage

```
Generate test cases for this PRD:
[paste PRD content or provide path]

Product Tag: Revenue Cloud
```

Claude will:
1. Ask for optional HLD and work item
2. Generate comprehensive test scenarios
3. Show preview for review
4. Verify GUS authentication
5. Upload to GUS and provide URL

### With All Options

```
Generate test cases and upload to GUS:
- PRD: /path/to/prd.md
- HLD: /path/to/hld.md  
- Product Tag: CPQ
- Work Item: W-12345678
```

### Preview Only (No Upload)

```
Generate test cases for this PRD but don't upload yet:
[PRD content]

I want to review before uploading to GUS.
```

---

## Prerequisites

### 1. Salesforce CLI

Install from https://developer.salesforce.com/tools/salesforcecli

```bash
sf --version
```

### 2. GUS Authentication

```bash
sf org login web --instance-url https://gus.my.salesforce.com --alias gus
```

Verify:
```bash
sf data query --target-org gus --query "SELECT Id FROM User LIMIT 1"
```

### 3. GUS Permissions

User must have:
- Create access on ADM_Test_Suite__c
- Create access on ADM_Test_Scenario__c
- Read access on ADM_Work__c (if linking to work items)
- Read access on ADM_Product_Tag__c (if using product tags)

---

## File Structure

```
gus-test-generator/
├── README.md                           # This file
├── skills/
│   └── gus-test-generator/
│       ├── SKILL.md                    # Entry point, routing
│       └── guides/
│           ├── workflow.md             # Step-by-step generation process
│           └── gus-integration.md      # GUS objects, CLI commands, HTML formatting
├── evals/
│   ├── objectives.md                   # Eval objectives (to be written after first usage)
│   └── tasks/                          # Harbor eval tasks (to be written)
└── research/
    └── taleggio-documentation.md       # Source materials
```

---

## Maturity

**Current Status:** Draft (Tier 4 Evidence)

### What This Means

- Built from written specification, not observed failure traces
- No baseline comparison (Claude's behavior without this expert is unknown)
- No eval suite yet (will be created after first real usage)
- Expect to revise heavily based on actual user sessions

### Path to Candidate

To promote to candidate, need:
1. **Baseline runs**: Record how Claude generates test cases without this expert (3-5 sessions)
2. **Real usage**: At least 5-10 teams use this expert for actual PRD test generation
3. **Eval suite**: Minimum 6-8 eval tasks (trigger, routing, effectiveness, boundary)
4. **Scorecard**: Demonstrate improvement vs baseline on effectiveness tests
5. **Local testing**: Verify skill loads, triggers correctly, guides resolve

### Path to Expert

From candidate to expert requires:
- **Volume**: 50-100+ real usage sessions across multiple teams
- **Efficacy**: Consistent improvement over baseline (measured via evals)
- **Stability**: No regressions across multiple optimization iterations

---

## Contributing

### Found an Issue?

1. **Capture the trace**: Save the conversation where Claude got it wrong
2. **Note the gap**: What should Claude have done vs what it did?
3. **Open issue** with trace path and specific failure

### Want to Improve?

1. **Run baseline**: Test Claude without this expert, record results
2. **Test with expert**: Same prompt with expert loaded, compare
3. **Propose change**: PR with evidence showing improvement

---

## Methodology

### Evidence Tier

**Tier 4** (Last resort): Written example + expected behavior

This expert was built proactively for a new capability (Claude has not been asked to generate GUS Taleggio test cases in a structured workflow before). 

**Documented assumptions:**
- Users will ask Claude to "generate test cases" or similar phrasing
- Users have PRD documents that describe functional requirements
- Users need comprehensive coverage (not just happy path tests)
- Users need proper GUS field mapping and HTML formatting
- Users want to upload directly to GUS via sf CLI

**These assumptions MUST be validated** via real usage. First 5-10 usage sessions will reveal:
- Actual phrasing users employ
- Quality of PRD inputs provided
- Coverage expectations vs what's generated
- GUS integration pain points
- Gaps in routing or instructions

### Research Sources

1. **GUS Taleggio documentation**: [Taleggio Quip doc](https://salesforce.quip.com/rm8xAT0BgiSy)
2. **Existing Python script**: `/Users/sahil.chhabra/.aisuite/notebook/.agents/artifacts/gus_test_case_generator.py`
3. **Codesearch**: GUS tellagio integration patterns in Industry codebases
4. **Google Docs**: Taleggio use cases and workflow documentation

### Domain Knowledge Encoded

**Test Coverage Principles:**
- 30-40% functional (happy path, workflows)
- 25-30% integration (APIs, component interactions)
- 20-25% edge cases (boundaries, errors)
- 15-20% performance (load, scale)
- Minimum 15-25 total scenarios

**GUS Field Mappings:**
- ADM_Test_Suite__c: Name (80 char), Description__c, Work_Item__c, Total_Test_Scenarios__c
- ADM_Test_Scenario__c: Name, Test_Suite__c, Title__c (255 char), Description__c, Priority__c (P0-P3), Type__c, Preconditions__c (HTML), Test_Steps__c (HTML), Test_Data__c, Execution_Type__c, Estimated_Time__c

**HTML Formatting:**
- Preconditions: `<ul><li>` lists
- Test Steps: `<ol><li>` lists with `<strong>Action/Expected</strong>` formatting
- Special char escaping for sf CLI

---

## Related Resources

- **Taleggio Documentation**: https://confluence.internal.salesforce.com/display/TALEGGIO
- **GUS**: https://gus.lightning.force.com
- **Salesforce CLI**: https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta
- **Expert Curator**: `/expert-curator` skill for expert lifecycle management

---

## Support

For questions or issues:
1. Check [workflow.md](skills/gus-test-generator/guides/workflow.md) for process guidance
2. Check [gus-integration.md](skills/gus-test-generator/guides/gus-integration.md) for technical details
3. Open issue with trace path if Claude misbehaves
4. Contact expert maintainer: [Your contact info]

---

## License

Internal Salesforce tool - for Salesforce employee use only.
