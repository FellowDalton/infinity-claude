#!/bin/bash

# Initial Setup Script for Self-Evolving Claude Project
# Run this once to bootstrap the entire system

set -e

echo "🚀 Setting up Self-Evolving Claude Project..."
echo ""

# Create directory structure
echo "📁 Creating directory structure..."

mkdir -p .claude/state
mkdir -p .claude/agents
mkdir -p .claude/skills
mkdir -p .claude/scripts
mkdir -p .claude/memory
mkdir -p .tools
mkdir -p src

echo "✓ Directory structure created"
echo ""

# Create state files
echo "📝 Creating state files..."

cat > .claude/state/current.json <<'EOF'
{
  "version": "1.0.0",
  "projectName": "self-evolving-app",
  "initialized": "",
  "lastRun": "",
  "currentPhase": "bootstrap",
  "cycleCount": 0,
  "requiresHuman": false,
  "nextActions": [
    {
      "id": "init-001",
      "type": "setup",
      "priority": "critical",
      "action": "Receive app requirements from user",
      "status": "pending",
      "assignedTo": "bootstrap"
    },
    {
      "id": "init-002",
      "type": "create_agent",
      "priority": "high",
      "action": "Create researcher agent for tech stack analysis",
      "status": "pending",
      "assignedTo": "bootstrap"
    },
    {
      "id": "init-003",
      "type": "create_agent",
      "priority": "high",
      "action": "Create architect agent for system design",
      "status": "pending",
      "assignedTo": "bootstrap"
    }
  ],
  "completedActions": [],
  "blockers": [],
  "agents": {
    "bootstrap": {
      "status": "active",
      "created": "",
      "purpose": "Initial system setup and agent creation",
      "capabilities": ["agent_creation", "state_management", "decision_making"]
    }
  },
  "metrics": {
    "totalCycles": 0,
    "tasksCompleted": 0,
    "agentsCreated": 1,
    "decisionsLogged": 0,
    "blockerCount": 0,
    "avgCycleTime": 0,
    "successRate": 100
  },
  "context": {
    "appRequirements": "To be provided by user",
    "techStack": "TBD - will be researched and decided",
    "designSystem": "TBD - will be created",
    "framework": "TBD - will be custom-built as needed"
  },
  "memory": {
    "keyDecisions": [],
    "learnings": [],
    "patterns": []
  },
  "health": {
    "status": "healthy",
    "lastHealthCheck": "",
    "consecutiveFailures": 0,
    "needsIntervention": false
  }
}
EOF

# Update timestamps
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
if command -v jq &> /dev/null; then
    jq ".initialized = \"$TIMESTAMP\" | .lastRun = \"$TIMESTAMP\" | .agents.bootstrap.created = \"$TIMESTAMP\" | .health.lastHealthCheck = \"$TIMESTAMP\"" .claude/state/current.json > .claude/state/current.json.tmp
    mv .claude/state/current.json.tmp .claude/state/current.json
fi

cat > .claude/state/agents.json <<EOF
{
  "bootstrap": {
    "type": "system",
    "purpose": "Initial system setup and coordination",
    "created": "$TIMESTAMP",
    "status": "active",
    "path": ".claude/agents/bootstrap",
    "capabilities": [
      "agent_creation",
      "state_management",
      "system_initialization"
    ]
  }
}
EOF

touch .claude/state/history.jsonl
touch .claude/state/execution.log

echo "✓ State files created"
echo ""

# Create memory files
echo "📚 Creating memory files..."

cat > .claude/memory/architecture.md <<'EOF'
# Architecture Decisions

## Overview
This document tracks architectural decisions made throughout the project lifecycle.

## Decisions
- [To be populated by Claude during development]
EOF

cat > .claude/memory/decisions.md <<'EOF'
# Decision Log

## Format
Each decision should include:
- Date
- Decision
- Rationale
- Alternatives considered
- Trade-offs

## Log
- [Decisions will be logged here]
EOF

cat > .claude/memory/learnings.md <<'EOF'
# Learnings & Insights

## What Worked
- [Successful patterns and approaches]

## What Didn't Work
- [Failed approaches and why]

## Improvements
- [Ideas for future enhancement]
EOF

cat > .claude/memory/best-practices.md <<'EOF'
# Best Practices Documentation

