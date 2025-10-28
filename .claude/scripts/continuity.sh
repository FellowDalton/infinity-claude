#!/bin/bash

# Self-Sustaining Claude Execution Script
# Runs every 30 minutes to ensure continuous progress

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
STATE_DIR="$PROJECT_ROOT/.claude/state"
LOG_FILE="$STATE_DIR/execution.log"
STATE_FILE="$STATE_DIR/current.json"
HISTORY_FILE="$STATE_DIR/history.jsonl"

cd "$PROJECT_ROOT"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Start execution
log "=== Continuity Check Started ==="

# Verify state file exists
if [ ! -f "$STATE_FILE" ]; then
    log "ERROR: State file not found at $STATE_FILE"
    exit 1
fi

# Check if human intervention is required
REQUIRES_HUMAN=$(jq -r '.requiresHuman' "$STATE_FILE" 2>/dev/null || echo "false")

if [ "$REQUIRES_HUMAN" = "true" ]; then
    log "Human intervention required. Automated run skipped."
    log "Check blockers in $STATE_FILE for details."
    exit 0
fi

# Get current cycle count
CYCLE_COUNT=$(jq -r '.cycleCount' "$STATE_FILE" 2>/dev/null || echo "0")
NEW_CYCLE=$((CYCLE_COUNT + 1))

log "Starting cycle #$NEW_CYCLE"

# Log cycle start to history
echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"event\":\"cycle_start\",\"cycle\":$NEW_CYCLE}" >> "$HISTORY_FILE"

# Run Claude Code with continuation prompt
PROMPT="You are in cycle #$NEW_CYCLE. Read .claude/state/current.json for context. Execute your next planned actions, update state with progress, and plan what comes next. If you've been stuck on the same task for 3+ cycles, create a helper agent or tool to unblock yourself. Remember: you must always plan next actions before finishing to ensure continuity."

log "Executing Claude Code..."

# Run claude-code (adjust command based on your setup)
if command -v claude-code &> /dev/null; then
    claude-code run --non-interactive --prompt "$PROMPT" >> "$LOG_FILE" 2>&1
    EXIT_CODE=$?
else
    log "WARNING: claude-code not found in PATH. Attempting alternative execution..."
    # Alternative: you might need to adjust this based on your setup
    # claude run --prompt "$PROMPT" >> "$LOG_FILE" 2>&1
    EXIT_CODE=1
fi

# Log result
if [ $EXIT_CODE -eq 0 ]; then
    log "Cycle #$NEW_CYCLE completed successfully"
    echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"event\":\"cycle_complete\",\"cycle\":$NEW_CYCLE,\"status\":\"success\"}" >> "$HISTORY_FILE"
else
    log "Cycle #$NEW_CYCLE failed with exit code $EXIT_CODE"
    echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"event\":\"cycle_complete\",\"cycle\":$NEW_CYCLE,\"status\":\"failure\",\"exitCode\":$EXIT_CODE}" >> "$HISTORY_FILE"
    
    # Increment failure counter
    FAILURES=$(jq -r '.health.consecutiveFailures' "$STATE_FILE" 2>/dev/null || echo "0")
    NEW_FAILURES=$((FAILURES + 1))
    
    # Update state with failure info
    jq ".health.consecutiveFailures = $NEW_FAILURES | .health.lastHealthCheck = \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"" "$STATE_FILE" > "$STATE_FILE.tmp"
    mv "$STATE_FILE.tmp" "$STATE_FILE"
    
    # If 3+ consecutive failures, flag for human intervention
    if [ $NEW_FAILURES -ge 3 ]; then
        log "WARNING: 3+ consecutive failures detected. Flagging for human intervention."
        jq '.requiresHuman = true | .health.needsIntervention = true | .health.status = "critical" | .blockers += [{"type": "consecutive_failures", "count": '$NEW_FAILURES', "timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}]' "$STATE_FILE" > "$STATE_FILE.tmp"
        mv "$STATE_FILE.tmp" "$STATE_FILE"
    fi
fi

log "=== Continuity Check Completed ==="
echo "" >> "$LOG_FILE"

exit $EXIT_CODE