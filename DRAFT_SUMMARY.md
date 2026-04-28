# GUS Test Generator Expert - Draft Summary

**Status**: DRAFT (Tier 4 Evidence - Speculative)  
**Created**: 2026-04-28  
**Type**: Workflow Expert  
**Lifecycle Stage**: Draft → awaiting baseline and first usage

---

## What Was Built

A complete AI Suite expert for generating comprehensive test cases from PRD/HLD documents and uploading to GUS Taleggio.

### Files Created

```
gus-test-generator/
├── README.md                                    # Overview, installation, usage
├── DRAFT_SUMMARY.md                             # This file
├── .claude-plugin/
│   └── plugin.json                              # Local plugin manifest
├── skills/
│   └── gus-test-generator/
│       ├── SKILL.md                             # Entry point (415 lines)
│       ├── GLOSSARY.md                          # Domain terminology
│       └── guides/
│           ├── workflow.md                      # End-to-end process (350 lines)
│           └── gus-integration.md               # GUS objects, CLI commands (450 lines)
├── evals/
│   ├── objectives.md                            # 6 evaluation objectives
│   └── tasks/
│       └── trigger-generate-tests/              # Sample eval task
│           ├── task.toml
│           ├── instruction.md
│           └── tests/test.sh
└── research/
    └── taleggio-documentation.md                # Source materials

Total: ~1,400 lines of expert content
```

---

## Expert Capabilities

### 1. Input Collection
- Prompts for PRD (required), Product Tag (required)
- Prompts for HLD (optional), Work Item (optional)
- Validates inputs before generation

### 2. Test Scenario Generation
- Generates 15-25 comprehensive test scenarios
- Coverage across 4 test types:
  - Functional (30-40%): happy path, workflows
  - Integration (25-30%): APIs, component interactions
  - Edge Cases (20-25%): boundaries, errors, validation
  - Performance (15-20%): load, scale, response time
- Each scenario includes: ID, title, description, priority, test type, preconditions, steps, test data, automation feasibility

### 3. GUS Formatting
- Formats preconditions as HTML `<ul><li>` lists
- Formats test steps as HTML `<ol><li>` lists with Action/Expected structure
- Validates field lengths (Name: 80 chars, Title: 255 chars)
- Validates picklist values (Priority: P0-P3, Type: Functional/Integration/Edge Case/Performance)
- Escapes special characters for sf CLI

### 4. Preview & Validation
- Shows formatted test suite before upload
- Displays coverage breakdown by test type
- Shows sample scenarios with full formatting
- Verifies GUS authentication status

### 5. GUS Upload
- Creates ADM_Test_Suite__c record
- Creates ADM_Test_Scenario__c records linked to suite
- Links to work item if provided
- Handles partial failures gracefully
- Provides GUS URLs to view created records

---

## Routing Logic

The expert triggers on these user prompts:

| User says... | Expert routes to... |
|-------------|-------------------|
| "Generate test cases for this PRD" | `workflow.md` → collect inputs, generate, preview |
| "Upload test suite to GUS" | `gus-integration.md` → verify auth, format, upload |
| "How do I structure test scenarios?" | `workflow.md` → coverage requirements |
| "Link test suite to work item W-#####" | `gus-integration.md` → Work_Item__c field mapping |
| "What GUS fields do I need?" | `gus-integration.md` → ADM_Test_Scenario__c schema |

---

## Critical Rules Enforced

1. **MUST collect PRD and product tag before generating** → grounded in requirements
2. **MUST generate minimum 15 scenarios across 4 test types** → comprehensive coverage
3. **MUST format preconditions as HTML `<ul>` and steps as HTML `<ol>`** → GUS rendering
4. **MUST verify sf CLI authentication before upload** → prevent silent failures
5. **MUST show preview before creating GUS records** → user confirmation required

---

## Known Limitations

### Evidence Quality
- **Tier 4 (speculative)**: No real failure traces, no baseline comparison
- Built from written specification + existing Python script
- Assumes user behavior patterns that haven't been validated
- First 5-10 real usage sessions will reveal gaps

