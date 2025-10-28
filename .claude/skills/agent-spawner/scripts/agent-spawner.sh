#!/bin/bash

# Agent Spawner Skill
# Wrapper for creating agents with validation and templates

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$PROJECT_ROOT"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Validate agent name
validate_name() {
    local name="$1"

    if [[ ! "$name" =~ ^[a-z][a-z0-9_-]*$ ]]; then
        echo -e "${RED}✗ Invalid agent name. Use lowercase letters, numbers, hyphens, and underscores only.${NC}"
        return 1
    fi

    if [ -d ".claude/agents/$name" ]; then
        echo -e "${RED}✗ Agent '$name' already exists${NC}"
        return 1
    fi

    return 0
}

# Interactive agent creation
interactive_create() {
    echo -e "${BLUE}=== Interactive Agent Creation ===${NC}"
    echo ""

    # Get agent name
    echo -e "${BLUE}Agent name (lowercase, e.g., quality_enforcer):${NC}"
    read -r AGENT_NAME

    if ! validate_name "$AGENT_NAME"; then
        exit 1
    fi

    # Get agent type
    echo ""
    echo -e "${BLUE}Agent type (e.g., validator, analyzer, builder):${NC}"
    read -r AGENT_TYPE

    # Get agent purpose
    echo ""
    echo -e "${BLUE}Agent purpose (clear, specific description):${NC}"
    read -r AGENT_PURPOSE

    # Confirm
    echo ""
    echo -e "${YELLOW}Creating agent:${NC}"
    echo "  Name: $AGENT_NAME"
    echo "  Type: $AGENT_TYPE"
    echo "  Purpose: $AGENT_PURPOSE"
    echo ""
    echo -e "${BLUE}Proceed? (y/n):${NC}"
    read -r CONFIRM

    if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
        create_agent "$AGENT_NAME" "$AGENT_TYPE" "$AGENT_PURPOSE"
    else
        echo "Cancelled"
        exit 0
    fi
}

# Create agent
create_agent() {
    local name="$1"
    local type="$2"
    local purpose="$3"

    echo -e "${BLUE}Creating agent: $name${NC}"

    # Run spawn script
    bash .claude/scripts/spawn_agent.sh "$name" "$type" "$purpose"

    # Add agent-specific templates based on type
    case "$type" in
        validator|quality_enforcer)
            add_validator_template "$name"
            ;;
        analyzer|researcher)
            add_analyzer_template "$name"
            ;;
        builder|developer)
            add_builder_template "$name"
            ;;
    esac

    echo ""
    echo -e "${GREEN}✓ Agent '$name' created successfully${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Edit .claude/agents/$name/README.md"
    echo "  2. Add skills to .claude/agents/$name/skills/"
    echo "  3. Assign tasks in state file nextActions"
}

# Add validator template
add_validator_template() {
    local name="$1"
    local agent_dir=".claude/agents/$name"

    cat > "$agent_dir/skills/validate.sh" <<'EOF'
#!/bin/bash
# Validation skill

# Add validation logic here
echo "Running validation..."

# Example: Run quality checks
bash .claude/skills/quality-validator/scripts/quality-validator.sh quick

# Return 0 for success, 1 for failure
EOF

    chmod +x "$agent_dir/skills/validate.sh"
    echo "  ✓ Added validation skill"
}

# Add analyzer template
add_analyzer_template() {
    local name="$1"
    local agent_dir=".claude/agents/$name"

    cat > "$agent_dir/skills/analyze.sh" <<'EOF'
#!/bin/bash
# Analysis skill

# Add analysis logic here
echo "Running analysis..."

# Example: Analyze codebase or research topics

# Return results
EOF

    chmod +x "$agent_dir/skills/analyze.sh"
    echo "  ✓ Added analysis skill"
}

# Add builder template
add_builder_template() {
    local name="$1"
    local agent_dir=".claude/agents/$name"

    cat > "$agent_dir/skills/build.sh" <<'EOF'
#!/bin/bash
# Build skill

# Add build logic here
echo "Building..."

# Example: Generate code, create files, set up structure

# Return status
EOF

    chmod +x "$agent_dir/skills/build.sh"
    echo "  ✓ Added build skill"
}

# List existing agents
list_agents() {
    echo -e "${BLUE}Existing Agents:${NC}"
    echo ""

    if [ -f ".claude/state/agents.json" ]; then
        jq -r 'to_entries[] | "  • \(.key) (\(.value.type)) - \(.value.status)"' .claude/state/agents.json
    else
        echo "  No agents registered"
    fi
}

# Agent info
show_agent_info() {
    local name="$1"

    if [ ! -d ".claude/agents/$name" ]; then
        echo -e "${RED}✗ Agent '$name' not found${NC}"
        exit 1
    fi

    echo -e "${BLUE}Agent: $name${NC}"
    echo ""

    if [ -f ".claude/agents/$name/config/agent.json" ]; then
        cat ".claude/agents/$name/config/agent.json" | jq .
    fi

    echo ""
    echo "Skills:"
    ls -1 ".claude/agents/$name/skills/" 2>/dev/null || echo "  None"

    echo ""
    echo "Recent logs:"
    ls -1t ".claude/agents/$name/logs/" 2>/dev/null | head -5 || echo "  None"
}

# Main command handler
case "${1:-}" in
    create)
        if [ -z "$2" ]; then
            echo -e "${RED}Usage: $0 create <name> <type> <purpose>${NC}"
            exit 1
        fi
        create_agent "$2" "$3" "$4"
        ;;
    interactive|i)
        interactive_create
        ;;
    list|ls)
        list_agents
        ;;
    info)
        if [ -z "$2" ]; then
            echo -e "${RED}Usage: $0 info <name>${NC}"
            exit 1
        fi
        show_agent_info "$2"
        ;;
    *)
        echo "Agent Spawner Skill"
        echo ""
        echo "Usage: $0 <command> [args]"
        echo ""
        echo "Commands:"
        echo "  create <name> <type> <purpose>  - Create new agent"
        echo "  interactive (or i)               - Interactive creation"
        echo "  list (or ls)                     - List existing agents"
        echo "  info <name>                      - Show agent information"
        echo ""
        echo "Examples:"
        echo "  $0 interactive"
        echo "  $0 create quality_enforcer validator 'Validates code quality'"
        echo "  $0 list"
        echo "  $0 info quality_enforcer"
        ;;
esac
