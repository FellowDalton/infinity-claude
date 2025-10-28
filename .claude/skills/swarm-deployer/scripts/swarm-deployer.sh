#!/bin/bash

# Swarm Deployer Skill
# Deploy and manage Haiku-powered swarm agents

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$PROJECT_ROOT"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'

# Swarm templates directory
SWARM_DIR=".claude/subagents/swarm"
RESULTS_DIR=".claude/state/swarm-results"

# Ensure directories exist
mkdir -p "$SWARM_DIR" "$RESULTS_DIR"

# List available swarm templates
list_templates() {
    echo -e "${BLUE}${BOLD}Available Swarm Templates:${NC}"
    echo ""

    if [ -d "$SWARM_DIR" ]; then
        for template in "$SWARM_DIR"/*.md; do
            if [ -f "$template" ]; then
                name=$(basename "$template" .md)
                purpose=$(grep "^**Purpose**:" "$template" | sed 's/\*\*Purpose\*\*: //' || echo "No description")
                echo -e "  ${CYAN}•${NC} ${BOLD}$name${NC}"
                echo -e "    $purpose"
                echo ""
            fi
        done
    else
        echo -e "${YELLOW}No templates found. Create templates in $SWARM_DIR/${NC}"
    fi
}

# Create swarm template
create_template() {
    local name="$1"
    local purpose="$2"

    if [ -z "$name" ] || [ -z "$purpose" ]; then
        echo -e "${RED}Usage: $0 create-template <name> <purpose>${NC}"
        exit 1
    fi

    local template_file="$SWARM_DIR/$name.md"

    if [ -f "$template_file" ]; then
        echo -e "${RED}Template '$name' already exists${NC}"
        exit 1
    fi

    cat > "$template_file" <<EOF
# $name Swarm Agent (Haiku)

**Model**: Haiku
**Purpose**: $purpose
**Type**: Focused, parallel execution

## Task

Perform focused analysis/processing on a single input.

## Input

Describe what each agent receives (file path, URL, data, etc.)

## Instructions

1. Clear, specific instructions
2. Keep task atomic and focused
3. Ensure agent can complete independently

## Output Format

Return structured JSON:
\`\`\`json
{
  "input": "what was processed",
  "status": "success|failure",
  "result": {
    // Task-specific results
  },
  "metadata": {
    "timestamp": "ISO 8601",
    "duration": "processing time"
  }
}
\`\`\`

## Success Criteria

- Task completed in <30 seconds
- Output is structured and parseable
- No dependencies on other agents
EOF

    echo -e "${GREEN}✓ Created template: $template_file${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Edit $template_file with specific instructions"
    echo "  2. Test with: $0 test $name <sample-input>"
    echo "  3. Deploy with: $0 deploy $name <pattern>"
}

# Plan swarm deployment
plan() {
    local template="$1"
    local pattern="$2"

    if [ -z "$template" ] || [ -z "$pattern" ]; then
        echo -e "${RED}Usage: $0 plan <template> <file-pattern>${NC}"
        exit 1
    fi

    if [ ! -f "$SWARM_DIR/$template.md" ]; then
        echo -e "${RED}Template '$template' not found${NC}"
        exit 1
    fi

    echo -e "${BLUE}${BOLD}Swarm Deployment Plan${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}Template:${NC} $template"
    echo -e "${CYAN}Pattern:${NC} $pattern"
    echo ""

    # Find matching files
    local files=($(eval "find . -path '$pattern' -type f 2>/dev/null" || echo ""))
    local count=${#files[@]}

    if [ $count -eq 0 ]; then
        echo -e "${RED}No files match pattern: $pattern${NC}"
        exit 1
    fi

    echo -e "${CYAN}Targets:${NC} $count files"
    echo ""

    if [ $count -le 10 ]; then
        echo "Files:"
        for file in "${files[@]}"; do
            echo "  • $file"
        done
    else
        echo "Sample files (showing first 10):"
        for i in {0..9}; do
            if [ $i -lt $count ]; then
                echo "  • ${files[$i]}"
            fi
        done
        echo "  ... and $((count - 10)) more"
    fi

    echo ""
    echo -e "${YELLOW}Estimated:${NC}"
    echo "  • Agents: $count"
    echo "  • Model: Haiku"
    echo "  • Duration: ~30 seconds"
    echo "  • Cost: Low (batch Haiku calls)"
    echo ""
    echo -e "${GREEN}Ready to deploy?${NC}"
    echo "  Run: $0 deploy $template \"$pattern\""
}

# Generate deployment instructions
deploy() {
    local template="$1"
    local pattern="$2"

    if [ -z "$template" ] || [ -z "$pattern" ]; then
        echo -e "${RED}Usage: $0 deploy <template> <file-pattern>${NC}"
        exit 1
    fi

    if [ ! -f "$SWARM_DIR/$template.md" ]; then
        echo -e "${RED}Template '$template' not found${NC}"
        exit 1
    fi

    # Find matching files
    local files=($(eval "find . -path '$pattern' -type f 2>/dev/null" || echo ""))
    local count=${#files[@]}

    if [ $count -eq 0 ]; then
        echo -e "${RED}No files match pattern: $pattern${NC}"
        exit 1
    fi

    # Create deployment manifest
    local deployment_id="swarm-$(date +%s)"
    local manifest_file="$RESULTS_DIR/$deployment_id-manifest.json"

    echo "{" > "$manifest_file"
    echo "  \"id\": \"$deployment_id\"," >> "$manifest_file"
    echo "  \"template\": \"$template\"," >> "$manifest_file"
    echo "  \"pattern\": \"$pattern\"," >> "$manifest_file"
    echo "  \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"," >> "$manifest_file"
    echo "  \"agentCount\": $count," >> "$manifest_file"
    echo "  \"status\": \"pending\"," >> "$manifest_file"
    echo "  \"inputs\": [" >> "$manifest_file"

    for i in "${!files[@]}"; do
        echo -n "    \"${files[$i]}\"" >> "$manifest_file"
        if [ $i -lt $((count - 1)) ]; then
            echo "," >> "$manifest_file"
        else
            echo "" >> "$manifest_file"
        fi
    done

    echo "  ]" >> "$manifest_file"
    echo "}" >> "$manifest_file"

    echo -e "${GREEN}${BOLD}Swarm Deployment Ready${NC}"
    echo -e "${GREEN}═══════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}Deployment ID:${NC} $deployment_id"
    echo -e "${CYAN}Template:${NC} $template"
    echo -e "${CYAN}Agent Count:${NC} $count"
    echo -e "${CYAN}Manifest:${NC} $manifest_file"
    echo ""
    echo -e "${YELLOW}${BOLD}Instructions for Claude:${NC}"
    echo ""
    echo "Deploy a swarm of $count Haiku agents using the '$template' template."
    echo ""
    echo "For each input file, create a Haiku agent with:"
    echo "  - Template: .claude/subagents/swarm/$template.md"
    echo "  - Input: [file path from manifest]"
    echo "  - Output: Structured JSON result"
    echo ""
    echo "Inputs (from manifest):"
    cat "$manifest_file" | jq -r '.inputs[]' | head -5
    if [ $count -gt 5 ]; then
        echo "... and $((count - 5)) more (see $manifest_file)"
    fi
    echo ""
    echo "Once all agents complete:"
    echo "  1. Aggregate results into $RESULTS_DIR/$deployment_id-results.json"
    echo "  2. Generate summary report"
    echo "  3. Update state with findings"
    echo ""
    echo -e "${CYAN}Use the Task tool to deploy $count agents in parallel${NC}"
}

# Show recent swarm deployments
history() {
    echo -e "${BLUE}${BOLD}Recent Swarm Deployments${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo ""

    if [ ! -d "$RESULTS_DIR" ] || [ -z "$(ls -A $RESULTS_DIR 2>/dev/null)" ]; then
        echo -e "${YELLOW}No deployments found${NC}"
        return
    fi

    for manifest in "$RESULTS_DIR"/swarm-*-manifest.json; do
        if [ -f "$manifest" ]; then
            local id=$(jq -r '.id' "$manifest")
            local template=$(jq -r '.template' "$manifest")
            local count=$(jq -r '.agentCount' "$manifest")
            local timestamp=$(jq -r '.timestamp' "$manifest")
            local status=$(jq -r '.status' "$manifest")

            echo -e "${CYAN}$id${NC}"
            echo "  Template: $template"
            echo "  Agents: $count"
            echo "  Time: $timestamp"
            echo "  Status: $status"
            echo ""
        fi
    done
}

# Main command handler
case "${1:-}" in
    list|ls)
        list_templates
        ;;
    create-template|create)
        create_template "$2" "$3"
        ;;
    plan)
        plan "$2" "$3"
        ;;
    deploy)
        deploy "$2" "$3"
        ;;
    history|hist)
        history
        ;;
    *)
        echo -e "${BOLD}${BLUE}Swarm Deployer Skill${NC}"
        echo ""
        echo "Deploy parallel Haiku-powered swarm agents for focused tasks."
        echo ""
        echo -e "${BOLD}Usage:${NC} $0 <command> [args]"
        echo ""
        echo -e "${BOLD}Commands:${NC}"
        echo "  ${CYAN}list${NC}                           - List available swarm templates"
        echo "  ${CYAN}create-template${NC} <name> <desc>  - Create new swarm template"
        echo "  ${CYAN}plan${NC} <template> <pattern>      - Plan swarm deployment"
        echo "  ${CYAN}deploy${NC} <template> <pattern>    - Generate deployment instructions"
        echo "  ${CYAN}history${NC}                        - Show recent deployments"
        echo ""
        echo -e "${BOLD}Examples:${NC}"
        echo "  $0 list"
        echo "  $0 create-template security-scanner 'Check files for security issues'"
        echo "  $0 plan security-scanner 'src/**/*.js'"
        echo "  $0 deploy security-scanner 'src/**/*.js'"
        echo "  $0 history"
        echo ""
        echo -e "${BOLD}Workflow:${NC}"
        echo "  1. Create or choose template: $0 list"
        echo "  2. Plan deployment: $0 plan <template> <pattern>"
        echo "  3. Deploy swarm: $0 deploy <template> <pattern>"
        echo "  4. Claude deploys N Haiku agents in parallel"
        echo "  5. Results aggregated and reported"
        ;;
esac