### Assumptions to Validate
- ✓ Users will ask "generate test cases" (may use different phrasing)
- ✓ Users have PRD documents with functional requirements (may be incomplete/vague)
- ✓ Users need 15-25 scenarios (may want more/less based on feature size)
- ✓ 30/25/20/15 coverage distribution is appropriate (may vary by domain)
- ✓ Users want to upload directly to GUS (may want preview-only workflow)

### Technical Gaps
- Product_Tag__c field type unknown (lookup vs text) → need GUS schema query
- ADM_Test_Suite__c.Status__c picklist values unknown → need schema query
- Bulk upload performance limits unknown → need testing with 20-30 scenarios
- Work item linking edge cases unknown → need testing with various work item types

---

## Next Steps (Path to Candidate)

### 1. Run Baseline (Required before publishing)

**Task**: Record how Claude behaves WITHOUT this expert

**Method**:
```bash
# For each of 5 representative PRDs:
# 1. Start fresh Claude conversation (no expert loaded)
# 2. Use prompt: "Generate comprehensive test cases for this PRD that I can upload to GUS Taleggio: [PRD]. Product tag: [tag]"
# 3. Record: scenario count, test type distribution, HTML formatting, field validation
# 4. Save conversation transcript
```

**Metrics to capture**:
- Total scenarios generated (target: ≥15)
- Test type distribution (target: 30/25/20/15)
- HTML formatting correctness (target: 100%)
- Priority/type field validation (target: 100%)
- Workflow completeness (target: collect → generate → preview → upload)

**Expected findings**: Baseline likely generates 5-10 scenarios (mostly functional), uses plain text formatting, doesn't verify GUS auth, skips preview step.

### 2. Local Testing

```bash
# Add as local plugin
# AI Suite → Settings → Plugins → Add local plugin → select gus-test-generator/

# Start new conversation
# Test trigger: "Generate test cases for [PRD]"
# Verify: skill loads, routes to workflow.md, collects inputs, generates scenarios
```

### 3. First Real Usage (5-10 sessions)

**Recruit**: 2-3 teams with upcoming features entering testing phase

**Collect**:
- Conversation traces from `~/.claude/projects/`
- User feedback on coverage, formatting, workflow
- GUS upload success/failure patterns
- Actual phrasing users employ ("generate tests", "create test suite", etc.)

### 4. Refine Based on Traces

**Analyze**:
- Common failure modes (what did expert miss?)
- Coverage gaps (which test types underrepresented?)
- Workflow friction (where did users get stuck?)
- Routing misses (when did expert fail to trigger?)

**Update**:
- SKILL.md routing examples (add observed user phrasings)
- workflow.md coverage guidance (adjust percentages if needed)
- gus-integration.md field mappings (fix any incorrect schemas)
- evals/objectives.md (replace speculation with observed patterns)

### 5. Write Eval Suite

Based on observed failures, create eval tasks:
- `trigger-*`: Test expert triggers on valid prompts, doesn't trigger on invalid
- `routing-*`: Test expert routes to correct guide for each user need
- `effectiveness-*`: Test expert improves outcomes vs baseline (coverage, formatting, workflow)
- `boundary-*`: Test expert handles edge cases (missing inputs, invalid data, auth failures)

Target: 6-8 eval tasks covering the 6 objectives in evals/objectives.md

### 6. Score Against Baseline

Run evals with and without expert:
```bash
# Without expert
harbor run --no-expert

# With expert  
harbor run --expert gus-test-generator

# Compare scores
harbor compare baseline.json expert.json
```

**Publishing gate**: Expert must improve ≥3 of 6 objectives vs baseline, with no regressions.

### 7. Publish to Registry

Once baseline + evals + local testing pass:

**PR 1** (Expert repo):
- Push to git.soma.salesforce.com/[your-org]/gus-test-generator
- Tag release: `v0.1.0`

**PR 2** (Expert registry):
- Add entry to `c360-ai-tooling/expert-registry/registry.yaml`:
  ```yaml
  - name: gus-test-generator
    url: git.soma.salesforce.com/[your-org]/gus-test-generator
    version: v0.1.0
    status: candidate
  ```

