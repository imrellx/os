# PAI Changelog

All notable changes to PAI (Personal AI Infrastructure) customizations.

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
