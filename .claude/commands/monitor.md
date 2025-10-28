# Monitor Command

Display the current system status and monitoring dashboard.

## Instructions

Show a comprehensive view of the system's current state, progress, and health.

### Display Dashboard

Run the monitoring script:
```bash
bash .claude/scripts/monitor.sh
```

Or manually gather and display this information:

### Status Overview

```
📊 Status
├─ Phase: [current phase]
├─ Cycle: #[cycle count]
├─ Mode: [Autonomous / PAUSED]
├─ Health: [Healthy / Warning / Critical]
└─ Last Run: [timestamp]
```

### Metrics Summary

```
📈 Metrics
├─ Tasks Completed: [count]
├─ Agents Created: [count]
├─ Decisions Logged: [count]
└─ Success Rate: [percentage]%
```

### Quality Metrics

```
🛡️ Quality
├─ Quality Score: [score]/100 (must be >95)
├─ Test Coverage: [percentage]% (must be >80%)
├─ Linter Passes: [count]
├─ Security Scans: [count]
└─ Violations: [count]
```

### Active Agents

```
🤖 Active Agents
Total: [count]

• [agent_name] ([type]) - [status]
• [agent_name] ([type]) - [status]
```

### Next Actions (Top 5)

```
📋 Next Actions
[CRITICAL] [action description]
[HIGH] [action description]
[MEDIUM] [action description]
```

### Blockers (if any)

```
🚫 Blockers ([count])
• [blocker type]: [description]
```

### Recent Activity (Last 5 Cycles)

```
📜 Recent Activity
[timestamp] Cycle #X - success
[timestamp] Cycle #Y - success
[timestamp] Cycle #Z - failure
```

### Data Sources

Read from:
- `.claude/state/current.json` - Current state
- `.claude/state/agents.json` - Agent registry
- `.claude/state/history.jsonl` - Recent events
- `.claude/state/execution.log` - Execution logs

### Watch Mode

For continuous monitoring, use:
```bash
bash .claude/scripts/monitor.sh --watch
```

This refreshes every 10 seconds.

### Quick Commands Reference

```
⌨️ Quick Commands
State:     cat .claude/state/current.json | jq .
Logs:      tail -f .claude/state/execution.log
History:   tail -f .claude/state/history.jsonl
Run Now:   bash .claude/scripts/continuity.sh
Pause:     Set requiresHuman:true in current.json
Resume:    Set requiresHuman:false in current.json
```

### Analysis

After displaying the dashboard, provide brief analysis:

**Health Check:**
- Is the system running normally?
- Are there any concerning patterns?
- Is quality score acceptable?
- Are there blockers to address?

**Recommendations:**
- Any immediate actions needed?
- Should any metrics be improved?
- Are agents performing well?
- Is continuity functioning properly?

Use this command frequently to stay informed about system status!
