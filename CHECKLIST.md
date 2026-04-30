# Expert Draft Checklist

Track progress from draft → candidate → expert.

---

## ✅ Draft Complete (DONE)

- [x] SKILL.md created (under 500 lines)
- [x] YAML frontmatter with name + description
- [x] Scope section (handles / NOT for)
- [x] Critical rules with consequences
- [x] Routing examples (concrete prompts → guides)
- [x] Guide links
- [x] workflow.md created (step-by-step process)
- [x] gus-integration.md created (technical reference)
- [x] ACTUAL-GUS-SCHEMA.md created (verified field mappings from production GUS)
- [x] GLOSSARY.md created (domain terms)
- [x] README.md created (overview, installation, usage)
- [x] plugin.json created (local testing manifest)
- [x] evals/objectives.md created (6 objectives)
- [x] Sample eval task created
- [x] research/ documentation created

**Status**: Draft is complete and ready for local testing

---

## ⏳ Candidate Readiness

### Evidence Requirements

- [x] **Baseline runs**: 1 real session tested (Password Reset PRD) — see evals/baseline.md
  - [x] Record scenario counts, coverage, formatting — documented in evals/baseline.md
  - [x] Document what Claude gets wrong — 6 specific mistakes in evals/baseline.md
  - [ ] 3-5 PRDs tested (only 1 so far — need 2-4 more)

- [x] **Usage estimate documented** (evals/baseline.md):
  - [x] Number of users: 1 (sahil.chhabra1987 — author)
  - [x] Frequency: Testing phase — 2 sessions during development
  - [x] Teams: 1C Yoddhas (Salesforce)

- [x] **3+ distinct behaviors validated** (see evals/baseline.md):
  - [x] Behavior 1: HTML formatting in Test_Details__c (verified in production GUS)
  - [x] Behavior 2: Correct GUS object schema — all 3 objects created successfully
  - [x] Behavior 3: Comprehensive 4-type test coverage (18 scenarios generated)

- [x] **Specific mistakes documented** (6 real schema errors — evals/baseline.md):
  - [x] Mistake 1: `Name` field read-only on ADM_Test_Suite__c → use Suite_Name__c
  - [x] Mistake 2: `Team__c` required on ADM_Test_Suite__c → must query first
  - [x] Mistake 3: `Test_Suite__c` doesn't exist on ADM_Test_Scenario__c → use junction object
  - [x] Mistake 4: `Description__c` doesn't exist → use Test_Details__c
  - [x] Mistake 5: `Title__c` doesn't exist → use Test_Name__c
  - [x] Mistake 6: Plain text in Test_Details__c → use HTML
  - [x] Mistake 7: `Scrum_Team__c` on ADM_Test_Scenario__c is read-only → do not set

### Quality Requirements

- [x] **SKILL.md under 500 lines**: Current: ~415 ✓
- [x] **Frontmatter name matches directory**: ✓
- [x] **Description under 300 chars**: ✓
- [x] **Examples use real code paths**: N/A (no code references)
- [x] **No hypothetical examples**: ✓

### Eval Requirements

- [x] **6+ eval tasks written**:
  - [x] `trigger-generate-tests` (trigger test)
  - [x] `trigger-boundary-unit-tests` (trigger boundary)
  - [x] `trigger-boundary-execution` (trigger boundary)
  - [x] `routing-input-collection` (routing test)
  - [x] `effectiveness-html-formatting` (effectiveness test)
  - [x] `effectiveness-coverage-types` (effectiveness test)
  - [x] `boundary-missing-prd` (boundary test)

- [x] **Eval scorecard exists**: evals/scorecard.md
  - [x] Baseline scores recorded (from 1 real session + behavioral estimates)
  - [x] Expert scores recorded
  - [x] Improvement demonstrated on 6/6 objectives (gate: ≥3) ✅
  - [x] No regressions

### Testing Requirements

