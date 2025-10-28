# Swarm Agents with Haiku

## Overview

For small, focused tasks, use **Haiku-powered swarm agents** - lightweight, fast, and cost-effective subagents that can be deployed in parallel.

## When to Use Haiku Swarms

✅ **Good for:**
- File analysis across multiple files
- Running repetitive checks/validations
- Gathering data from multiple sources
- Parallel research tasks
- Code review of many small files
- Documentation generation
- Simple refactoring tasks

❌ **Not good for:**
- Complex reasoning or planning
- Large context requirements
- Tasks requiring deep architecture decisions
- Writing substantial new features

## Model Comparison

| Model | Use Case | Speed | Cost | Context |
|-------|----------|-------|------|---------|
| **Haiku** | Small focused tasks | Very fast | Very low | 200k |
| **Sonnet** | Complex tasks, planning | Medium | Medium | 200k |
| **Opus** | Deep reasoning, architecture | Slower | Higher | 200k |

## Swarm Agent Pattern

### 1. Identify Parallelizable Work

Break down tasks into independent units:
```
Task: "Review all 50 API endpoint files for security issues"

Swarm approach:
- Deploy 50 Haiku agents (one per file)
- Each checks: input validation, auth, error handling
- Aggregate results
- Generate summary report
```

### 2. Create Lightweight Subagent

In `.claude/subagents/`, create focused, single-purpose agents:

```markdown
# Security Scanner (Haiku)

**Model**: Haiku
**Purpose**: Check single file for security issues
**Scope**: Focused, < 1000 lines of code

## Instructions

Review the provided file for:
1. SQL injection vulnerabilities
2. XSS vulnerabilities
3. Authentication/authorization issues
4. Input validation
5. Error handling that leaks info

Return JSON:
{
  "file": "filename",
  "issues": [
    {"severity": "high|medium|low", "type": "...", "line": N, "description": "..."}
  ],
  "score": 0-100
}
```

### 3. Deploy in Parallel

Use Task tool to launch multiple agents simultaneously:

```
I need to review these 20 files for security issues:
[file list]

Please deploy 20 Haiku security-scanner subagents in parallel,
one for each file. Once all complete, aggregate results.
```

### 4. Aggregate Results

Collect responses and synthesize:
- Count total issues by severity
- Identify patterns across files
- Prioritize fixes
- Generate actionable report

## Swarm Agent Templates

### Template: File Analyzer
```markdown
# [Name] Analyzer (Haiku)

**Model**: Haiku
**Input**: Single file path
**Output**: Structured analysis

## Task
Analyze the file for [specific aspect].

## Output Format
{
  "file": "path",
  "metrics": {...},
  "issues": [...],
  "recommendations": [...]
}
```

### Template: Data Gatherer
```markdown
# [Name] Gatherer (Haiku)

**Model**: Haiku
**Input**: URL or resource identifier
**Output**: Extracted data

## Task
Fetch and extract [specific data] from [source].

## Output Format
{
  "source": "...",
  "data": {...},
  "timestamp": "..."
}
```

### Template: Validator
```markdown
# [Name] Validator (Haiku)

**Model**: Haiku
**Input**: Code snippet or config
**Output**: Pass/fail + issues

## Task
Validate [item] against [criteria].

## Output Format
{
  "valid": true|false,
  "issues": [...],
  "score": 0-100
}
```

## Example Use Cases

### 1. Comprehensive Code Review
```
Deploy swarm:
- 10 Haiku agents for security review (one per file)
- 10 Haiku agents for code quality (one per file)
- 10 Haiku agents for test coverage (one per file)
= 30 agents running in parallel
```

### 2. Documentation Generation
```
Deploy swarm:
- 1 Haiku agent per module to generate API docs
- Aggregate into comprehensive documentation
```

### 3. Dependency Analysis
```
Deploy swarm:
- 1 Haiku agent per package.json to check vulnerabilities
- 1 Haiku agent per package to find updates
- Aggregate security report + update recommendations
```

### 4. Multi-Source Research
```
Deploy swarm:
- 5 Haiku agents to search different best practice sources
- Each returns top 5 recommendations
- Aggregate and deduplicate findings
```

## Best Practices

### 1. Keep Tasks Atomic
- Each Haiku agent should have ONE clear task
- Input should be self-contained
- Output should be structured (JSON preferred)

### 2. Design for Aggregation
- Consistent output format across agents
- Include metadata (timestamp, source, etc.)
- Make results easy to combine

### 3. Error Handling
- Agents should return errors in structured format
- Don't fail entire swarm if one agent fails
- Retry failed agents individually

### 4. Resource Management
- Don't deploy 1000s of agents at once
- Batch in groups of 10-50
- Monitor token usage

### 5. Use Appropriate Model
```
Haiku:   Simple, fast, parallel tasks
Sonnet:  Default for most work
Opus:    Complex reasoning, architecture
```

## Swarm Orchestration Pattern

```markdown
### Phase 1: Planning (Sonnet)
- Identify task
- Break into atomic units
- Design swarm strategy

### Phase 2: Deployment (Haiku Swarm)
- Launch N agents in parallel
- Each processes one unit
- Each returns structured result

### Phase 3: Aggregation (Sonnet)
- Collect all results
- Synthesize findings
- Generate report
- Plan next actions
```

## Example: Swarm Security Audit

```
Task: Audit 30 API endpoints for security

Step 1 (Sonnet):
- List all endpoint files
- Create security checklist
- Design output schema

Step 2 (30x Haiku):
- Deploy 30 agents
- Each reviews 1 endpoint
- Each returns security report

Step 3 (Sonnet):
- Aggregate 30 reports
- Count issues by severity
- Prioritize fixes
- Update state with next actions
```

## Cost & Performance Benefits

### Speed
- Serial (1 Sonnet): 30 files × 10s = 5 minutes
- Parallel (30 Haiku): 30 files / 30 agents = 10 seconds

### Cost
- 30 Haiku agents often < 1 Sonnet call
- Massively parallel for fraction of cost

### Quality
- Focused agents = higher accuracy on specific tasks
- Parallel = no context bleeding between tasks
- Aggregation = pattern detection across results

## Integration with Continuity System

Add to `.claude/state/current.json`:
```json
{
  "nextActions": [
    {
      "id": "swarm-001",
      "type": "swarm_deployment",
      "priority": "high",
      "action": "Deploy Haiku swarm to review 50 files for security issues",
      "swarm": {
        "agentType": "security-scanner",
        "count": 50,
        "model": "haiku",
        "aggregation": "security-report"
      }
    }
  ]
}
```

## Creating Swarm Subagents

Store in `.claude/subagents/swarm/`:
```
.claude/subagents/swarm/
├── security-scanner.md    (Haiku)
├── code-reviewer.md       (Haiku)
├── doc-generator.md       (Haiku)
├── test-analyzer.md       (Haiku)
└── dependency-checker.md  (Haiku)
```

Each should be:
- Single-purpose
- Fast to execute
- Structured output
- Model: Haiku specified

---

**Remember**: Swarm agents are a force multiplier. Use them for parallel, focused work. Use Sonnet/Opus for orchestration and complex reasoning.
