#!/bin/bash

# Agent Spawning Tool
# Usage: spawn_agent.sh <name> <type> <purpose>

set -e

if [ $# -lt 3 ]; then
    echo "Usage: $0 <name> <type> <purpose>"
    echo "Example: $0 quality_checker validator 'Automated code review and testing'"
    exit 1
fi

AGENT_NAME=$1
AGENT_TYPE=$2
AGENT_PURPOSE=$3

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
AGENTS_DIR="$PROJECT_ROOT/.claude/agents"
STATE_FILE="$PROJECT_ROOT/.claude/state/current.json"
AGENTS_REGISTRY="$PROJECT_ROOT/.claude/state/agents.json"

# Create agent directory
AGENT_DIR="$AGENTS_DIR/$AGENT_NAME"
mkdir -p "$AGENT_DIR"

echo "Creating agent: $AGENT_NAME"

# Create agent README
cat > "$AGENT_DIR/README.md" <<EOF
# Agent: $AGENT_NAME

**Type**: $AGENT_TYPE  
**Purpose**: $AGENT_PURPOSE  
**Created**: $(date)  
**Status**: Active

## Overview
This agent was created to $AGENT_PURPOSE.

## Capabilities
- [To be defined by creating agent]
- [Add capabilities as they're implemented]

## Interface
### Commands
\`\`\`bash
# Add commands this agent responds to
\`\`\`

### Inputs
- [What this agent accepts]

### Outputs
- [What this agent produces]

## Dependencies
- [List any dependencies]

## Configuration
\`\`\`json
{
  "name": "$AGENT_NAME",
  "type": "$AGENT_TYPE",
  "enabled": true
}
\`\`\`

## Logs
See: \`.claude/agents/$AGENT_NAME/logs/\`

## Notes
- [Add operational notes]
- [Document learnings and improvements]
EOF

# Create agent structure
mkdir -p "$AGENT_DIR/logs"
mkdir -p "$AGENT_DIR/config"
mkdir -p "$AGENT_DIR/skills"

# Create agent config
cat > "$AGENT_DIR/config/agent.json" <<EOF
{
  "name": "$AGENT_NAME",
  "type": "$AGENT_TYPE",
  "purpose": "$AGENT_PURPOSE",
  "created": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "version": "1.0.0",
  "status": "active",
  "enabled": true,
  "capabilities": [],
  "dependencies": [],
  "metrics": {
    "tasksCompleted": 0,
    "successRate": 100,
    "avgExecutionTime": 0
  }
}
EOF

# Create initial skill template
cat > "$AGENT_DIR/skills/main.sh" <<EOF
#!/bin/bash
# Main skill for $AGENT_NAME agent

# Add agent logic here

echo "Agent $AGENT_NAME executed"
EOF

chmod +x "$AGENT_DIR/skills/main.sh"

# Update agents registry
if [ ! -f "$AGENTS_REGISTRY" ]; then
    echo "{}" > "$AGENTS_REGISTRY"
fi

jq --arg name "$AGENT_NAME" \
   --arg type "$AGENT_TYPE" \
   --arg purpose "$AGENT_PURPOSE" \
   --arg created "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
   '.[$name] = {
     "type": $type,
     "purpose": $purpose,
     "created": $created,
     "status": "active",
     "path": ".claude/agents/\($name)"
   }' "$AGENTS_REGISTRY" > "$AGENTS_REGISTRY.tmp"
mv "$AGENTS_REGISTRY.tmp" "$AGENTS_REGISTRY"

# Update state file
if [ -f "$STATE_FILE" ]; then
    jq --arg name "$AGENT_NAME" \
       --arg type "$AGENT_TYPE" \
       --arg purpose "$AGENT_PURPOSE" \
       --arg created "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
       '.agents[$name] = {
         "status": "active",
         "created": $created,
         "purpose": $purpose,
         "capabilities": []
       } | .metrics.agentsCreated += 1' "$STATE_FILE" > "$STATE_FILE.tmp"
    mv "$STATE_FILE.tmp" "$STATE_FILE"
fi

echo "✓ Agent $AGENT_NAME created successfully"
echo "  Location: $AGENT_DIR"
echo "  Config: $AGENT_DIR/config/agent.json"
echo "  README: $AGENT_DIR/README.md"
echo ""
echo "Next steps:"
echo "  1. Edit $AGENT_DIR/README.md to document capabilities"
echo "  2. Add skills to $AGENT_DIR/skills/"
echo "  3. Update agent config as needed"