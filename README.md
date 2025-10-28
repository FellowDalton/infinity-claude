# Self-Evolving Claude Project

An autonomous development system where Claude can create its own agents, tools, workflows, and continuously evolve to build applications without human intervention.

## 🎯 Overview

This project gives Claude complete autonomy to:
- **Research and enforce industry best practices** (CRITICAL PRIORITY)
- Break down requirements into phases
- Create specialized agents (quality_enforcer, researcher, architect, etc.)
- Design and build applications with rigorous quality standards
- Self-organize and continuously improve
- Never stop working (auto-runs every 30 minutes)

### 🚨 Quality-First Approach

Claude has **internet access** and uses it to:
- Research current best practices before writing any code
- Find and implement industry-standard tools (linters, testers, security scanners)
- Study high-quality open source projects
- Create rigorous quality validation systems
- Block any code that doesn't meet standards
- Continuously improve quality enforcement

**No code ships without passing ALL quality gates.**

## 🚀 Quick Start

### 1. Run Setup

```bash
bash .claude/scripts/setup.sh
```

This creates the entire directory structure and all necessary files.

### 2. Set Up Auto-Execution

**Linux/Mac:**
```bash
crontab -e
# Add this line (replace /path/to/project with actual path):
*/30 * * * * cd /path/to/project && bash .claude/scripts/continuity.sh
```

**Windows (PowerShell as Admin):**
```powershell
$action = New-ScheduledTaskAction -Execute "bash" -Argument "C:\path\to\project\.claude\scripts\continuity.sh"
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 30) -RepetitionDuration ([TimeSpan]::MaxValue)
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "ClaudeContinuity" -Description "Auto-runs Claude every 30 minutes"
```

### 3. Initialize with Claude

Open the project in Claude Code and use the `/bootstrap` command or say:

```
I want to build [describe your app]. You have complete autonomy to:
- Create your own agents, tools, and workflows
- Research and choose the tech stack
- Design the architecture and system
- Build, test, and iterate continuously

Read CLAUDE.md for your bootstrap protocol. The continuity script
runs every 30 minutes to keep you working. Start by reading
.claude/state/current.json and begin!
```

### 4. Monitor Progress

Use the `/monitor` command or watch the magic happen:
```bash
# Current status
cat .claude/state/current.json | jq .

# Execution log
tail -f .claude/state/execution.log

# History
tail -f .claude/state/history.jsonl
```

## 📁 Directory Structure

```
project-root/
├── CLAUDE.md                    # Claude Code instructions
├── README.md                    # This file
├── .claude/
│   ├── commands/               # Slash commands
│   │   ├── bootstrap.md
│   │   ├── continue.md
│   │   ├── create-agent.md
│   │   ├── monitor.md
│   │   └── quality-check.md
│   ├── subagents/             # Subagent configurations
│   │   └── continuity-manager.md
│   ├── skills/                # Reusable skills
│   ├── scripts/               # Core automation
│   │   ├── setup.sh
│   │   ├── continuity.sh
│   │   ├── spawn_agent.sh
│   │   ├── monitor.sh
│   │   └── run_quality_gates.sh
│   ├── docs/                  # Documentation
│   ├── state/                 # State files
│   │   ├── current.json
│   │   ├── agents.json
│   │   ├── history.jsonl
│   │   └── execution.log
│   ├── memory/                # Persistent memory
│   │   ├── architecture.md
│   │   ├── decisions.md
│   │   ├── learnings.md
│   │   └── best-practices.md
│   └── agents/                # Created agents (runtime)
└── src/                       # Application code
```

## 🤖 How It Works

### Continuity Loop

1. **Every 30 minutes**, `continuity.sh` runs
2. **Checks state** in `.claude/state/current.json`
3. **Verifies** no human intervention needed (`requiresHuman: false`)
4. **Executes Claude** with context from state file
5. **Claude reads state**, executes planned actions, updates state
6. **Plans next actions** before finishing
7. **Repeats** automatically

### Self-Evolution

Claude can create:
- **Agents**: Specialized workers (researcher, architect, quality_checker)
- **Skills**: Custom bash scripts and tools
- **Slash Commands**: Quick actions
- **Subagents**: Autonomous sub-processes
- **Quality Systems**: Automated testing and validation

### State Management

Everything is tracked in JSON:
- Current phase and cycle count
- Next actions queue (prioritized)
- Agent registry and status
- Blockers and health metrics
- Memory and learnings

## 🛠️ Slash Commands

