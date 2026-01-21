# PAI Changelog

All notable changes to PAI (Personal AI Infrastructure) customizations.

## [2.10] - 2026-01-21

### Session Continuity Fix

Fixed disconnected session continuity feature - the tools and hooks existed but the feature was never activated due to path inconsistencies and missing directory.

### The Problem

Session continuity was **designed but disconnected**:
- `SessionProgress.ts` expected files in `MEMORY/STATE/progress/`
- `FeatureRegistry.ts` expected files in `MEMORY/progress/` (wrong path)
- `SessionContinuity.md` documented `MEMORY/progress/` (wrong path)
- Neither directory existed because no progress files had ever been created
- The `LoadContext.hook.ts` correctly checked `MEMORY/STATE/progress/` but silently returned null

### The Fix

**1. Path Alignment:**
- Fixed `FeatureRegistry.ts:58` to use `MEMORY/STATE/progress/` (was `MEMORY/progress/`)
- Fixed `SessionContinuity.md:60` documentation to reference correct path

**2. Directory Bootstrap:**
- Created `~/.claude/MEMORY/STATE/progress/` directory

**3. Automatic Progress Creation (Option C):**
Added integration with Development skill for proactive session continuity:

- **Development/SKILL.md** - Added "Multi-Session Work" section with commands and triggers
- **Development/Workflows/FullCycle.md** - Auto-creates progress file at start, handoff at finish
- **Development/Workflows/WritePlan.md** - Auto-creates progress for plans with 3+ tasks

### Auto-Creation Triggers

Progress files are now auto-created for:
- FullCycle workflow (always)
- WritePlan workflow with 3+ tasks
- Debug workflow after 2+ failed fix attempts
- Any work user indicates will span multiple sessions

### Updated Files
- **CORE/Tools/FeatureRegistry.ts:58** - Fixed path to `MEMORY/STATE/progress/`
- **CORE/Workflows/SessionContinuity.md:60** - Fixed documentation path
- **Development/SKILL.md** - Added "Multi-Session Work" section
- **Development/Workflows/FullCycle.md** - Added session continuity auto-creation and handoff
- **Development/Workflows/WritePlan.md** - Added session continuity for 3+ task plans

### How It Works Now

At session start, `LoadContext.hook.ts` checks `~/.claude/MEMORY/STATE/progress/` and displays any active work:

```
📋 ACTIVE WORK (from previous sessions):

🔵 my-feature
   Objectives:
   • Implement user authentication
   Handoff: Auth model complete, ready for service implementation
   Next steps:
   → Write auth service tests
   → Implement login endpoint
```

---

## [2.9] - 2026-01-18

### Amplifier Agent Pattern Integration

Ported three high-value patterns from archived Amplifier agents into PAI infrastructure.

### Source Analysis
Analyzed 30+ agent definitions from `pai-design/amplifier/` and `amplifier-foundation/` to identify patterns worth preserving.

### Memory System Safety (MEMORYSYSTEM.md)

Added safety patterns for large JSONL files to prevent token exhaustion and session crashes.

**Source:** session-analyst agent's explicit warnings about 100k+ token lines

**Content:**
- Size thresholds table (Safe <100KB → Critical >1MB)
- Safe extraction patterns (grep -n, jq field extraction, tail -N)
- Pre-read size check script
- Archive strategy for files exceeding 1MB

### Quality Gate Modes (Development/SKILL.md, Development/Workflows/FullCycle.md)

Added explicit ANALYZE, ARCHITECT, REVIEW modes for complex work with clear triggers and outputs.

**Source:** zen-architect agent's three operating modes

**Modes:**
- **ANALYZE Mode** - Break down complex requirements into first principles → `docs/analysis/`
- **ARCHITECT Mode** - Design system specifications before implementation → `docs/specs/`
- **REVIEW Mode** - Quality checkpoint before declaring work complete → `docs/reviews/`

**FullCycle Integration:**
- Phase 1.5 (ANALYZE) - After Brainstorm, before Create Workspace
- Phase 2.5 (ARCHITECT) - After Create Workspace, before Write Plan
- Phase 4.5 (REVIEW) - After Execute, before Finish

### Thinking Frameworks (THINKINGFRAMEWORKS.md - new file)

Created cognitive tools reference for creative problem-solving.

**Source patterns:**
- pattern-emergence: "2+2=5 Framework"
- ambiguity-guardian: Uncertainty Cartography
- insight-synthesizer: Collision Zone Thinking, Inversion Exercises
- knowledge-archaeologist: Temporal Stratigraphy

**Frameworks:**
| Framework | Use When | Output |
|-----------|----------|--------|
| 2+2=5 | Combining approaches | Synergistic solution |
| Uncertainty Cartography | Incomplete info | Resolution strategy |
| Collision Zone | Need breakthroughs | Unexpected connections |
| Temporal Stratigraphy | Legacy code | Essential vs accidental |
| Inversion | Finding blind spots | Safeguards |

### Updated Files
- **CORE/SYSTEM/MEMORYSYSTEM.md** - Added "Working with Large JSONL Files - Safety Patterns" section
- **CORE/SYSTEM/THINKINGFRAMEWORKS.md** - New file (3.8KB, 5 frameworks)
- **Development/SKILL.md** - Added "Quality Gate Modes (Complex Work)" section
- **Development/Workflows/FullCycle.md** - Added Phase 1.5, 2.5, 4.5 optional quality gates

---

## [2.8] - 2026-01-18

### Statusline Context Percentage Fix

Fixed context percentage to show **"% toward autocompact"** instead of "% of total 200k", making it actually useful for predicting when compaction will trigger.

### The Problem

- Statusline showed 55% while `/context` showed 10% remaining until autocompact
- This was because statusline used total 200k as denominator
- But autocompact buffer (= MAX_OUTPUT_TOKENS) reserves significant space
- With 80k max output, only 120k is actually usable before compaction

### The Fix

Now calculates effective window:
```
effective_window = context_max - MAX_OUTPUT_TOKENS
real_pct = raw_pct × (context_max / effective_window)
```

Example with 80k max output:
- Old: 55% of 200k (misleading)
- New: 90% toward compact (10% left) (accurate)

### Display Changes

- Shows `X% (Y% left)` format for clarity
- Normal mode shows effective window size: `90% (10% left → 120k)`
- Color thresholds adjusted: green ≤50%, yellow ≤80%, red >80%

### Updated Files
- **statusline-command.sh** - Effective window calculation, adjusted display

---

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
| 2.8 | 2026-01-18 | Statusline context percentage fix (show % toward autocompact, not % of total 200k) |
| 2.9 | 2026-01-18 | Amplifier agent pattern integration (memory safety, quality gate modes, thinking frameworks) |
| 2.10 | 2026-01-21 | Session continuity fix (path alignment, directory bootstrap, auto-creation in Development skill) |
