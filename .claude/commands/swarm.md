# Swarm Command

Deploy parallel Haiku-powered swarm agents for focused, high-speed task execution.

## Instructions

You are deploying a **swarm of Haiku agents** to execute parallel tasks efficiently.

### Swarm Deployment Process

**Step 1: Analyze the Task**
- Identify if the task can be parallelized
- Break down into atomic, independent units
- Determine appropriate swarm size (typically 10-50 agents)

**Step 2: Design Swarm Strategy**
- Choose swarm agent type (or create new one)
- Define input for each agent
- Design output schema for aggregation

**Step 3: Deploy Swarm**
Use the Task tool to launch multiple Haiku agents in parallel:

```
Deploy [N] Haiku agents to [task description].

Agent type: [security-scanner | code-reviewer | doc-generator | custom]
Model: Haiku
Inputs: [list of inputs, one per agent]
Output format: [structured format for aggregation]

Example:
- Agent 1: Review file1.js for security issues
- Agent 2: Review file2.js for security issues
- ...
- Agent N: Review fileN.js for security issues
```

**Step 4: Aggregate Results**
Once all agents complete:
- Collect structured outputs
- Identify patterns and trends
- Calculate aggregate metrics
- Generate summary report
- Plan next actions based on findings

### Common Swarm Patterns

**Security Audit Swarm**
```
Task: Audit 30 API endpoints
Swarm size: 30 agents (1 per endpoint)
Agent type: security-scanner
Output: Security issues by severity
Aggregation: Total issues, prioritized fix list
```

**Code Review Swarm**
```
Task: Review 50 files for code quality
Swarm size: 50 agents (1 per file)
Agent type: code-reviewer
Output: Quality score + issues
Aggregation: Average score, common issues
```

**Documentation Swarm**
```
Task: Generate docs for 20 modules
Swarm size: 20 agents (1 per module)
Agent type: doc-generator
Output: Markdown documentation
Aggregation: Combined docs, cross-references
```

**Research Swarm**
```
Task: Research best practices from 10 sources
Swarm size: 10 agents (1 per source)
Agent type: research-gatherer
Output: Key findings + recommendations
Aggregation: Deduplicated best practices list
```

### Swarm Agent Templates

Use these or create custom ones in `.claude/subagents/swarm/`:

**Available Templates:**
- `security-scanner` - Check file for security issues
- `code-reviewer` - Analyze code quality
- `doc-generator` - Generate documentation
- `test-analyzer` - Analyze test coverage
- `dependency-checker` - Check dependencies

**Custom Template Example:**
```markdown
# Custom Swarm Agent (Haiku)

**Model**: Haiku
**Purpose**: [Single focused task]
**Input**: [What each agent receives]
**Output**: [Structured format]

## Instructions
[Clear, focused instructions for single task]

## Output Format
{
  "input": "...",
  "result": {...},
  "metadata": {...}
}
```

### Deployment Options

**Option 1: Quick Swarm** (using existing template)
```
Use the swarm skill:
bash .claude/skills/swarm-deployer/scripts/swarm-deployer.sh deploy security-scanner "src/**/*.js"
```

**Option 2: Custom Swarm** (ad-hoc)
```
I need to deploy a swarm to [task].

Create [N] Haiku agents that each [specific task].
Inputs: [list]
Expected output: [format]
```

**Option 3: Planned Swarm** (from state file)
```
Execute swarm action from state file:
Action ID: swarm-001
Type: security-scanner
Count: 30
Inputs: [from file list]
```

### Best Practices

1. **Keep Agents Focused**
   - One task per agent
   - Self-contained input
   - Structured output

2. **Batch Appropriately**
   - Don't deploy 1000s at once
   - Group in batches of 10-50
   - Monitor resources

3. **Design for Aggregation**
   - Consistent output format
   - Include metadata
   - Easy to combine

4. **Handle Errors Gracefully**
   - Don't fail entire swarm for one failure
   - Collect partial results
   - Retry failed agents individually

5. **Choose Right Model**
   - Haiku: Simple, fast, parallel
   - Sonnet: Orchestration, aggregation
   - Don't use Opus for swarm agents

### After Swarm Completes

1. **Aggregate Results**
   - Combine all outputs
   - Calculate metrics
   - Identify patterns

2. **Generate Report**
   - Summary statistics
   - Key findings
   - Prioritized actions

3. **Update State**
   - Mark swarm action as completed
   - Add next actions based on findings
   - Update quality metrics if applicable

4. **Document Findings**
   - Save report to appropriate location
   - Update memory files if patterns discovered
   - Log decision if new approach validated

### Example Invocations

**Security Audit:**
```
Deploy security audit swarm across src/ directory.
Use security-scanner template.
Check for: SQL injection, XSS, auth issues.
Generate prioritized fix list.
```

**Code Quality:**
```
Deploy code review swarm for all files in PR #123.
Use code-reviewer template.
Focus on: complexity, duplication, best practices.
Calculate average quality score.
```

**Documentation:**
```
Deploy doc generation swarm for all modules.
Use doc-generator template.
Format: JSDoc/TSDoc.
Combine into API documentation.
```

### Performance Expectations

- **Serial (1 Sonnet)**: N tasks × 10s each
- **Swarm (N Haiku)**: ~10-30 seconds total
- **Cost**: Often less than 1 Sonnet call
- **Quality**: High accuracy on focused tasks

### Integration

Add swarm actions to state:
```json
{
  "nextActions": [
    {
      "id": "swarm-001",
      "type": "swarm_deployment",
      "priority": "high",
      "action": "Deploy security swarm to audit all API endpoints",
      "swarm": {
        "template": "security-scanner",
        "count": 30,
        "model": "haiku",
        "inputs": ["file1.js", "file2.js", ...],
        "aggregation": "security-report"
      }
    }
  ]
}
```

---

**Remember**: Swarms are a force multiplier. Use them for parallel, focused work. 30 tasks in 30 seconds instead of 30 minutes!

For detailed patterns and templates, see `.claude/docs/swarm-agents.md`
