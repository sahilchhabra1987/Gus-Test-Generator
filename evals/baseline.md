# Baseline Behavior — Claude Without Expert

**Date Recorded:** 2026-04-28  
**Method:** Observed during expert development session + known Claude default behavior  
**Evidence Quality:** Tier 3 (partial — 1 real session + behavioral knowledge)

---

## What Claude Does WITHOUT This Expert

### Prompt Used
```
Generate comprehensive test cases for this PRD that I can upload to GUS Taleggio: [PRD content]. Product tag: [tag]
```

### Behavior Observed

#### ❌ Input Collection
- **Skips PRD requirement check** — generates immediately even if PRD is vague
- **Ignores Product Tag** — doesn't ask for it, doesn't include it in output
- **No HLD prompt** — misses opportunity for better integration coverage

#### ❌ Test Coverage
- Generates **5-8 scenarios** (vs expert's 15-25)
- **Mostly functional / happy path** — integration, edge cases, performance underrepresented
- No consistent test ID scheme (TS-001, TS-002...)
- Priority distribution: often all "P0" or "High/Medium/Low" (not GUS picklist values)

#### ❌ GUS Field Formatting
- **Plain text output** — no HTML tags
- Uses wrong field names:
  - `Title__c` (doesn't exist → use `Test_Name__c`)
  - `Description__c` (doesn't exist → use `Test_Details__c`)
  - `Name` (read-only → use `Suite_Name__c` for suites)
- Tries to set `Test_Suite__c` directly on scenario (field doesn't exist → use junction object)
- Omits `Team__c` on suite creation (required field → upload fails)
- Omits `Regression__c` and `Obsolete__c` on scenarios (required fields → upload fails)

#### ❌ Workflow
- **No preview step** — jumps directly to sf CLI commands
- **No auth check** — doesn't verify `sf` is authenticated to GUS
- **No confirmation gate** — runs upload without asking user
- Provides sf CLI commands with wrong field names (upload fails immediately)

#### ❌ GUS Upload
When sf CLI commands fail (due to wrong field names), Claude:
- Sometimes tries different field names randomly
- Sometimes stops and says "I'm not sure of the exact field names"
- Rarely discovers the correct schema on first attempt
- Does not know about ADM_Related_Test_Scenario__c junction object

---

## Specific Mistakes Documented

These are the exact errors that occurred when uploading to GUS without the expert's schema knowledge:

| # | Mistake | Error Message | Correct Approach |
|---|---------|---------------|-----------------|
| 1 | Setting `Name` on ADM_Test_Suite__c | `INVALID_FIELD_FOR_INSERT_UPDATE: Name` | Use `Suite_Name__c` |
| 2 | Omitting `Team__c` on ADM_Test_Suite__c | `REQUIRED_FIELD_MISSING: Team__c` | Query ADM_Scrum_Team__c, provide ID |
| 3 | Setting `Test_Suite__c` on ADM_Test_Scenario__c | `INVALID_FIELD: Test_Suite__c` | Use ADM_Related_Test_Scenario__c junction |
| 4 | Using `Description__c` on ADM_Test_Scenario__c | `INVALID_FIELD: Description__c` | Use `Test_Details__c` |
| 5 | Using `Title__c` on ADM_Test_Scenario__c | `INVALID_FIELD: Title__c` | Use `Test_Name__c` |
| 6 | Plain text in `Test_Details__c` | No error, but renders as wall of text in GUS | Use HTML (`<p>`, `<ul>`, `<ol>`) |

---

## Baseline Metrics (Password Reset PRD Test)

| Metric | Without Expert | With Expert | Target |
|--------|---------------|-------------|--------|
| Scenarios generated | ~7 | 18 | ≥15 |
| Functional coverage | ~90% | ~35% | 30-40% |
| Integration coverage | ~10% | ~28% | 25-30% |
| Edge case coverage | ~0% | ~22% | 20-25% |
| Performance coverage | ~0% | ~15% | 15-20% |
| HTML formatting correct | 0% | 100% | 100% |
| Field names correct | 0% | 100% | 100% |
| GUS upload success | 0% (all failed) | 100% | 100% |
| Preview step included | No | Yes | Yes |
| Junction object used | No | Yes | Yes |

---

## 3 Validated Behaviors

These behaviors were confirmed working in the real test session (2026-04-28):

### Behavior 1: HTML Formatting in Test_Details__c
**What the expert does:** Generates `Test_Details__c` content using HTML — `<p>` for sections, `<ul>/<li>` for preconditions, `<ol>/<li>` for numbered steps, `<strong>` for labels, `<br/>` for line breaks within steps.

**Verified:** Uploaded to production GUS on 2026-04-28. Rendered correctly in Taleggio UI — preconditions showed as bullet list, steps showed as numbered list with Action/Expected pairs.

**Without expert:** Plain text rendered as one unformatted paragraph in GUS UI.

---

### Behavior 2: Correct GUS Object Schema
**What the expert does:** Uses verified field names — `Suite_Name__c` for suite title, `Test_Name__c` for scenario title, `Test_Details__c` for description. Queries `ADM_Scrum_Team__c` for Team__c ID before creating suite. Uses `ADM_Related_Test_Scenario__c` junction to link suite ↔ scenario.

**Verified:** All 3 records created successfully in production GUS on 2026-04-28 with zero schema errors.

**Without expert:** 6 different field name errors, upload completely fails.

---

### Behavior 3: Comprehensive Test Coverage
**What the expert does:** Generates minimum 15 scenarios across 4 test types with specific coverage targets (30/25/20/15 split). Assigns realistic P0-P3 priorities. Gives each scenario a unique TS-### ID.

**Verified:** Generated 18 scenarios on Password Reset PRD — 6 functional, 5 integration, 4 edge cases, 3 performance. Priority spread across P0 (3), P1 (8), P2 (5), P3 (2).

**Without expert:** ~7 scenarios, mostly functional, no consistent IDs, unrealistic priority distribution.
