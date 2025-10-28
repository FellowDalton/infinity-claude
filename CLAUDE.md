# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## ⚠️ READ THIS FIRST: MINDSET.md Supremacy

**Before using anything in this document, read `.claude/MINDSET.md`.**

This file is a **technical reference** for using the infinity-claude system. However:

- **MINDSET.md contains the governing principles** for all work on this project
- **When MINDSET.md and CLAUDE.md conflict, MINDSET.md wins**
- **All features described below must comply with Solo Dev Mindset principles**

Key principles that override this technical reference:
- Only build what's explicitly requested
- Keep everything simple and understandable at a glance
- No over-engineering, no premature optimization
- Ask before making architectural decisions

If any feature in this system violates MINDSET.md, simplify or remove it.

---

## System Overview

The infinity-claude system is an autonomous development assistant that:
- Maintains continuity across sessions via state files
- Provides reusable skills (state management, quality checks, agent creation, swarm deployment)
- Enables slash commands for common workflows
- Enforces quality standards before code changes

**Core principle**: Quality-first development. Code must pass all quality gates (score >95) before proceeding.

**Governance**: All system behavior subject to `.claude/MINDSET.md` principles.

## Quick Start

### First Time (Bootstrap)
Use `/bootstrap` or read `.claude/docs/initialization.md`

### Continuity Cycles
Use `/continue` to run a manual cycle (simulates the 30-min automated runs)

### Check Status
Use `/monitor` to see current state, metrics, and next actions

## Slash Commands

- `/bootstrap` - Initialize system and start first cycle
- `/continue` - Run manual continuity check
- `/create-agent` - Create specialized agent interactively
- `/monitor` - Display dashboard
- `/quality-check` - Run all quality gates
- `/swarm` - Deploy parallel Haiku swarm agents for focused tasks

## Subagents

- **continuity-manager** (`.claude/subagents/continuity-manager.md`) - Handles state updates, action planning, and cycle transitions

### Swarm Agents (Haiku-powered)
For parallel, focused tasks, deploy **swarm agents** - lightweight Haiku-powered subagents that can run simultaneously:
- Security scanning across multiple files
- Code review of many small files
- Parallel research tasks
- Data gathering from multiple sources

See `.claude/docs/swarm-agents.md` for patterns and templates.

## Skills

Skills are modular packages in `.claude/skills/` that extend capabilities with specialized workflows:

- **state-manager** - State file operations (`summary`, `get`, `set`, `increment`, `complete`)
- **quality-validator** - Quality checks (`quick`, `precommit`, `full`)
- **agent-spawner** - Agent creation (`interactive`, `list`, `info`)
- **swarm-deployer** - Swarm deployment (`list`, `plan`, `deploy`, `history`)
- **skill-creator** - Guide for creating new skills

Each skill has a `SKILL.md` file describing usage and scripts in `scripts/` subdirectory.

Usage: `bash .claude/skills/<skill-name>/scripts/<skill-name>.sh <command>`

## State Management

**Primary state**: `.claude/state/current.json`
- Read at start of each cycle for context
- Update at end with completed actions and next steps
- Use `continuity-manager` subagent or `state-manager.sh` skill

**Critical**: Always update state before finishing a session!

## Quality Requirements

- Quality score must stay >95
- Test coverage must be >80%
- Zero high/critical security vulnerabilities
- Run checks: `bash .claude/skills/quality-validator/scripts/quality-validator.sh precommit`

See `.claude/docs/quality-framework.md` for complete requirements.

## Directory Structure

```
.claude/
├── commands/        # Slash command definitions
├── subagents/       # Subagent configurations
├── skills/          # Reusable executable tools
├── scripts/         # Core automation (continuity, setup, etc.)
├── docs/            # Detailed documentation
├── state/           # State files (current.json, agents.json, etc.)
├── memory/          # Persistent memory (decisions, learnings, best-practices)
└── agents/          # Runtime agents (created as needed)
```

## Continuity Protocol

Each 30-minute cycle:
1. Read `.claude/state/current.json`
2. Execute `nextActions` by priority
3. Update state with progress
4. Plan next actions
5. Set `requiresHuman: true` only if blocked

**Key**: Always plan next actions before finishing to ensure continuity.

## Common Operations

```bash
# State operations
bash .claude/skills/state-manager/scripts/state-manager.sh summary
bash .claude/skills/state-manager/scripts/state-manager.sh get cycleCount
bash .claude/skills/state-manager/scripts/state-manager.sh increment metrics.tasksCompleted

# Quality checks
bash .claude/skills/quality-validator/scripts/quality-validator.sh quick      # Fast (lint + types)
bash .claude/skills/quality-validator/scripts/quality-validator.sh precommit  # Pre-commit
bash .claude/skills/quality-validator/scripts/quality-validator.sh full       # All gates

# Agent management
bash .claude/skills/agent-spawner/scripts/agent-spawner.sh interactive
bash .claude/skills/agent-spawner/scripts/agent-spawner.sh list

# Swarm deployment
bash .claude/skills/swarm-deployer/scripts/swarm-deployer.sh plan security-scanner "src/**/*.js"
bash .claude/skills/swarm-deployer/scripts/swarm-deployer.sh deploy security-scanner "src/**/*.js"
```

## Memory Files

Update these to maintain context:
- `.claude/memory/architecture.md` - System design decisions
- `.claude/memory/decisions.md` - Decision log with rationale
- `.claude/memory/learnings.md` - What worked/didn't work
- `.claude/memory/best-practices.md` - Researched best practices

## Usage Guidelines

1. **Always consult `.claude/MINDSET.md` first** - it overrides everything else
2. **Use slash commands** for structured workflows
3. **Invoke subagents** for specialized tasks (state management, etc.)
4. **Leverage skills** for common operations
5. **Quality first** - validate everything, maintain score >95
6. **Update state** - use `continuity-manager` before finishing
7. **Ask before deciding** - never make architectural decisions without explicit approval

## Detailed Documentation

- **🔴 MINDSET.md**: `.claude/MINDSET.md` - Solo Dev principles (READ FIRST)
- **Initialization**: `.claude/docs/initialization.md`
- **Bootstrap**: `.claude/docs/bootstrap.md`
- **Quick Start**: `.claude/docs/quick-start.md`
- **Quality Framework**: `.claude/docs/quality-framework.md`
- **Quality Checklist**: `.claude/docs/quality-checklist.md`
- **Swarm Agents**: `.claude/docs/swarm-agents.md` (Haiku-powered parallel agents)
- **Design Philosophy**: `.claude/docs/design-philosophy.md` - How system aligns with MINDSET.md
- **Full README**: `README.md`

## Emergency

**If stuck 3+ cycles**: Create helper agent or tool
**If quality <80**: STOP, run full quality check, fix all issues
**If blocked**: Set `requiresHuman: true` and document in `blockers`

## Quick Reference

| Task | Command |
|------|---------|
| Start cycle | `/continue` |
| Check status | `/monitor` |
| Update state | Invoke `continuity-manager` |
| Quality check | `/quality-check` |
| Create agent | `/create-agent` |
| View state | `bash .claude/skills/state-manager/scripts/state-manager.sh summary` |

---

**Remember**: This system depends on continuity. Always update state with next actions before finishing!
