# 🚀 Quick Start Guide - Self-Evolving Claude Project

Get Claude building autonomously with **industry-leading code quality** in 5 minutes!

## 🎯 What Makes This Special

- **Quality-First**: Claude researches best practices BEFORE coding
- **Internet Access**: Uses web search to find industry standards
- **Self-Validating**: Creates its own quality enforcement systems
- **Autonomous**: Runs continuously every 30 minutes
- **Zero Tolerance**: No code ships without passing ALL quality gates

## Prerequisites

- Claude Code installed
- Bash shell (Git Bash on Windows, native on Mac/Linux)
- `jq` installed (for JSON parsing)
  - Mac: `brew install jq`
  - Linux: `apt-get install jq` or `yum install jq`
  - Windows: Download from https://stedolan.github.io/jq/

## Step 1: Create Project Directory

```bash
mkdir my-autonomous-app
cd my-autonomous-app
```

## Step 2: Save All Artifacts

Save these files from Claude to your project:

1. **setup.sh** → `./setup.sh`
2. **CLAUDE.md** → `./CLAUDE.md` 
3. **current.json** → `./.claude/state/current.json`
4. **agents.json** → `./.claude/state/agents.json`
5. **continuity.sh** → `./.claude/scripts/continuity.sh`
6. **spawn_agent.sh** → `./.claude/scripts/spawn_agent.sh`
7. **monitor.sh** → `./monitor.sh`
8. **README.md** → `./README.md`

Or simply run the setup script which will create everything:

```bash
bash setup.sh
```

## Step 3: Make Scripts Executable

```bash
chmod +x setup.sh
chmod +x monitor.sh
chmod +x .claude/scripts/*.sh
```

## Step 4: Set Up Auto-Execution (Choose One)

### Option A: Linux/Mac (Cron)

```bash
crontab -e
```

Add this line (replace `/path/to/project`):
```
*/30 * * * * cd /path/to/project && bash .claude/scripts/continuity.sh
```

### Option B: Windows (Task Scheduler)

Open PowerShell as Administrator:

```powershell
$projectPath = "C:\path\to\project"
$action = New-ScheduledTaskAction -Execute "bash.exe" -Argument "$projectPath\.claude\scripts\continuity.sh" -WorkingDirectory $projectPath
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 30) -RepetitionDuration ([TimeSpan]::MaxValue)
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "ClaudeContinuity" -Description "Autonomous Claude execution every 30 mins"
```

Verify it's registered:
```powershell
Get-ScheduledTask -TaskName "ClaudeContinuity"
```

### Option C: Manual (For Testing)

Run manually instead of auto:
```bash
bash .claude/scripts/continuity.sh
```

## Step 5: Start Claude

Open the project in Claude Code:

```bash
claude-code .
```

Then give Claude this prompt:

```
You are now an autonomous, self-evolving development system. 

Read CLAUDE.md and .claude/state/current.json to understand your mission.

I want you to build: [DESCRIBE YOUR APP HERE]

Requirements:
- [LIST REQUIREMENTS]
- [BE SPECIFIC]

You have complete autonomy to:
- Create agents, tools, and workflows
- Choose tech stack and architecture
- Organize your own development process
- Build quality assurance systems

Your continuity script runs every 30 minutes automatically.

Begin by:
1. Reading your bootstrap protocol
2. Breaking down requirements
3. Creating initial agents (researcher, architect, quality_checker)
4. Planning your approach

Start now!
```

## Step 6: Monitor Progress

### Watch Live Dashboard

```bash
bash monitor.sh --watch
```

### Check State Anytime

```bash
cat .claude/state/current.json | jq .
```

### View Execution Log

```bash
tail -f .claude/state/execution.log
```

### See History

```bash
tail -f .claude/state/history.jsonl
```

## Example Apps to Build