- `/bootstrap` - Initialize the system and start first cycle
- `/continue` - Run a manual continuity check
- `/create-agent` - Interactive agent creation
- `/monitor` - Display real-time dashboard
- `/quality-check` - Run all quality gates

## 📝 Shell Commands

### Create an Agent
```bash
bash .claude/scripts/spawn_agent.sh quality_checker validator "Automated code review"
```

### Manual Continuity Check
```bash
bash .claude/scripts/continuity.sh
```

### Check Current State
```bash
cat .claude/state/current.json | jq '.nextActions'
```

### View Agent Registry
```bash
cat .claude/state/agents.json | jq .
```

## 🎛️ Configuration

### Adjust Frequency
Edit your cron job or scheduled task to change from 30 minutes to any interval.

### Pause Auto-Execution
Set `requiresHuman: true` in `.claude/state/current.json`

### Resume Auto-Execution
Set `requiresHuman: false` in `.claude/state/current.json`

## 📊 Monitoring

### Health Check
```bash
cat .claude/state/current.json | jq '.health'
```

### Recent Cycles
```bash
tail -20 .claude/state/history.jsonl | jq .
```

### Agent Status
```bash
cat .claude/state/current.json | jq '.agents'
```

### Metrics
```bash
cat .claude/state/current.json | jq '.metrics'
```

## 🚨 Troubleshooting

### Claude Stops Working
- Check `.claude/state/current.json` for `requiresHuman: true`
- Look at `blockers` array for details
- Review `.claude/state/execution.log` for errors

### Consecutive Failures
After 3 consecutive failures, the system auto-flags for human intervention. Check the logs and resolve issues before resuming.

### Cron Not Running
```bash
# Check cron is running (Linux/Mac)
crontab -l

# Check Task Scheduler (Windows)
Get-ScheduledTask -TaskName "ClaudeContinuity"
```

## 🛡️ Quality Enforcement System

### Research-Driven Development
Claude uses web search to research best practices for every technology decision:
```bash
# Example searches Claude will make:
- "React best practices 2025"
- "Node.js security checklist"
- "PostgreSQL performance optimization"
- "REST API design standards"
```

### Automated Quality Gates
Before any code is accepted:
1. **Linting**: Zero warnings allowed
2. **Type Safety**: Full type checking passes
3. **Tests**: >80% code coverage minimum
4. **Security Scan**: No vulnerabilities
5. **Code Review**: Automated review by quality_enforcer agent
6. **Performance**: Benchmarks meet requirements
7. **Documentation**: Complete and accurate

### Quality Agents
Claude creates these early:
- **quality_enforcer**: Validates all code against best practices
- **code_reviewer**: Automated code review with industry standards
- **security_scanner**: Checks for vulnerabilities
- **test_runner**: Ensures comprehensive test coverage
- **performance_monitor**: Tracks and validates performance

### Quality Metrics Tracked
```json
{
  "qualityScore": 98,      // Must stay >95
  "testCoverage": 87,      // Must be >80%
  "linterPasses": 145,
  "securityScans": 23,
  "bestPracticeViolations": 0
}
```

### Continuous Improvement
Every cycle:
1. Run all quality gates
2. Search for improvements: "better way to [what was just done]"
3. Update quality standards
4. Refactor if needed
5. Document learnings

## 🎨 Example Use Cases

### 1. Full-Stack Web App
```
"Build a task management app with real-time collaboration,
user authentication, and AI-powered task suggestions"
```

### 2. API Service
```
"Create a REST API for a social media platform with posts,
comments, likes, and recommendation engine"
```

### 3. Data Pipeline
```
"Build an ETL pipeline that ingests data from multiple sources,
transforms it, and loads into a data warehouse"
```

## 🔒 Safety Features

- **Requires Human Flag**: Stops auto-execution when intervention needed
- **Failure Detection**: Auto-pauses after 3 consecutive failures
- **State Persistence**: All progress saved between runs
- **Audit Log**: Complete history in `history.jsonl`

## 📝 Key Principles

1. **Autonomy**: Claude decides architecture, tools, and approach
2. **Continuity**: Always plans next actions before finishing
3. **Quality**: Creates own validation and testing systems
4. **Memory**: Documents decisions and learnings
5. **Self-Healing**: Creates helper agents when stuck

## 🤝 Contributing

This is Claude's autonomous workspace. It will create its own agents, tools, and workflows. Human intervention should be minimal and only when `requiresHuman: true`.

## 📄 License

Configure as needed for your project.

---

**Ready to let Claude build autonomously? Run `.claude/scripts/setup.sh` and provide your requirements!**