---

## Path to Expert (Post-Candidate)

After publishing as candidate:

### Accumulate Usage Evidence
- Target: 50-100 real sessions across multiple teams
- Track via traces in `~/.claude/projects/`
- Monitor GUS test suite creation patterns

### Run Optimization Loop
Every 2-4 weeks:
1. Collect new traces
2. Run trace-analyzer (identify recurring patterns)
3. Propose skill edits via skill-optimizer
4. Re-grade evals
5. Human review + merge changes

### Promotion Criteria
- **Volume**: 50+ distinct usage sessions
- **Efficacy**: Effectiveness evals consistently above baseline (re-graded multiple times)
- **Stability**: No regressions across 3+ optimization iterations

---

## Integration with Existing Script

Your Python script at `/Users/sahil.chhabra/.aisuite/notebook/.agents/artifacts/gus_test_case_generator.py` can be used as:

### Option 1: Reference Implementation
Expert guides Claude to follow the same workflow as the script:
- Collect inputs → Generate via Claude API → Format for GUS → Upload via sf CLI
- Script demonstrates the "happy path" the expert should teach

### Option 2: MCP Server Tool
Convert script to MCP server, expose as tool Claude can invoke:
```python
# server.py at repo root
@server.call_tool()
async def generate_test_cases(prd_path: str, product_tag: str, 
                               hld_path: Optional[str] = None,
                               work_item: Optional[str] = None):
    # Call existing script logic
    result = generate_and_upload(prd_path, product_tag, hld_path, work_item)
    return result
```

Expert becomes orchestrator: collect inputs → call tool → present results

### Recommendation
**Start with Option 1** (reference implementation). After candidate promotion, consider Option 2 if users prefer tool-based workflow.

---

## Questions for First Usage

Ask these during first 5-10 sessions:

1. **Phrasing**: How did you ask for test generation? ("generate test cases", "create test suite", other?)
2. **Coverage**: Was 15-25 scenarios too many, too few, or about right?
3. **Test Type Distribution**: Did 30/25/20/15 split feel appropriate for your feature?
4. **Priority Assignment**: Were P0-P3 priorities reasonable, or did you adjust?
5. **HTML Formatting**: Did test steps render correctly in GUS UI?
6. **Workflow**: Was preview step helpful, or did you want direct upload?
7. **GUS Integration**: Did sf CLI commands work smoothly, or were there issues?
8. **Missing**: What did expert not cover that you needed?

---

## Maintenance

### Weekly (During First Month)
- Check traces for new usage patterns
- Monitor GUS upload success rate
- Collect user feedback

### Monthly (After Stabilization)
- Run optimization loop
- Update evals based on new failure modes
- Refresh documentation with new examples

### Quarterly
- Review promotion criteria progress
- Update research/ with new Taleggio features
- Sync with Taleggio team on API changes

---

## Success Metrics

### Short Term (First Month)
- [ ] 10+ teams use expert for real PRD test generation
- [ ] 80%+ GUS upload success rate
- [ ] Positive feedback on test coverage quality
- [ ] No major routing failures (expert triggers correctly)

### Medium Term (3 Months)
- [ ] 50+ usage sessions logged
- [ ] Baseline comparison shows improvement on ≥4 of 6 objectives
- [ ] Eval suite stabilized (passing consistently)
- [ ] Published as candidate in registry

### Long Term (6-12 Months)
- [ ] 100+ usage sessions across 20+ teams
- [ ] Optimization loop has run 5+ iterations
- [ ] Promoted to expert status
- [ ] Adopted as standard workflow for test case generation

---

## Contact

**Expert Author**: [Your name/contact]  
**Repository**: [To be created at git.soma.salesforce.com/[org]/gus-test-generator]  
**Slack Channel**: [To be created for user feedback]

---

## Acknowledgments

- **Taleggio Team**: For centralized test management vision and GUS integration
- **Expert Curator**: For evidence-based expert development methodology
- **1C Yoddhas Team**: For first-hand Taleggio usage feedback and pain points