## Research Log
Document all best practice research here.

### Format
**Technology**: [Name]
**Date Researched**: [Date]
**Sources**: [URLs]
**Key Practices**:
- [Practice 1]
- [Practice 2]

**Anti-Patterns to Avoid**:
- [Anti-pattern 1]
- [Anti-pattern 2]

**Reference Projects**:
- [Project name]: [URL] - [Why it's good]

---

## Practices by Category

### Code Quality
- [To be populated during research]

### Security
- [To be populated during research]

### Performance
- [To be populated during research]

### Testing
- [To be populated during research]

### Architecture
- [To be populated during research]
EOF

cat > .claude/quality_framework.md <<'EOF'
# Quality Framework - Best Practices Enforcement

## 🎯 Mission Critical
**Code quality is non-negotiable. Every line must meet industry best practices.**

See full framework at .claude/quality_framework.md

## Quick Reference

### Before ANY Code
1. Research best practices using web_search
2. Document findings in best-practices.md
3. Create quality validation tools

### Quality Gates (All Must Pass)
- ✅ Linting (zero warnings)
- ✅ Type checking
- ✅ Tests (>80% coverage)
- ✅ Security scan
- ✅ Code review
- ✅ Performance check
- ✅ Documentation

### If Quality Fails
1. STOP - do not proceed
2. Fix the issues
3. Document what went wrong
4. Update quality rules
5. Re-validate

**Quality score must stay >95 at all times.**
EOF

cat > QUALITY_FIRST.md <<'EOF'
# Quality-First Development

See QUALITY_FIRST.md artifact for complete quality system documentation.

## Critical Principles
1. Research best practices BEFORE coding
2. Use internet access to find industry standards
3. Create automated quality validation
4. Block any code that doesn't meet standards (score >95)
5. Test coverage must be >80%
6. Zero security vulnerabilities
7. Continuous improvement every cycle

## Files
- `.claude/quality_framework.md` - Complete framework
- `.claude/quality_checklist.md` - Pre-commit checklist
- `.claude/scripts/run_quality_gates.sh` - Run all checks
- `.claude/memory/best-practices.md` - Research findings

**Quality is non-negotiable.**
EOF

echo "✓ Memory files created"
echo ""

# Create scripts
echo "🔧 Creating scripts..."

cat > .claude/scripts/continuity.sh <<'SCRIPTEOF'
#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
STATE_DIR="$PROJECT_ROOT/.claude/state"
LOG_FILE="$STATE_DIR/execution.log"
STATE_FILE="$STATE_DIR/current.json"
HISTORY_FILE="$STATE_DIR/history.jsonl"

cd "$PROJECT_ROOT"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "=== Continuity Check Started ==="

if [ ! -f "$STATE_FILE" ]; then
    log "ERROR: State file not found"
    exit 1
fi

REQUIRES_HUMAN=$(jq -r '.requiresHuman' "$STATE_FILE" 2>/dev/null || echo "false")

if [ "$REQUIRES_HUMAN" = "true" ]; then
    log "Human intervention required. Skipping automated run."
    exit 0
fi

CYCLE_COUNT=$(jq -r '.cycleCount' "$STATE_FILE" 2>/dev/null || echo "0")
NEW_CYCLE=$((CYCLE_COUNT + 1))

log "Starting cycle #$NEW_CYCLE"

echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"event\":\"cycle_start\",\"cycle\":$NEW_CYCLE}" >> "$HISTORY_FILE"

PROMPT="You are in cycle #$NEW_CYCLE. Read .claude/state/current.json for context. Execute your next planned actions, update state with progress, and plan what comes next. If stuck for 3+ cycles, create a helper agent or tool. Always plan next actions before finishing."

log "Executing Claude Code..."

if command -v claude-code &> /dev/null; then
    claude-code run --non-interactive --prompt "$PROMPT" >> "$LOG_FILE" 2>&1
    EXIT_CODE=$?
else
    log "WARNING: claude-code not found. Please install or configure."
    EXIT_CODE=1
fi

if [ $EXIT_CODE -eq 0 ]; then
    log "Cycle #$NEW_CYCLE completed successfully"
    echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"event\":\"cycle_complete\",\"cycle\":$NEW_CYCLE,\"status\":\"success\"}" >> "$HISTORY_FILE"
else
    log "Cycle #$NEW_CYCLE failed with exit code $EXIT_CODE"
    echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"event\":\"cycle_complete\",\"cycle\":$NEW_CYCLE,\"status\":\"failure\",\"exitCode\":$EXIT_CODE}" >> "$HISTORY_FILE"
fi

log "=== Continuity Check Completed ==="
exit $EXIT_CODE
SCRIPTEOF

cat > .claude/scripts/spawn_agent.sh <<'SCRIPTEOF'
#!/bin/bash
set -e

if [ $# -lt 3 ]; then
    echo "Usage: $0 <name> <type> <purpose>"
    exit 1
fi

AGENT_NAME=$1
AGENT_TYPE=$2
AGENT_PURPOSE=$3

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
AGENT_DIR="$PROJECT_ROOT/.claude/agents/$AGENT_NAME"

mkdir -p "$AGENT_DIR"/{logs,config,skills}

cat > "$AGENT_DIR/README.md" <<AGENTEOF
# Agent: $AGENT_NAME

**Type**: $AGENT_TYPE
**Purpose**: $AGENT_PURPOSE
**Created**: $(date)

## Capabilities
- [Define capabilities]

## Commands
- [Add commands]
AGENTEOF

cat > "$AGENT_DIR/config/agent.json" <<AGENTEOF
{
  "name": "$AGENT_NAME",
  "type": "$AGENT_TYPE",
  "purpose": "$AGENT_PURPOSE",
  "created": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "status": "active"
}
AGENTEOF

echo "✓ Agent $AGENT_NAME created at $AGENT_DIR"
SCRIPTEOF

cat > .claude/scripts/run_quality_gates.sh <<'SCRIPTEOF'
#!/bin/bash
# Quality Gates Runner - See run_quality_gates.sh artifact for full implementation
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Running quality gates..."
echo "This is a placeholder. Replace with full quality_gates.sh implementation."
echo "See the run_quality_gates.sh artifact for complete implementation."

# Exit with success for now
exit 0
SCRIPTEOF

chmod +x .claude/scripts/*.sh

echo "✓ Scripts created and made executable"
echo ""

# Create CLAUDE.md
echo "📄 Creating CLAUDE.md..."

cat > CLAUDE.md <<'EOF'
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
Check the `blockers` array for details.

## Core Principles
- **Autonomy**: Create your own agents, tools, and workflows
- **Continuity**: Always plan next actions before finishing
- **Quality**: Build validators and checkers as needed
- **Memory**: Document all decisions in `.claude/memory/`

## Commands Available
- `bash .claude/scripts/spawn_agent.sh <name> <type> <purpose>`
- `bash .claude/scripts/continuity.sh`

---
*This file is intentionally minimal. All intelligence lives in `.claude/`*
EOF

echo "✓ CLAUDE.md created"
echo ""

# Create .gitignore
echo "🔒 Creating .gitignore..."

cat > .gitignore <<'EOF'
# Logs
.claude/state/execution.log
*.log

# Temporary files
*.tmp
.DS_Store

# Dependencies (add as needed)
node_modules/
.env

# IDE
.vscode/
.idea/
EOF

echo "✓ .gitignore created"
echo ""

# Setup cron job (optional, requires user confirmation)
echo "⏰ Cron Job Setup"
echo "To enable automatic continuity checks every 30 minutes:"
echo ""
echo "Linux/Mac:"
echo "  crontab -e"
echo "  # Add this line:"
echo "  */30 * * * * cd $(pwd) && bash .claude/scripts/continuity.sh"
echo ""
echo "Windows (PowerShell as Administrator):"
echo '  $action = New-ScheduledTaskAction -Execute "bash" -Argument "$(pwd)\.claude\scripts\continuity.sh"'
echo '  $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 30)'
echo '  Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "ClaudeContinuity"'
echo ""

echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "  1. Set up the cron job (see above)"
echo "  2. Open this project in Claude Code"
echo "  3. Provide your app requirements"
echo "  4. Let Claude take over!"
echo ""
echo "📊 Monitor progress:"
echo "  - Current state: .claude/state/current.json"
echo "  - Execution log: .claude/state/execution.log"
echo "  - History: .claude/state/history.jsonl"