---
name: agent-spawner
description: This skill should be used when Claude needs to create new specialized agents with proper validation and templates. It provides interactive agent creation, listing, and information retrieval for agents in the system.
---

# Agent Spawner

This skill provides functionality for creating and managing specialized agents in the infinity-claude system.

## Purpose

The agent-spawner skill enables creation of new specialized agents with proper structure, validation, and templates. It ensures agents follow naming conventions and directory structure requirements.

## When to Use This Skill

Use this skill when:
- Creating a new specialized agent for a specific task or domain
- Listing existing agents in the system
- Getting information about a specific agent
- Need to spawn agents with proper validation and structure

## Usage

Execute the agent-spawner script from the project root:

```bash
bash .claude/skills/agent-spawner/scripts/agent-spawner.sh <command>
```

### Available Commands

#### `interactive`
Launch interactive agent creation wizard that prompts for:
- Agent name (lowercase, alphanumeric with hyphens/underscores)
- Agent type (e.g., validator, analyzer, builder)
- Agent description
- Primary capabilities
- Tool access requirements

**Example:**
```bash
bash .claude/skills/agent-spawner/scripts/agent-spawner.sh interactive
```

#### `list`
Display all existing agents with their descriptions and capabilities.

**Example:**
```bash
bash .claude/skills/agent-spawner/scripts/agent-spawner.sh list
```

#### `info <agent-name>`
Show detailed information about a specific agent including its configuration.

**Example:**
```bash
bash .claude/skills/agent-spawner/scripts/agent-spawner.sh info quality-enforcer
```

## Agent Structure

Created agents follow this structure:
```
.claude/agents/<agent-name>/
├── agent.md          # Agent configuration and instructions
└── README.md         # Agent documentation
```

## Validation Rules

Agent names must:
- Start with a lowercase letter
- Contain only lowercase letters, numbers, hyphens, and underscores
- Be unique (not already exist)

## Best Practices

1. **Use descriptive names**: Choose agent names that clearly indicate their purpose
2. **Define clear scope**: Specify precise capabilities and boundaries for the agent
3. **Document properly**: Provide comprehensive description and usage examples
4. **List required tools**: Explicitly define what tools the agent needs access to

## Integration with System

Agents created with this skill integrate with:
- The continuity system (can be invoked during automated cycles)
- The state management system (can read/update state)
- The quality framework (can run quality checks)
- The Task tool (can be invoked as subagents)
