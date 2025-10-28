---
name: state-manager
description: This skill should be used when Claude needs to read, update, or manage the continuity state file (.claude/state/current.json). It provides safe state operations with backup, validation, and history tracking.
---

# State Manager

This skill provides safe and reliable operations for managing the infinity-claude state system.

## Purpose

The state-manager skill enables reading and updating the system's state file with automatic backups, JSON validation, and history tracking. It ensures state integrity across continuity cycles.

## When to Use This Skill

Use this skill when:
- Reading current state values (cycle count, metrics, next actions, etc.)
- Updating state values (progress, metrics, status)
- Incrementing counters (tasks completed, cycles run)
- Marking actions as complete
- Getting a summary of current state
- Need to safely modify state with automatic backups

## Usage

Execute the state-manager script from the project root:

```bash
bash .claude/skills/state-manager/scripts/state-manager.sh <command> [args]
```

### Available Commands

#### `summary`
Display a formatted summary of the current state including:
- Current cycle count
- Metrics (tasks completed, quality score)
- Next actions to be performed
- Active blockers
- Human intervention requirements

**Example:**
```bash
bash .claude/skills/state-manager/scripts/state-manager.sh summary
```

#### `get <key>`
Retrieve a specific value from the state file. Supports nested keys using dot notation.

**Examples:**
```bash
bash .claude/skills/state-manager/scripts/state-manager.sh get cycleCount
bash .claude/skills/state-manager/scripts/state-manager.sh get metrics.tasksCompleted
bash .claude/skills/state-manager/scripts/state-manager.sh get nextActions[0].description
```

#### `set <key> <value>`
Set a specific value in the state file. Automatically creates backups before modification.

**Examples:**
```bash
bash .claude/skills/state-manager/scripts/state-manager.sh set requiresHuman true
bash .claude/skills/state-manager/scripts/state-manager.sh set metrics.qualityScore 98
bash .claude/skills/state-manager/scripts/state-manager.sh set currentPhase implementation
```

#### `increment <key>`
Increment a numeric value in the state file. Useful for counters.

**Examples:**
```bash
bash .claude/skills/state-manager/scripts/state-manager.sh increment cycleCount
bash .claude/skills/state-manager/scripts/state-manager.sh increment metrics.tasksCompleted
```

#### `complete <action-id>`
Mark a specific action in nextActions as completed and move it to completedActions.

**Example:**
```bash
bash .claude/skills/state-manager/scripts/state-manager.sh complete "implement-user-auth"
```

## State File Structure

The state file (`.claude/state/current.json`) contains:
```json
{
  "cycleCount": 0,
  "lastRun": "timestamp",
  "currentPhase": "string",
  "requiresHuman": false,
  "metrics": {
    "tasksCompleted": 0,
    "qualityScore": 0
  },
  "nextActions": [],
  "completedActions": [],
  "blockers": []
}
```

## Safety Features

1. **Automatic Backups**: Every write operation creates a backup at `.claude/state/current.json.bak`
2. **JSON Validation**: All operations validate JSON structure before and after modifications
3. **History Tracking**: State changes are logged to `.claude/state/history.jsonl`
4. **Atomic Operations**: Updates use temporary files to prevent corruption

## Best Practices

1. **Read before write**: Always check current state before updating
2. **Use increment for counters**: Safer than get-modify-set
3. **Use complete for actions**: Properly tracks action lifecycle
4. **Check validation**: Ensure operations succeed before proceeding
5. **Prefer continuity-manager subagent**: For complex state updates, use the continuity-manager subagent which wraps this skill with higher-level logic

## Integration with System

The state-manager integrates with:
- Continuity cycles (read at start, update at end)
- The continuity-manager subagent (uses this skill internally)
- The monitor dashboard (displays state summary)
- All agents (can read state for context)
