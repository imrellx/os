# PAI Changelog

All notable changes to PAI (Personal AI Infrastructure) customizations.

## [2.7] - 2026-01-18

### Development Skill Enhancement

Strengthened enforcement of Core Principles (TDD, Debugging, Verification) through explicit checkpoints, expanded decision trees, and failure path examples.

### ExecutePlan Workflow

**Enhanced Step 2** with explicit checkpoints:
- **TDD Checkpoint:** Write failing test BEFORE implementation (not just "apply TDD discipline")
- **Verification Checkpoint:** Show actual test output with evidence (not "should work")
- Clear guidance on what to report vs. what's forbidden

### DebuggingGuide Expanded

**Phase 2 (Pattern Analysis):**
- Decision tree for finding working examples (or handling when none exist)
- Difference type table (Code, Config, Dependencies, Environment)
- Structured comparison steps

**Phase 3 (Hypothesis and Testing):**
- Hypothesis template with good/bad examples
- Result evaluation decision table (worked/new symptom/same symptom/partial)
- Explicit "NEVER stack fixes" guidance

**Phase 4 (Implementation):**
- Failure escalation table (1st/2nd/3rd fix actions)
- Explicit "After 3 failures" protocol with escalation script

### SKILL.md Example 4

Added failure path example showing:
- 3 fix attempts with different symptoms
- Proper escalation after 3rd failure
- How to present options to human partner
- Key lesson: 3 failures = architectural problem

### Updated Files
- **Development/Workflows/ExecutePlan.md** - TDD and Verification checkpoints in Step 2
- **Development/DebuggingGuide.md** - Expanded Phases 2, 3, 4 with decision trees and tables
- **Development/SKILL.md** - Added Example 4 (Escalation When Fix Fails)

### Benefits
- Core Principles now explicitly enforced at workflow level
- Agents can't skip TDD/Verification by just "following steps"
- Clear decision trees prevent vague hypotheses and stacked fixes
- Failure path example teaches proper escalation

---

## [2.6] - 2026-01-18

### Development Skill Routing Fix

Made SubagentDevelopment the default workflow for plan execution, preserving context and preventing exhaustion.

### Updated Routing
- **"Execute plan" → SubagentDevelopment** (was ExecutePlan) - Better context preservation
- **"Execute directly" → ExecutePlan** - Explicit override for quick, direct execution

### Updated Files
- **Development/SKILL.md** - Swapped routing triggers, added workflow selection guidance table
- **Development/Workflows/ExecutePlan.md** - Clarified use case, added "When to Use" section

### Benefits
- Plan execution no longer consumes main context rapidly
- Each task gets fresh subagent context
- ExecutePlan still available for quick 1-2 task fixes
- Explicit trigger words make intent clear

---

## [2.5] - 2026-01-18

### TaskTracker Integration

Replaced ephemeral TodoWrite with persistent TaskTracker in Development workflows for cross-session task progress tracking.

### New Tools
- **Development/Tools/TaskTracker.ts** - CLI tool for persistent task tracking via YAML front matter in plan files. Commands: `init`, `status`, `start`, `done`, `blocked`, `note`, `resume`.

### Updated Workflows
- **ExecutePlan.md** - Replaced TodoWrite with TaskTracker commands. Added "Resuming Interrupted Work" section.
- **SubagentDevelopment.md** - Replaced TodoWrite with TaskTracker commands.

### Benefits
- Task progress persists across sessions (stored in plan file front matter)
- `resume` command tells you exactly where to pick up
- `blocked` status with reason tracking
- Progress percentage shown in `status` output

---

## [2.4] - 2026-01-18

### Claude Code 2.1 Feature Integration

Integrated Claude Code 2.1 features into PAI to improve plan quality, context management, and system efficiency.

### New Hooks
- **PlanArchive.hook.ts** - Archives approved plans to `MEMORY/PLANS/` with metadata when user approves via ExitPlanMode. Includes optional auto-review trigger.
- **SetupHook.hook.ts** - Runs PAI initialization checks on `claude --init`. Verifies directories, skills, settings, and reports status.

### New Workflows
- **Peers/PlanReview.md** - Multi-AI plan review workflow. Queries Claude, Codex, and Gemini for plan critique (gaps, risks, improvements) with PROCEED/REVISE/RETHINK verdict.

### Configuration Changes
- Added `CLAUDE_MCP_TOOL_SEARCH: "auto:5"` - Enables MCP tool search at 5% threshold to preserve context
- Added `ExitPlanMode` PostToolUse matcher for plan archiving
- Added `Setup` hook category for `--init` support

### Documentation
- Added context-clearing strategy to `THEALGORITHM/Phases/Execute.md` - When to clear context after planning
- Added context management reference to `THEALGORITHM/SKILL.md`
- Created `USER/PREFERENCES.md` - Central preferences file with `autoreview_plans` option

### Updated Files
- `settings.json` - MCP tool search, new hooks
- `skills/Peers/SKILL.md` - Added PlanReview workflow routing
- `skills/THEALGORITHM/Phases/Execute.md` - Context management docs
- `skills/THEALGORITHM/SKILL.md` - Context management reference

---

## [2.3] - 2026-01-18

### Added
- PAI customizations backup system (`imrellx/pai-customizations` private repo)
- Public documentation in `os/docs/pai/`

### Custom Skills
- **Development** - TDD workflow, debugging, code review, brainstorming
- **Peers** - Multi-AI consultation system
- **Autoskill** - Ambient learning from corrections

### Modified Files
- `LoadContext.hook.ts` - Fixed template variable replacement
- `statusline-command.sh` - 6 bug fixes for status line rendering

## [2.3] - 2026-01-16

### Initial PAI Installation
- Installed PAI v2.3 on macOS
- Configured AI identity (Nio)
- Set up hooks, skills, and USER configuration

### Bug Fixes Applied
See `fixes-2026-01-16.md` for detailed documentation.

1. **statusline-command.sh** - 6 fixes for:
   - Empty variable handling
   - Bash strict mode compliance
   - Default value initialization
   - Conditional expression safety
   - Git branch name parsing
   - Shell quoting improvements

2. **LoadContext.hook.ts** - Template variable fix:
   - Fixed `${PAI_DIR}` not being replaced in SKILL.md context

---

## Version History

| Version | Date | Notes |
|---------|------|-------|
| 2.3 | 2026-01-16 | Initial installation + bug fixes |
| 2.3 | 2026-01-18 | Backup system created |
| 2.4 | 2026-01-18 | Claude Code 2.1 integration (plan archiving, peer review, setup hook) |
| 2.5 | 2026-01-18 | TaskTracker integration (persistent task tracking in Development workflows) |
| 2.6 | 2026-01-18 | Development skill routing fix (SubagentDevelopment default for plan execution) |
| 2.7 | 2026-01-18 | Development skill enhancement (TDD/Verification checkpoints, expanded debugging phases, failure path examples) |
