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
- [x] GLOSSARY.md created (domain terms)
- [x] README.md created (overview, installation, usage)
- [x] plugin.json created (local testing manifest)
- [x] evals/objectives.md created (6 objectives)
- [x] Sample eval task created
- [x] research/ documentation created

**Status**: Draft is complete and ready for local testing

---

## ⏳ Candidate Readiness (TODO)

### Evidence Requirements

- [ ] **Baseline runs**: 3-5 PRDs tested WITHOUT expert
  - [ ] Record scenario counts, coverage, formatting
  - [ ] Save conversation transcripts
  - [ ] Document what Claude gets wrong

- [ ] **Usage estimate documented**: 
  - [ ] Number of users: ___
  - [ ] Frequency: ___ times per week/sprint
  - [ ] Teams: ___

- [ ] **3+ distinct behaviors validated**: 
  - [ ] Behavior 1: ___
  - [ ] Behavior 2: ___
  - [ ] Behavior 3: ___

- [ ] **Specific mistakes documented**:
  - [ ] Mistake 1: ___
  - [ ] Mistake 2: ___
  - [ ] Mistake 3: ___

### Quality Requirements

- [ ] **SKILL.md under 500 lines**: Current: ~415 ✓
- [ ] **Frontmatter name matches directory**: ✓
- [ ] **Description under 300 chars**: ✓
- [ ] **Examples use real code paths**: N/A (no code references)
- [ ] **No hypothetical examples**: ✓

### Eval Requirements

- [ ] **6+ eval tasks written**:
  - [ ] 2+ trigger tests
  - [ ] 2+ routing tests
  - [ ] 2+ effectiveness tests
  - [ ] 1+ boundary test

- [ ] **Eval scorecard exists**: evals/scorecard.md
  - [ ] Baseline scores recorded
  - [ ] Expert scores recorded
  - [ ] Improvement demonstrated on ≥3 objectives
  - [ ] No regressions

### Testing Requirements

- [ ] **Local test passed**:
  - [ ] Plugin loads in AI Suite
  - [ ] Skill triggers on example prompts
  - [ ] Guides resolve correctly
  - [ ] No file path errors

- [ ] **First real usage** (5-10 sessions):
  - [ ] Session 1: User ___, Feature ___, Outcome ___
  - [ ] Session 2: User ___, Feature ___, Outcome ___
  - [ ] Session 3: User ___, Feature ___, Outcome ___
  - [ ] Session 4: User ___, Feature ___, Outcome ___
  - [ ] Session 5: User ___, Feature ___, Outcome ___

- [ ] **Trace analysis complete**:
  - [ ] Common failure patterns identified
  - [ ] Routing misses documented
  - [ ] Coverage gaps noted
  - [ ] SKILL.md updated based on findings

### Publishing Requirements

- [ ] **Git repo created**: git.soma.salesforce.com/[org]/gus-test-generator
- [ ] **Repo visibility**: Public or Private (NOT Internal)
- [ ] **PR 1 ready** (Expert repo):
  - [ ] All files committed
  - [ ] README complete
  - [ ] Release tagged (v0.1.0)
  
- [ ] **PR 2 ready** (Registry):
  - [ ] Entry added to registry.yaml
  - [ ] Points to correct repo + tag
  - [ ] Status: candidate

**Gate**: Cannot publish as candidate until all items checked

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

### Baseline (No Expert)

| PRD | Scenarios | Functional | Integration | Edge | Performance | HTML Format | Workflow Steps |
|-----|-----------|------------|-------------|------|-------------|-------------|----------------|
| 1   |           |            |             |      |             |             |                |
| 2   |           |            |             |      |             |             |                |
| 3   |           |            |             |      |             |             |                |
| 4   |           |            |             |      |             |             |                |
| 5   |           |            |             |      |             |             |                |

### With Expert

| PRD | Scenarios | Functional | Integration | Edge | Performance | HTML Format | Workflow Steps |
|-----|-----------|------------|-------------|------|-------------|-------------|----------------|
| 1   |           |            |             |      |             |             |                |
| 2   |           |            |             |      |             |             |                |
| 3   |           |            |             |      |             |             |                |
| 4   |           |            |             |      |             |             |                |
| 5   |           |            |             |      |             |             |                |

### Improvement

| Metric | Baseline Avg | Expert Avg | Improvement |
|--------|--------------|------------|-------------|
| Scenarios generated | | | |
| Functional coverage | | | |
| Integration coverage | | | |
| Edge case coverage | | | |
| Performance coverage | | | |
| HTML formatting | | | |
| Workflow completeness | | | |

**Target**: Improvement on ≥4 of 7 metrics, no regressions

---

## 🔄 Optimization Loop Tracker

### Iteration 1
- **Date**: ___
- **Traces analyzed**: ___ sessions
- **Patterns found**: ___
- **Changes proposed**: ___
- **Changes merged**: ___
- **Re-grade result**: ___

### Iteration 2
- **Date**: ___
- **Traces analyzed**: ___ sessions
- **Patterns found**: ___
- **Changes proposed**: ___
- **Changes merged**: ___
- **Re-grade result**: ___

### Iteration 3
- **Date**: ___
- **Traces analyzed**: ___ sessions
- **Patterns found**: ___
- **Changes proposed**: ___
- **Changes merged**: ___
- **Re-grade result**: ___

---

## 📅 Timeline

| Milestone | Target Date | Actual Date | Status |
|-----------|-------------|-------------|--------|
| Draft complete | 2026-04-28 | 2026-04-28 | ✅ Done |
| Local testing | | | |
| Baseline runs complete | | | |
| First usage (5 sessions) | | | |
| Trace analysis complete | | | |
| Eval suite written | | | |
| Candidate published | | | |
| 50 usage sessions | | | |
| Optimization loop 1 | | | |
| Optimization loop 2 | | | |
| Optimization loop 3 | | | |
| Expert promotion | | | |

---

## 🎯 Success Criteria

### Draft → Candidate
- [ ] Evidence gathered (baseline + 5-10 real sessions)
- [ ] Evals written and passing vs baseline
- [ ] Local test successful
- [ ] Published to registry as candidate

### Candidate → Expert
- [ ] 50+ usage sessions
- [ ] 3+ optimization iterations
- [ ] Consistent efficacy improvement
- [ ] No stability regressions
- [ ] Positive user feedback

---

## Notes

Use this space to track issues, questions, feedback:

---
