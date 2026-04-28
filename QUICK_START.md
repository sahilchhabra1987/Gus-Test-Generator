# Quick Start Guide

Get the GUS Test Generator expert running in 5 minutes.

---

## Step 1: Test Locally

### Add as Local Plugin

1. Open AI Suite (Claude Code)
2. Go to **Settings → Plugins → Add local plugin**
3. Select directory: `/Users/sahil.chhabra/.aisuite/notebook/gus-test-generator`
4. Click **Add**

### Verify Installation

1. Start new conversation
2. Type: `/gus-test-generator`
3. Should see: Skill loaded confirmation

---

## Step 2: Test the Workflow

### Sample PRD for Testing

Create a file `sample-prd.md`:

```markdown
# Feature: Password Reset

## Functional Requirements
1. User can request password reset via "Forgot Password" link
2. System sends reset email with temporary token (expires in 1 hour)
3. User clicks email link, enters new password
4. Password must meet requirements: 8+ chars, 1 uppercase, 1 number
5. System validates token, updates password, logs user in

## Non-Functional Requirements
- Reset email sent within 30 seconds
- Token generation cryptographically secure
- Supports 100 concurrent reset requests
```

### Test Conversation

```
Generate test cases for this PRD:

[paste sample PRD content]

Product Tag: UserManagement
```

### Expected Behavior

Claude should:
1. ✓ Acknowledge the request
2. ✓ Ask if you have HLD (optional)
3. ✓ Ask if you want to link to work item (optional)
4. ✓ Generate 15-25 test scenarios
5. ✓ Show coverage breakdown (functional, integration, edge, performance)
6. ✓ Format with HTML lists
7. ✓ Ask if you want to upload to GUS

---

## Step 3: Verify GUS Integration (Optional)

### Prerequisites

```bash
# Check sf CLI installed
sf --version

# Authenticate to GUS
sf org login web --instance-url https://gus.my.salesforce.com --alias gus

# Verify auth
sf data query --target-org gus --query "SELECT Id FROM User LIMIT 1"
```

### Test Upload

In the conversation from Step 2:
```
Yes, upload to GUS
```

Claude should:
1. ✓ Verify GUS authentication
2. ✓ Create ADM_Test_Suite__c record
3. ✓ Create ADM_Test_Scenario__c records
4. ✓ Provide GUS URL to view suite

### Verify in GUS

Open provided URL, check:
- [ ] Test suite created with correct name
- [ ] All scenarios listed
- [ ] HTML formatting renders correctly (bullet lists, numbered steps)
- [ ] Priority values are P0/P1/P2/P3
- [ ] Test types are Functional/Integration/Edge Case/Performance

---

## Step 4: Run Baseline Comparison

### Without Expert

1. Start **new conversation** (no expert loaded)
2. Use same sample PRD
3. Prompt: "Generate comprehensive test cases for this PRD that I can upload to GUS Taleggio: [PRD content]. Product tag: UserManagement"
4. **Save conversation** as `baseline-no-expert.txt`

Record:
- Number of scenarios generated
- Test types included
- HTML formatting (yes/no)
- Workflow steps (preview? GUS upload?)

### With Expert

1. Start **new conversation** (expert loaded)
2. Use same sample PRD
3. Prompt: "Generate test cases for this PRD. Product tag: UserManagement"
4. **Save conversation** as `with-expert.txt`

Record same metrics.

### Compare

| Metric | Without Expert | With Expert | Improvement? |
|--------|---------------|-------------|--------------|
| Scenario count | ___ | ___ | ✓/✗ |
| Test type coverage | ___ | ___ | ✓/✗ |
| HTML formatting | ___ | ___ | ✓/✗ |
| Workflow completeness | ___ | ___ | ✓/✗ |

---

## Step 5: Test with Real PRD

### Use Actual Work PRD

1. Pick upcoming feature from your team
2. Get PRD (and HLD if available)
3. Run through expert workflow
4. Upload to GUS (use `--no-gus-upload` flag first to preview)
5. Share GUS URL with team for feedback

### Collect Feedback

Ask team:
- Was coverage comprehensive?
- Were test scenarios accurate?
- Did HTML formatting render correctly?
- Was workflow intuitive?
- What's missing?

---

## Troubleshooting

### Expert Doesn't Trigger

**Problem**: Type `/gus-test-generator` but nothing happens

**Solutions**:
1. Verify plugin added: Settings → Plugins → check gus-test-generator listed
2. Restart AI Suite
3. Check SKILL.md has valid YAML frontmatter: `name: gus-test-generator`

### Wrong Expert Triggers

**Problem**: Different expert triggers instead of gus-test-generator

**Solution**: Be explicit:
```
/gus-test-generator

Generate test cases for this PRD...
```

### GUS Upload Fails

**Problem**: sf CLI command fails

**Solutions**:
1. Check authentication: `sf data query --target-org gus --query "SELECT Id FROM User LIMIT 1"`
2. Re-authenticate: `sf org login web --instance-url https://gus.my.salesforce.com --alias gus`
3. Check permissions: Verify Create access on ADM_Test_Suite__c and ADM_Test_Scenario__c
4. Check field values: Ensure Priority is P0-P3, Type is Functional/Integration/Edge Case/Performance

### HTML Not Rendering in GUS

**Problem**: See raw `<ul><li>` tags in GUS UI

**Solutions**:
1. Check field type: Preconditions__c and Test_Steps__c must be Rich Text Area
2. Check HTML syntax: Ensure proper closing tags
3. Try manual edit in GUS: Edit scenario, paste HTML directly, check if it renders

---

## Next Steps

### After Local Testing Works

1. **Run baseline** (Step 4) with 3-5 different PRDs
2. **Get real usage**: Share with 2-3 teams
3. **Collect traces**: Save conversations from `~/.claude/projects/`
4. **Analyze failures**: Where did expert miss? What did users expect?
5. **Refine**: Update SKILL.md routing, guides based on findings
6. **Write evals**: Create Harbor tasks based on observed patterns
7. **Publish**: Two PRs (expert repo + registry)

### Getting Help

- Check [README.md](README.md) for full documentation
- Check [DRAFT_SUMMARY.md](DRAFT_SUMMARY.md) for lifecycle roadmap
- Check [workflow.md](skills/gus-test-generator/guides/workflow.md) for process details
- Check [gus-integration.md](skills/gus-test-generator/guides/gus-integration.md) for GUS technical reference

---

## Common Commands

```bash
# Add local plugin (first time)
# AI Suite → Settings → Plugins → Add local plugin

# Verify plugin loaded
# Start conversation, type: /gus-test-generator

# Update plugin (after editing files)
# Settings → Plugins → Reload plugins

# Remove plugin
# Settings → Plugins → Remove gus-test-generator

# Authenticate to GUS
sf org login web --instance-url https://gus.my.salesforce.com --alias gus

# Test GUS connection
sf data query --target-org gus --query "SELECT Id, Name FROM ADM_Work__c LIMIT 5"

# View test suite in GUS
# Open: https://gus.lightning.force.com/lightning/r/ADM_Test_Suite__c/[ID]/view
```

---

## Success Checklist

- [ ] Expert added as local plugin
- [ ] Expert triggers on `/gus-test-generator`
- [ ] Test with sample PRD generates scenarios
- [ ] HTML formatting looks correct in preview
- [ ] GUS authentication works
- [ ] Test upload to GUS succeeds
- [ ] GUS UI renders HTML correctly
- [ ] Baseline comparison shows improvement
- [ ] Real PRD test with team feedback collected

**When all checked: Ready for wider rollout!**
