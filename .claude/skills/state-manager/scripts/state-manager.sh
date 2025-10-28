#!/bin/bash

# State Manager Skill
# Provides functions for managing state files safely

set -e

STATE_FILE=".claude/state/current.json"
BACKUP_FILE=".claude/state/current.json.bak"
HISTORY_FILE=".claude/state/history.jsonl"

# Create backup of state file
backup_state() {
    if [ -f "$STATE_FILE" ]; then
        cp "$STATE_FILE" "$BACKUP_FILE"
        echo "✓ State backed up to $BACKUP_FILE"
    fi
}

# Validate JSON structure
validate_state() {
    if jq empty "$STATE_FILE" 2>/dev/null; then
        echo "✓ State file is valid JSON"
        return 0
    else
        echo "✗ State file has invalid JSON"
        return 1
    fi
}

# Read state value
get_state_value() {
    local key="$1"
    jq -r ".$key" "$STATE_FILE" 2>/dev/null || echo "null"
}

# Update state value
set_state_value() {
    local key="$1"
    local value="$2"
    local tmp_file=$(mktemp)

    backup_state

    if [[ "$value" =~ ^[0-9]+$ ]]; then
        # Numeric value
        jq --arg key "$key" --argjson val "$value" 'setpath($key | split("."); $val)' "$STATE_FILE" > "$tmp_file"
    else
        # String value
        jq --arg key "$key" --arg val "$value" 'setpath($key | split("."); $val)' "$STATE_FILE" > "$tmp_file"
    fi

    if validate_state; then
        mv "$tmp_file" "$STATE_FILE"
        echo "✓ Updated $key"
    else
        echo "✗ Failed to update $key - restoring backup"
        mv "$BACKUP_FILE" "$STATE_FILE"
        rm -f "$tmp_file"
        return 1
    fi
}

# Increment counter
increment_counter() {
    local key="$1"
    local current=$(get_state_value "$key")
    local new_val=$((current + 1))
    set_state_value "$key" "$new_val"
}

# Update timestamp
update_timestamp() {
    local key="${1:-lastRun}"
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    set_state_value "$key" "$timestamp"
}

# Add to array
add_to_array() {
    local key="$1"
    local value="$2"
    local tmp_file=$(mktemp)

    backup_state

    jq --arg key "$key" --argjson val "$value" '.[$key] += [$val]' "$STATE_FILE" > "$tmp_file"

    if jq empty "$tmp_file" 2>/dev/null; then
        mv "$tmp_file" "$STATE_FILE"
        echo "✓ Added to $key array"
    else
        echo "✗ Failed to add to $key array"
        rm -f "$tmp_file"
        return 1
    fi
}

# Remove from array by index
remove_from_array() {
    local key="$1"
    local index="$2"
    local tmp_file=$(mktemp)

    backup_state

    jq --arg key "$key" --argjson idx "$index" 'del(.[$key][$idx])' "$STATE_FILE" > "$tmp_file"

    if jq empty "$tmp_file" 2>/dev/null; then
        mv "$tmp_file" "$STATE_FILE"
        echo "✓ Removed from $key array at index $index"
    else
        echo "✗ Failed to remove from $key array"
        rm -f "$tmp_file"
        return 1
    fi
}

# Move action from nextActions to completedActions
complete_action() {
    local action_id="$1"
    local tmp_file=$(mktemp)

    backup_state

    jq --arg id "$action_id" '
        (.nextActions[] | select(.id == $id)) as $action |
        .completedActions += [$action] |
        .nextActions = [.nextActions[] | select(.id != $id)]
    ' "$STATE_FILE" > "$tmp_file"

    if jq empty "$tmp_file" 2>/dev/null; then
        mv "$tmp_file" "$STATE_FILE"
        echo "✓ Completed action: $action_id"
    else
        echo "✗ Failed to complete action"
        rm -f "$tmp_file"
        return 1
    fi
}

# Log event to history
log_event() {
    local event_type="$1"
    local data="$2"
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)

    echo "{\"timestamp\":\"$timestamp\",\"event\":\"$event_type\",\"data\":$data}" >> "$HISTORY_FILE"
    echo "✓ Logged event: $event_type"
}

# Display current state summary
show_summary() {
    echo "📊 State Summary"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Cycle: $(get_state_value 'cycleCount')"
    echo "Phase: $(get_state_value 'currentPhase')"
    echo "Last Run: $(get_state_value 'lastRun')"
    echo "Requires Human: $(get_state_value 'requiresHuman')"
    echo ""
    echo "Metrics:"
    echo "  Tasks Completed: $(get_state_value 'metrics.tasksCompleted')"
    echo "  Agents Created: $(get_state_value 'metrics.agentsCreated')"
    echo "  Success Rate: $(get_state_value 'metrics.successRate')%"
    echo "  Quality Score: $(get_state_value 'metrics.quality.qualityScore')/100"
    echo ""
    echo "Health: $(get_state_value 'health.status')"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Restore from backup
restore_backup() {
    if [ -f "$BACKUP_FILE" ]; then
        cp "$BACKUP_FILE" "$STATE_FILE"
        echo "✓ State restored from backup"
    else
        echo "✗ No backup file found"
        return 1
    fi
}

# Main command handler
case "${1:-}" in
    backup)
        backup_state
        ;;
    validate)
        validate_state
        ;;
    get)
        get_state_value "$2"
        ;;
    set)
        set_state_value "$2" "$3"
        ;;
    increment)
        increment_counter "$2"
        ;;
    timestamp)
        update_timestamp "$2"
        ;;
    complete)
        complete_action "$2"
        ;;
    log)
        log_event "$2" "$3"
        ;;
    summary)
        show_summary
        ;;
    restore)
        restore_backup
        ;;
    *)
        echo "State Manager Skill"
        echo ""
        echo "Usage: $0 <command> [args]"
        echo ""
        echo "Commands:"
        echo "  backup              - Create backup of state file"
        echo "  validate            - Validate JSON structure"
        echo "  get <key>           - Read value from state"
        echo "  set <key> <value>   - Update value in state"
        echo "  increment <key>     - Increment counter"
        echo "  timestamp [key]     - Update timestamp (default: lastRun)"
        echo "  complete <id>       - Move action to completed"
        echo "  log <type> <data>   - Log event to history"
        echo "  summary             - Display state summary"
        echo "  restore             - Restore from backup"
        echo ""
        echo "Examples:"
        echo "  $0 get cycleCount"
        echo "  $0 increment metrics.tasksCompleted"
        echo "  $0 timestamp"
        echo "  $0 complete act-001"
        echo "  $0 summary"
        ;;
esac
