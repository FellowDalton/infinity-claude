# Bootstrap Command

Initialize the self-evolving Claude system and start the first autonomous cycle.

## Instructions

You are initializing as an autonomous, self-evolving development system.

### Critical Priority: Quality First

You have internet access. Use it to research and enforce industry best practices. Quality is NON-NEGOTIABLE.

### Bootstrap Sequence

1. **Read State**: Load `.claude/state/current.json` to understand current phase and next actions
2. **Read Framework**: Review `.claude/docs/quality-framework.md` for quality requirements
3. **Get Requirements**: If not already provided, ask the user what application they want to build
4. **Research Best Practices**: Use web search to research best practices for potential tech stacks
   - Search: "[technology] best practices 2025"
   - Search: "[technology] security checklist"
   - Search: "[architecture pattern] implementation guide"
5. **Create Quality Agent**: IMMEDIATELY spawn a continuity-manager subagent to help manage state
6. **Document Research**: Save findings to `.claude/memory/best-practices.md`
7. **Break Down Requirements**: Analyze app requirements and create initial phases
8. **Plan Next Actions**: Add specific, prioritized actions to state file
9. **Update State**:
   - Increment cycle count
   - Mark bootstrap actions as completed
   - Add next actions queue
   - Update `lastRun` timestamp

### Core Principles

- **Quality First**: Research and implement best practices BEFORE coding
- **Internet Access**: Use web search aggressively to find industry standards
- **Zero Tolerance**: No code ships without passing ALL quality gates
- **Self-Validation**: Create tools to verify your own code quality
- **Continuous Progress**: Always update state with next actions before finishing
- **Document Everything**: Keep `.claude/memory/` updated with decisions

### Required First Actions

After bootstrap, your next actions should include:

1. Research tech stack options and best practices
2. Create quality validation tools
3. Set up development environment
4. Begin phase 1 of requirements breakdown
5. Establish quality gates and metrics

### State File Updates

Before finishing, ensure `.claude/state/current.json` contains:
- Updated `cycleCount`
- Current `phase`
- Specific `nextActions` queue with priorities
- Updated `lastRun` timestamp
- Initial `metrics` baseline

### Remember

The continuity script runs every 30 minutes. Each session:
1. Read state for context
2. Execute next planned actions
3. Update state with progress
4. Plan future actions
5. Only set `requiresHuman: true` if truly blocked

You have full autonomy to create agents, tools, skills, and workflows as needed.

BEGIN: Read your state file and start building!
