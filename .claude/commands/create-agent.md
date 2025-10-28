# Create Agent Command

Interactively create a new specialized agent to help with specific tasks.

## Instructions

Create a new specialized agent to handle a specific responsibility in the system.

### Agent Creation Process

1. **Determine Need**: What specific problem or task needs a dedicated agent?
   - Quality enforcement
   - Research and analysis
   - Code review
   - Testing and validation
   - Architecture design
   - Performance monitoring
   - Security scanning
   - State management

2. **Gather Information**: Ask the user (or decide autonomously):
   - Agent name (e.g., "quality_enforcer", "code_reviewer")
   - Agent type (e.g., "validator", "analyzer", "builder")
   - Agent purpose (clear, specific description)

3. **Create Agent**: Use the spawn script:
   ```bash
   bash .claude/scripts/spawn_agent.sh <name> <type> <purpose>
   ```

4. **Configure Agent**:
   - Edit `.claude/agents/<name>/README.md` with capabilities
   - Add skills to `.claude/agents/<name>/skills/`
   - Configure settings in `.claude/agents/<name>/config/agent.json`

5. **Update Registry**: Ensure agent is registered in:
   - `.claude/state/agents.json`
   - `.claude/state/current.json` agents section

6. **Test Agent**: Verify agent can perform its intended function

### Agent Best Practices

**Good Agent Purposes:**
- "Validates all code against industry best practices and quality standards"
- "Researches and documents best practices for new technologies"
- "Reviews code for security vulnerabilities and common mistakes"
- "Manages state file updates and ensures continuity"

**Bad Agent Purposes:**
- "Does various things" (too vague)
- "Helps out" (not specific)
- "Handles stuff" (unclear responsibility)

### Common Agents to Create

Early in the project, consider creating:

1. **quality_enforcer** - Validates code meets quality standards (>95 score)
2. **researcher** - Researches best practices and technology decisions
3. **architect** - Designs system architecture and structure
4. **code_reviewer** - Performs automated code reviews
5. **test_runner** - Manages testing and coverage requirements

### After Creation

- Document the agent in `.claude/memory/decisions.md`
- Plan tasks for the new agent in `nextActions`
- Update metrics: increment `agentsCreated` count
- Consider if agent needs any skills or custom tools

### Integration

Agents work within the continuity system:
- They can be assigned tasks in `nextActions`
- They update their own logs in `.claude/agents/<name>/logs/`
- They contribute to overall system metrics
- They follow the same quality standards

Create agents proactively when you identify repeated tasks or specialized needs!