### 1. Simple Todo App
```
Build a todo list application with:
- User authentication (email/password)
- Create, edit, delete tasks
- Task categories and priorities
- Due dates with reminders
- Mobile-responsive design
- Dark mode support
```

### 2. Collaborative Whiteboard
```
Build a real-time collaborative whiteboard with:
- Drawing tools (pen, shapes, text)
- Multi-user collaboration with live cursors
- Chat functionality
- Save/load boards
- Export to PNG/PDF
- Mobile touch support
```

### 3. E-commerce Platform
```
Build an e-commerce platform with:
- Product catalog with categories
- Shopping cart and checkout
- Payment processing (Stripe)
- Order management
- Admin dashboard
- Email notifications
- Search and filtering
```

## Troubleshooting

### "claude-code: command not found"

Install Claude Code:
```bash
# Follow installation instructions at https://docs.claude.com
```

### "jq: command not found"

Install jq:
```bash
# Mac
brew install jq

# Linux (Debian/Ubuntu)
sudo apt-get install jq

# Linux (RHEL/CentOS)
sudo yum install jq

# Windows
# Download from https://stedolan.github.io/jq/download/
```

### Cron Job Not Running

Check it's registered:
```bash
crontab -l
```

Check cron logs:
```bash
# Mac
tail -f /var/log/system.log | grep cron

# Linux
tail -f /var/log/syslog | grep CRON
```

### Claude Paused (requiresHuman: true)

Check why:
```bash
cat .claude/state/current.json | jq '.blockers'
```

Resolve the issue, then resume:
```bash
# Edit current.json and set:
"requiresHuman": false
```

### Want to Reset?

```bash
# Backup first
cp -r .claude .claude.backup

# Reset state
bash setup.sh

# Or manually:
rm -rf .claude
bash setup.sh
```

## What Happens Next?

1. **Cycle 0-5**: Claude creates agents, analyzes requirements
2. **Cycle 5-10**: Researches tech stack, designs architecture
3. **Cycle 10-20**: Sets up project structure, creates framework
4. **Cycle 20-50**: Builds core features iteratively
5. **Cycle 50+**: Tests, refines, adds features, improves quality

Claude will:
- ✅ Create specialized agents as needed
- ✅ Build its own tooling and workflows
- ✅ Test and validate continuously
- ✅ Document all decisions
- ✅ Self-heal when stuck
- ✅ Never stop until complete

## Monitoring Tips

### Check Every Few Hours
```bash
bash monitor.sh
```

### Watch Agents Grow
```bash
ls -la .claude/agents/
```

### Read Decisions
```bash
cat .claude/memory/decisions.md
cat .claude/memory/architecture.md
```

### Verify Continuity
```bash
# Should show recent runs
tail -20 .claude/state/history.jsonl
```

## When to Intervene

Only intervene when:
- ❌ `requiresHuman: true` in state
- ❌ 3+ consecutive failures
- ❌ Need to approve major decisions
- ❌ Need to provide credentials

Otherwise, **let Claude work!**

## Advanced: Adjust Frequency

### Change to Every 15 Minutes

**Cron:**
```
*/15 * * * * cd /path/to/project && bash .claude/scripts/continuity.sh
```

**Windows:**
```powershell
# Delete old task
Unregister-ScheduledTask -TaskName "ClaudeContinuity" -Confirm:$false

# Create new with 15 min interval
$action = New-ScheduledTaskAction -Execute "bash.exe" -Argument "C:\path\to\project\.claude\scripts\continuity.sh"
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 15) -RepetitionDuration ([TimeSpan]::MaxValue)
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "ClaudeContinuity"
```

### Change to Every Hour

Change `*/30` to `0 * * * *` (on the hour)

---

## 🎉 You're Done!

Claude is now autonomously building your app!

**Dashboard:**
```bash
bash monitor.sh --watch
```

**Check Anytime:**
```bash
cat .claude/state/current.json | jq .
```

**Let it run and watch the magic happen!** ✨