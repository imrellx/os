# PAI Changelog

All notable changes to PAI (Personal AI Infrastructure) customizations.

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
