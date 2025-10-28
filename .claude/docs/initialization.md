# Claude Initialization Prompt

Use this prompt when starting Claude on this project for the first time.

## Initial Prompt to Claude

```
You are now initializing as an autonomous, self-evolving development system.

🚨 CRITICAL PRIORITY: CODE QUALITY & BEST PRACTICES 🚨

You have internet access. Use it to research and enforce industry best practices.
Quality is NON-NEGOTIABLE. Every line of code must meet the highest standards.

MANDATORY READING:
1. Read CLAUDE.md for your bootstrap protocol
2. Read .claude/quality_framework.md for quality requirements
3. Read .claude/state/current.json for your current state

YOU WILL:
- Research best practices BEFORE writing any code
- Create rigorous quality validation systems
- Block any code that doesn't meet standards
- Continuously improve quality enforcement

YOUR MISSION:
Build [APP DESCRIPTION HERE] with these requirements:
[LIST REQUIREMENTS HERE]

CORE PRINCIPLES:
- **Quality First**: Research and implement best practices BEFORE coding
- **Internet Access**: Use web_search aggressively to find industry standards
- **Zero Tolerance**: No code ships without passing ALL quality gates
- **Self-Validation**: Create tools to verify your own code quality
- **Never stop**: Always update state with next actions before finishing
- **Document everything**: Keep .claude/memory/ updated with decisions

QUALITY REQUIREMENTS (READ .claude/quality_framework.md):
1. Research best practices for every technology choice
2. Create quality_enforcer agent as priority #1
3. Implement linting, testing, security scanning
4. No code proceeds without >80% test coverage
5. All code must pass automated review
6. Track quality metrics in every cycle
7. If quality drops, STOP and fix immediately

BOOTSTRAP SEQUENCE:
1. Read current state from .claude/state/current.json
2. Read quality framework from .claude/quality_framework.md
3. Analyze app requirements and break into phases
4. **IMMEDIATELY research best practices** for potential tech stacks using web_search
5. Create initial agents in this order:
   - quality_enforcer agent (FIRST - validates everything)
   - researcher agent (tech stack analysis with best practice focus)
   - architect agent (system design following best practices)
6. Document best practices in .claude/memory/best-practices.md
7. Set up quality gates (linting, testing, security)
8. Begin requirement breakdown with quality validation
9. Update state with completed actions and plan next cycle

AUTONOMY GRANTED:
- Create any agents, tools, skills, or workflows you need
- Modify your own structure as you learn
- Build custom development frameworks
- Design your own quality assurance processes
- Organize work in the way that makes most sense

Remember: Your continuity script runs every 30 minutes. Each session:
1. Read .claude/state/current.json for context
2. Execute next planned actions
3. Update state with progress
4. Plan future actions
5. Only set requiresHuman:true if truly blocked

You can use:
- bash .claude/scripts/spawn_agent.sh <n> <type> <purpose>
- Any custom tools you create
- Chrome DevTools MCP (already configured)

BEGIN: Read your state file and start building!
```

## Example Requirements Format

### Simple App
```
Build a todo list app with:
- User authentication
- Create, read, update, delete tasks
- Task categories and priorities
- Due dates and reminders
- Mobile-responsive design
```

### Complex App
```
Build a collaborative project management platform with:

CORE FEATURES:
- Multi-user workspaces with role-based permissions
- Real-time collaboration (live cursors, presence)
- Project boards (Kanban, Gantt, Calendar views)
- Task management with dependencies and time tracking
- File attachments and version control
- Comments and @mentions
- Activity feeds and notifications

TECHNICAL REQUIREMENTS:
- Must scale to 10,000+ concurrent users
- Real-time updates with <100ms latency
- Mobile apps (iOS/Android) and web
- API for third-party integrations
- Advanced search and filtering
- Data export capabilities

QUALITY REQUIREMENTS:
- 99.9% uptime SLA
- Comprehensive test coverage (>80%)
- Security audit passing
- Performance benchmarks met
- Accessibility (WCAG 2.1 AA)
```

## What Claude Will Do

After receiving the prompt, Claude will:

1. **Read bootstrap files** (CLAUDE.md, current.json)
2. **Analyze requirements** and create initial breakdown
3. **Spawn first agents**:
   ```bash
   bash .claude/scripts/spawn_agent.sh researcher analyst "Research and recommend tech stack"
   bash .claude/scripts/spawn_agent.sh architect designer "Design system architecture"
   bash .claude/scripts/spawn_agent.sh quality_checker validator "Validate code and test"
   ```
4. **Update state** with phases and next actions
5. **Begin research phase** to determine tech stack
6. **Continue autonomously** every 30 minutes

## Monitoring Claude's Progress

### Check Current Phase
```bash
cat .claude/state/current.json | jq '.currentPhase'
```

### See Next Actions
```bash
cat .claude/state/current.json | jq '.nextActions'
```

### View Created Agents
```bash
ls -la .claude/agents/
cat .claude/state/agents.json | jq .
```

### Watch Execution Log
```bash
tail -f .claude/state/execution.log
```

### Review Decisions
```bash
cat .claude/memory/decisions.md
cat .claude/memory/architecture.md
```

## When to Intervene

Claude will set `requiresHuman: true` when:
- Major architectural decisions need approval
- 3+ consecutive execution failures
- Ambiguous requirements need clarification
- External credentials/access needed
- Deployment decisions required

Check blockers:
```bash
cat .claude/state/current.json | jq '.blockers'
```

## Tips for Success

1. **Be specific with requirements** - More detail = better results
2. **Let Claude decide tech** - It will research and choose wisely
3. **Monitor periodically** - Check state file every few hours
4. **Trust the process** - Claude will create what it needs
5. **Intervene minimally** - Only when requiresHuman is true

## Advanced: Providing Constraints

If you want to guide Claude without removing autonomy:

```
Build [APP] with these requirements:
[REQUIREMENTS]

CONSTRAINTS (guide, not mandate):
- Prefer modern, well-supported technologies
- Prioritize developer experience and maintainability
- Consider hosting on [platform] but research alternatives
- Budget: $X/month for infrastructure
- Timeline: MVP in X weeks

You have freedom to deviate from constraints if you find better approaches.
Document reasoning in .claude/memory/decisions.md
```

This gives Claude direction while maintaining autonomy to make better choices.