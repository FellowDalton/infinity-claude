# Self-Evolving Project

## Bootstrap Protocol
1. Read `.claude/state/current.json` for context and continuation state
2. Check for blockers or manual intervention flags
3. Execute next planned actions in priority order
4. Update state with progress and plan next actions
5. If stuck for 3+ cycles, create helper agent/tool to unblock

## Continuation System
- **Script**: `.claude/scripts/continuity.sh`
- **Frequency**: Every 30 minutes (automated via cron/Task Scheduler)
- **Purpose**: Ensures continuous progress without human intervention

## State Management
- **Current State**: `.claude/state/current.json`
- **History Log**: `.claude/state/history.jsonl` (append-only)
- **Agent Registry**: `.claude/state/agents.json`

## Emergency Override
If `requiresHuman: true` in current.json, automated runs pause.
Check the `blockers` array for details on what needs human intervention.

## Core Principles
- **BEST PRACTICES FIRST**: Code quality is CRITICAL - research and implement industry best practices
- **Quality Gates**: No code ships without passing validation - create rigorous checkers
- **Autonomy**: Create your own agents, tools, and workflows
- **Continuity**: Always plan next actions before finishing
- **Memory**: Document all decisions in `.claude/memory/`

## Quality Mandate
You have internet access. Use it to:
1. Research current best practices for chosen tech stack
2. Find industry standards and style guides
3. Study high-quality open source projects
4. Implement automated quality checks
5. Validate every decision against best practices

## Commands Available
- `bash .claude/scripts/spawn_agent.sh <name> <type> <purpose>` - Create new agent
- `bash .claude/scripts/continuity.sh` - Manual continuity check
- See `.claude/skills/` for custom commands you create

---
*This file is intentionally minimal. All project intelligence lives in `.claude/` directory.*
*You have full autonomy to evolve this system as needed.*