#!/bin/bash

# Real-time Monitoring Dashboard for Self-Evolving Claude Project
# Usage: bash monitor.sh [--watch]

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_FILE="$PROJECT_ROOT/.claude/state/current.json"
HISTORY_FILE="$PROJECT_ROOT/.claude/state/history.jsonl"
AGENTS_FILE="$PROJECT_ROOT/.claude/state/agents.json"
LOG_FILE="$PROJECT_ROOT/.claude/state/execution.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Check if watch mode
WATCH_MODE=false
if [ "$1" = "--watch" ] || [ "$1" = "-w" ]; then
    WATCH_MODE=true
fi

display_dashboard() {
    clear
    
    # Header
    echo -e "${BOLD}${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║        Self-Evolving Claude Project - Dashboard               ║${NC}"
    echo -e "${BOLD}${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ ! -f "$STATE_FILE" ]; then
        echo -e "${RED}❌ State file not found. Run setup.sh first.${NC}"
        return 1
    fi
    
    # Parse state
    PHASE=$(jq -r '.currentPhase' "$STATE_FILE" 2>/dev/null || echo "unknown")
    CYCLE=$(jq -r '.cycleCount' "$STATE_FILE" 2>/dev/null || echo "0")
    REQUIRES_HUMAN=$(jq -r '.requiresHuman' "$STATE_FILE" 2>/dev/null || echo "false")
    HEALTH_STATUS=$(jq -r '.health.status' "$STATE_FILE" 2>/dev/null || echo "unknown")
    LAST_RUN=$(jq -r '.lastRun' "$STATE_FILE" 2>/dev/null || echo "never")
    
    # Status Section
    echo -e "${BOLD}📊 Status${NC}"
    echo -e "${BLUE}├─ Phase:${NC} $PHASE"
    echo -e "${BLUE}├─ Cycle:${NC} #$CYCLE"
    
    if [ "$REQUIRES_HUMAN" = "true" ]; then
        echo -e "${BLUE}├─ Mode:${NC} ${RED}⚠️  PAUSED - Human Intervention Required${NC}"
    else
        echo -e "${BLUE}├─ Mode:${NC} ${GREEN}✓ Autonomous${NC}"
    fi
    
    if [ "$HEALTH_STATUS" = "healthy" ]; then
        echo -e "${BLUE}├─ Health:${NC} ${GREEN}● Healthy${NC}"
    elif [ "$HEALTH_STATUS" = "warning" ]; then
        echo -e "${BLUE}├─ Health:${NC} ${YELLOW}● Warning${NC}"
    else
        echo -e "${BLUE}├─ Health:${NC} ${RED}● Critical${NC}"
    fi
    
    echo -e "${BLUE}└─ Last Run:${NC} $LAST_RUN"
    echo ""
    
    # Metrics Section
    TASKS_COMPLETED=$(jq -r '.metrics.tasksCompleted' "$STATE_FILE" 2>/dev/null || echo "0")
    AGENTS_CREATED=$(jq -r '.metrics.agentsCreated' "$STATE_FILE" 2>/dev/null || echo "0")
    DECISIONS_LOGGED=$(jq -r '.metrics.decisionsLogged' "$STATE_FILE" 2>/dev/null || echo "0")
    SUCCESS_RATE=$(jq -r '.metrics.successRate' "$STATE_FILE" 2>/dev/null || echo "0")
    
    echo -e "${BOLD}📈 Metrics${NC}"
    echo -e "${MAGENTA}├─ Tasks Completed:${NC} $TASKS_COMPLETED"
    echo -e "${MAGENTA}├─ Agents Created:${NC} $AGENTS_CREATED"
    echo -e "${MAGENTA}├─ Decisions Logged:${NC} $DECISIONS_LOGGED"
    echo -e "${MAGENTA}└─ Success Rate:${NC} ${SUCCESS_RATE}%"
    echo ""
    
    # Agents Section
    echo -e "${BOLD}🤖 Active Agents${NC}"
    if [ -f "$AGENTS_FILE" ]; then
        AGENT_COUNT=$(jq 'length' "$AGENTS_FILE" 2>/dev/null || echo "0")
        echo -e "${CYAN}Total: $AGENT_COUNT${NC}"
        echo ""
        jq -r 'to_entries[] | "  • \(.key) (\(.value.type)) - \(.value.status)"' "$AGENTS_FILE" 2>/dev/null || echo "  No agents"
    else
        echo -e "${YELLOW}  No agents registered yet${NC}"
    fi
    echo ""
    
    # Next Actions Section
    echo -e "${BOLD}📋 Next Actions (Top 5)${NC}"
    NEXT_ACTIONS=$(jq -r '.nextActions[:5] | .[] | "  [\(.priority | ascii_upcase)] \(.action)"' "$STATE_FILE" 2>/dev/null)
    if [ -z "$NEXT_ACTIONS" ]; then
        echo -e "${YELLOW}  No actions planned${NC}"
    else
        echo "$NEXT_ACTIONS" | while IFS= read -r line; do
            if [[ $line == *"CRITICAL"* ]]; then
                echo -e "${RED}$line${NC}"
            elif [[ $line == *"HIGH"* ]]; then
                echo -e "${YELLOW}$line${NC}"
            else
                echo -e "${GREEN}$line${NC}"
            fi
        done
    fi
    echo ""
    
    # Blockers Section
    BLOCKER_COUNT=$(jq '.blockers | length' "$STATE_FILE" 2>/dev/null || echo "0")
    if [ "$BLOCKER_COUNT" -gt 0 ]; then
        echo -e "${BOLD}${RED}🚫 Blockers ($BLOCKER_COUNT)${NC}"
        jq -r '.blockers[] | "  • \(.type): \(.message // "No details")"' "$STATE_FILE" 2>/dev/null
        echo ""
    fi
    
    # Recent Activity Section
    echo -e "${BOLD}📜 Recent Activity (Last 5 cycles)${NC}"
    if [ -f "$HISTORY_FILE" ]; then
        tail -10 "$HISTORY_FILE" | jq -r 'select(.event == "cycle_complete") | "  [\(.timestamp)] Cycle #\(.cycle) - \(.status)"' 2>/dev/null | tail -5 | while IFS= read -r line; do
            if [[ $line == *"success"* ]]; then
                echo -e "${GREEN}$line${NC}"
            else
                echo -e "${RED}$line${NC}"
            fi
        done
    else
        echo -e "${YELLOW}  No activity logged yet${NC}"
    fi
    echo ""
    
    # Quick Commands
    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}⌨️  Quick Commands${NC}"
    echo -e "  ${CYAN}State:${NC}     cat .claude/state/current.json | jq ."
    echo -e "  ${CYAN}Logs:${NC}      tail -f .claude/state/execution.log"
    echo -e "  ${CYAN}History:${NC}   tail -f .claude/state/history.jsonl"
    echo -e "  ${CYAN}Run Now:${NC}   bash .claude/scripts/continuity.sh"
    echo -e "  ${CYAN}Pause:${NC}     Set requiresHuman:true in current.json"
    echo -e "  ${CYAN}Resume:${NC}    Set requiresHuman:false in current.json"
    echo ""
    
    if [ "$WATCH_MODE" = true ]; then
        echo -e "${CYAN}🔄 Auto-refreshing every 10 seconds... (Press Ctrl+C to exit)${NC}"
    fi
}

# Main execution
if [ "$WATCH_MODE" = true ]; then
    while true; do
        display_dashboard
        sleep 10
    done
else
    display_dashboard
    echo ""
    echo -e "${CYAN}💡 Tip: Run with --watch flag for live monitoring${NC}"
    echo -e "   ${BOLD}bash monitor.sh --watch${NC}"
fi