- [ ] **Local test passed**:
  - [ ] Plugin loads in AI Suite
  - [ ] Skill triggers on example prompts
  - [ ] Guides resolve correctly
  - [ ] No file path errors

- [x] **First real usage** (partial — 2 sessions same user):
  - [x] Session 1: User sahil.chhabra1987, Feature Password Reset (PRD), Outcome: Full suite generated + uploaded to GUS ✅
  - [x] Session 2: User sahil.chhabra1987, Feature Advanced Search & Filtering, Outcome: 20 scenarios generated + uploaded, all linked via junction object ✅
  - [x] Session 3: User sahil.chhabra1987, Feature Notifications & Alerts, Outcome: 20 scenarios generated + uploaded, all linked via junction object ✅
  - [ ] Session 4: User ___ (different user), Feature ___, Outcome ___
  - [ ] Session 5: User ___ (different user), Feature ___, Outcome ___

- [x] **Trace analysis complete** (partial):
  - [x] Common failure patterns identified — 6 GUS schema errors documented
  - [x] SKILL.md updated based on findings (3 new critical rules added)
  - [ ] Routing misses documented (need more sessions)
  - [ ] Coverage gaps noted (need more sessions)

### Publishing Requirements

- [x] **Git repo created**: https://github.com/sahilchhabra1987/Gus-Test-Generator
- [x] **Repo visibility**: Public ✓
- [x] **Expert repo ready**:
  - [x] All files committed
  - [x] README complete
  - [x] Release tagged (v1.0.0) ✅

- [x] **Registry PR open**: https://git.soma.salesforce.com/c360-ai-tooling/expert-registry/pull/238
  - [x] Entry added to registry.yaml
  - [x] Points to correct repo
  - [ ] Status: candidate (currently draft — needs full candidate evidence first)

**Gate**: Remaining blockers before candidate: local plugin test + 3+ more real usage sessions from other users

---

## ⏳ Expert Promotion (TODO - After Candidate)

### Volume Requirements

- [ ] **50+ usage sessions** logged
- [ ] **10+ teams** using across org
- [ ] **Multiple sprints** of usage (≥3 sprints)

### Efficacy Requirements

- [ ] **Effectiveness tests passing** (vs baseline):
  - [ ] Re-graded after iteration 1: ___% pass
  - [ ] Re-graded after iteration 2: ___% pass
  - [ ] Re-graded after iteration 3: ___% pass
  - [ ] Consistent improvement trend

- [ ] **User feedback positive**:
  - [ ] Coverage quality: ___/5 average rating
  - [ ] Workflow intuitiveness: ___/5 average rating
  - [ ] GUS integration smoothness: ___/5 average rating

### Stability Requirements

- [ ] **Optimization loop run ≥3 times**:
  - [ ] Iteration 1: Date ___, Changes ___
  - [ ] Iteration 2: Date ___, Changes ___
  - [ ] Iteration 3: Date ___, Changes ___

- [ ] **No regressions** across iterations:
  - [ ] Baseline evals still passing
  - [ ] No new failure modes introduced
  - [ ] User satisfaction stable or improving

### Promotion

- [ ] **Update registry.yaml**: Change status to "expert"
- [ ] **Update README.md**: Remove tier-4 warning, add maturity badge
- [ ] **Announce**: Slack/email to org

**Gate**: Promotion happens when all volume + efficacy + stability bars met

---

## 📊 Metrics Tracking

### Baseline (No Expert) — from evals/baseline.md

| PRD | Scenarios | Functional | Integration | Edge | Performance | HTML Format | GUS Upload |
|-----|-----------|------------|-------------|------|-------------|-------------|------------|
| Password Reset | ~7 | ~90% | ~10% | ~0% | ~0% | 0% | 0% |
| 2 | | | | | | | |
| 3 | | | | | | | |
| 4 | | | | | | | |
| 5 | | | | | | | |

### With Expert

