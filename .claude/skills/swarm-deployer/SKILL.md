---
name: swarm-deployer
description: This skill should be used when Claude needs to deploy multiple lightweight Haiku-powered agents in parallel for focused tasks like security scanning, code review, data gathering, or parallel research across many files.
---

# Swarm Deployer

This skill provides functionality for deploying and managing swarm agents - lightweight, parallel Haiku-powered subagents for focused tasks.

## Purpose

The swarm-deployer skill enables deployment of multiple Haiku agents running concurrently to handle tasks that benefit from parallelization. Each swarm agent is specialized, cost-effective (Haiku model), and designed for focused work.

## When to Use This Skill

Use this skill when:
- Need to process many files in parallel (security scan 50+ files)
- Code review across multiple small files simultaneously
- Data gathering from multiple sources concurrently
- Parallel research tasks
- Any task that can be divided into independent subtasks
- Need fast, cost-effective parallel processing

**Do NOT use when:**
- Task requires deep reasoning (use full Claude Sonnet instead)
- Task requires continuity across results (use single agent)
- Only processing 1-3 files (not worth parallelization overhead)

## Usage

Execute the swarm-deployer script from the project root:

```bash
bash .claude/skills/swarm-deployer/scripts/swarm-deployer.sh <command> [args]
```

### Available Commands

#### `list`
Display all available swarm templates with their purposes and capabilities.

**Example:**
```bash
bash .claude/skills/swarm-deployer/scripts/swarm-deployer.sh list
```

**Output shows:**
- Template name
- Purpose description
- Typical use cases

#### `plan <template-name> <target-pattern>`
Plan a swarm deployment by showing what files would be processed without actually deploying.

**Arguments:**
- `template-name`: Name of swarm template to use
- `target-pattern`: Glob pattern for files to process (e.g., "src/**/*.js")

**Example:**
```bash
bash .claude/skills/swarm-deployer/scripts/swarm-deployer.sh plan security-scanner "src/**/*.js"
```

**Output shows:**
- Number of agents that would be deployed
- List of files each agent would process
- Estimated cost and time

#### `deploy <template-name> <target-pattern>`
Deploy swarm agents to process files matching the pattern.

**Arguments:**
- `template-name`: Name of swarm template to use
- `target-pattern`: Glob pattern for files to process

**Example:**
```bash
bash .claude/skills/swarm-deployer/scripts/swarm-deployer.sh deploy security-scanner "src/**/*.js"
```

**Process:**
1. Identifies files matching pattern
2. Divides files among agents (typically 5-10 files per agent)
3. Spawns Haiku agents in parallel
4. Collects results as agents complete
5. Aggregates results into summary report

#### `history`
Show history of previous swarm deployments with results.

**Example:**
```bash
bash .claude/skills/swarm-deployer/scripts/swarm-deployer.sh history
```

**Output shows:**
- Deployment timestamp
- Template used
- Number of agents deployed
- Number of files processed
- Summary of findings

## Swarm Templates

Templates are defined in `.claude/subagents/swarm/` directory. Each template is a markdown file defining:
- **Purpose**: What the swarm does
- **Task Description**: Instructions for each agent
- **Output Format**: Expected result structure
- **Model**: Haiku (lightweight, cost-effective)

### Common Templates

**security-scanner**: Scan files for security vulnerabilities
**code-reviewer**: Review code quality and best practices
**documentation-checker**: Verify documentation completeness
**test-coverage-analyzer**: Analyze test coverage gaps
**dependency-auditor**: Check dependency versions and vulnerabilities

## Results Storage

Swarm results are stored in `.claude/state/swarm-results/`:
```
.claude/state/swarm-results/
├── <timestamp>-<template-name>/
│   ├── summary.json          # Aggregated results
│   ├── agent-001.json        # Individual agent results
│   ├── agent-002.json
│   └── ...
```

## Best Practices

### When to Use Swarms

**Good use cases:**
- Security scanning 50 JavaScript files
- Reviewing 30 small component files
- Gathering data from 20 API endpoints
- Analyzing 40 test files for patterns

**Bad use cases:**
- Processing 3 files (use single agent)
- Complex refactoring requiring coordination (use Sonnet)
- Tasks requiring shared state (use single agent)

### Optimization Tips

1. **Batch size**: 5-10 files per agent is optimal
2. **Pattern specificity**: Use precise globs to avoid processing unnecessary files
3. **Template selection**: Choose the right template for your task
4. **Result review**: Always review aggregated results, don't just trust automation
5. **Cost awareness**: Swarms are cheap but not free - plan deployments

### Creating Custom Templates

To create a new swarm template:

1. Create file in `.claude/subagents/swarm/<template-name>.md`
2. Define purpose and task clearly
3. Specify output format for aggregation
4. Test with small file set first
5. Document in template list

**Template structure:**
```markdown
**Purpose**: [One sentence describing what this swarm does]

**Model**: claude-3-haiku-20250319

**Task**: [Clear instructions for each agent]

**Output Format**: [JSON structure expected]
```

## Integration with System

The swarm-deployer integrates with:
- The /swarm slash command (easy manual deployment)
- Continuity cycles (can deploy swarms for automated tasks)
- Quality validation (can run parallel quality checks)
- Security monitoring (parallel vulnerability scanning)

## Performance Characteristics

**Speed:** 10-20x faster than sequential processing (depending on file count)
**Cost:** ~90% cheaper than using Sonnet for same tasks
**Accuracy:** Suitable for focused tasks; use Sonnet for complex reasoning
**Concurrency:** Typically 5-15 agents running simultaneously

## Troubleshooting

### No results returned
Solution: Check agent logs in results directory, verify template is correct

### Timeout errors
Solution: Reduce batch size (fewer files per agent)

### Inconsistent results
Solution: Task may be too complex for Haiku - use Sonnet instead

### High cost
Solution: Review target pattern - may be processing too many files
