# PAI Custom Skills

Documentation of custom skills added to PAI.

## Development Skill

**Purpose:** Complete development workflow engine for TDD, debugging, and code review.

**Triggers:**
- coding, implementing features, fixing bugs
- TDD, test-driven, debugging
- code review, brainstorming
- planning implementation, executing plans
- git worktrees, parallel agents

**Key Workflows:**
- `FullCycle` - End-to-end development with TDD
- `Debug` - Systematic debugging approach
- `Brainstorm` - Idea exploration
- `RequestReview` / `ReceiveReview` - Code review process
- `CreateWorktree` / `FinishBranch` - Git workflow
- `ParallelAgents` - Multi-agent development

**Guides Included:**
- TDDGuide.md - Test-driven development methodology
- DebuggingGuide.md - Systematic debugging approach
- VerificationGuide.md - Verification before completion
- TestingAntiPatterns.md - Common mistakes to avoid

## Peers Skill

**Purpose:** Multi-AI consultation system for getting diverse perspectives.

**Triggers:**
- consulting peers, multiple perspectives
- asking other AIs, second opinion
- brainstorming architecture decisions
- diverse viewpoints on a problem

**How It Works:**
1. User presents a problem or question
2. Multiple AI perspectives are consulted
3. Responses are synthesized into actionable insights
4. Consensus and dissent are clearly marked

**Use Cases:**
- Architecture decisions
- Design trade-offs
- Problem-solving approaches
- Code review perspectives

## Autoskill Skill

**Purpose:** Ambient learning system that captures corrections and preferences.

**Triggers:**
- autoskill, learn from this session
- autoskill digest, autoskill apply
- update skills from corrections

**Components:**
- `SignalAggregator.ts` - Collects learning signals
- `ConfidenceCalculator.ts` - Scores signal confidence
- `ProposalGenerator.ts` - Creates skill update proposals

**Workflows:**
- `ManualCapture` - Explicit signal capture
- `WeeklyDigest` - Review accumulated learnings
- `ApplyProposals` - Apply approved changes

**How It Works:**
1. During sessions, corrections and preferences are captured
2. Signals are stored with confidence scores
3. Weekly digest reviews accumulated signals
4. High-confidence patterns become skill updates

## Backup Location

All custom skills are backed up in the private repository:
`github.com/imrellx/pai-customizations`

```
skills/
├── Development/
├── Peers/
└── Autoskill/
```

## Restoration

After a fresh PAI install:

```bash
cp -r ~/Code/personal/pai-customizations/skills/* ~/.claude/skills/
```