| PRD | Scenarios | Functional | Integration | Edge | Performance | HTML Format | GUS Upload |
|-----|-----------|------------|-------------|------|-------------|-------------|------------|
| Password Reset | 18 | ~35% | ~28% | ~22% | ~15% | 100% | 100% ✅ |
| 2 | | | | | | | |
| 3 | | | | | | | |
| 4 | | | | | | | |
| 5 | | | | | | | |

### Improvement (1 PRD)

| Metric | Baseline | Expert | Improvement |
|--------|----------|--------|-------------|
| Scenarios generated | ~7 | 18 | +157% |
| Functional coverage | ~90% | ~35% | Balanced ✅ |
| Integration coverage | ~10% | ~28% | +180% |
| Edge case coverage | ~0% | ~22% | New ✅ |
| Performance coverage | ~0% | ~15% | New ✅ |
| HTML formatting | 0% | 100% | +100% |
| GUS upload success | 0% | 100% | +100% |

---

## 🔄 Optimization Loop Tracker

### Iteration 1 (In Progress)
- **Date**: 2026-04-28
- **Traces analyzed**: 2 sessions (same user, same feature)
- **Patterns found**: 6 GUS schema errors, HTML rendering issue
- **Changes merged**: 3 new critical rules in SKILL.md, ACTUAL-GUS-SCHEMA.md added
- **Re-grade result**: Pending Harbor automation

### Iteration 2
- **Date**: ___
- **Traces analyzed**: ___ sessions
- **Patterns found**: ___
- **Changes merged**: ___
- **Re-grade result**: ___

### Iteration 3
- **Date**: ___
- **Traces analyzed**: ___ sessions
- **Patterns found**: ___
- **Changes merged**: ___
- **Re-grade result**: ___

---

## 📅 Timeline

| Milestone | Target Date | Actual Date | Status |
|-----------|-------------|-------------|--------|
| Draft complete | 2026-04-28 | 2026-04-28 | ✅ Done |
| Real-world schema validation | 2026-04-28 | 2026-04-28 | ✅ Done |
| Eval suite written (7 tasks) | 2026-04-29 | 2026-04-29 | ✅ Done |
| Eval scorecard created | 2026-04-29 | 2026-04-29 | ✅ Done |
| Local plugin load test | | | ⏳ |
| First real usage (5 sessions, multi-user) | | | ⏳ |
| Trace analysis complete | | | ⏳ |
| Candidate published | | | ⏳ |
| 50 usage sessions | | | ⏳ |
| Optimization loop 1 | | | ⏳ |
| Optimization loop 2 | | | ⏳ |
| Optimization loop 3 | | | ⏳ |
| Expert promotion | | | ⏳ |

---

## 🎯 Success Criteria

### Draft → Candidate
- [x] Evidence gathered (1 real session with production GUS verification)
- [x] Evals written (7 tasks) and scorecard showing improvement on 6/6 objectives
- [ ] Local test successful (plugin loads in AI Suite)
- [x] Registry PR open (#238)
- [ ] 3+ real usage sessions from different users
- [ ] Status updated to candidate in registry.yaml

### Candidate → Expert
- [ ] 50+ usage sessions
- [ ] 3+ optimization iterations
- [ ] Consistent efficacy improvement
- [ ] No stability regressions
- [ ] Positive user feedback

---

## Notes

**2026-04-28**: Real test run on Password Reset PRD. Discovered 6 GUS schema issues. All fixed and documented in ACTUAL-GUS-SCHEMA.md. HTML formatting verified in production GUS UI.

**2026-04-29**: Eval suite expanded to 7 tasks. Scorecard created. Baseline documented. CHECKLIST updated. All files pushed to GitHub v1.0.0.

**2026-04-29 (continued)**: 2 additional PRD sessions completed (Search & Filtering, Notifications & Alerts). 58 total scenarios uploaded to production GUS across 3 PRDs. New schema finding: Scrum_Team__c on ADM_Test_Scenario__c is read-only. Evidence upgraded to Tier 2.
