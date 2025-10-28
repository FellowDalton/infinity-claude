# Design Philosophy: Aligning Infinity-Claude with Solo Dev Mindset

This document explains how the infinity-claude autonomous development system follows the principles in `.claude/MINDSET.md`.

---

## Purpose

At first glance, the infinity-claude system might seem to contradict Solo Dev Mindset principles:
- It has many features (skills, agents, swarms, continuity cycles)
- It automates various tasks
- It has abstractions and structure

**This document reconciles that apparent tension.**

---

## Core Alignment

### MINDSET.md Says: "Only build what's explicitly requested"
**How infinity-claude complies:**
- The system itself was explicitly requested (you're building an autonomous dev system)
- Features are tools that wait for invocation, not autonomous actors
- Skills and agents don't run unless explicitly called via slash commands or state actions
- The system asks before making decisions (via `requiresHuman` flag)

### MINDSET.md Says: "No over-engineering"
**How infinity-claude complies:**
- Each feature solves a real, concrete problem:
  - **State management**: Maintain context across sessions (real need for continuity)
  - **Quality validation**: Enforce standards before commits (real need for quality)
  - **Skills**: Reusable scripts to avoid rewriting same code (DRY principle)
  - **Agents**: Specialized contexts for focused tasks (separation of concerns)
- No feature exists "just in case" or for "future-proofing"
- If you don't use a feature, delete it

### MINDSET.md Says: "Simplicity and clarity are top priorities"
**How infinity-claude complies:**
- Skills are bash scripts (simple, readable, no magic)
- State is JSON files (transparent, inspectable, version-controllable)
- Commands are markdown files (plain text instructions)
- No hidden databases, no compiled binaries, no proprietary formats
- You can read every file and understand what it does

### MINDSET.md Says: "You are not the architect"
**How infinity-claude complies:**
- The continuity-manager subagent plans actions but **always** sets `requiresHuman: true` for architectural changes
- Agents are tools that execute specs, not decision-makers
- Skills provide capabilities but don't decide when to use them
- All automation serves you; you're still the architect

### MINDSET.md Says: "Reuse, don't reinvent"
**How infinity-claude complies:**
- Uses standard tools: bash, jq, git, npm/pytest for testing
- Leverages Claude's built-in capabilities instead of custom wrappers
- Skills wrap existing tools (quality-validator uses eslint/pylint, not custom linters)
- Only custom code is coordination logic (state management, continuity)

---

## What's Actually Automated

### Automated (No Permission Required)
- **Quality checks** - Linting, type checking, tests (you want these enforced)
- **State updates** - Tracking completed actions, incrementing counters
- **File operations** - Reading state, creating backups before changes

### Semi-Automated (Planned, You Approve)
- **Next actions** - System suggests, state file shows them, you review
- **Agent creation** - Interactive wizard asks questions, you provide answers
- **Swarm deployment** - You invoke slash command, system executes

### Never Automated (Always Asks)
- **Architectural changes** - Adding new patterns, changing system design
- **Dependency additions** - Installing new libraries or frameworks
- **Data model changes** - Modifying state structure or contracts
- **Git commits** - Only when you explicitly request

---

## Complexity Budget

Every system has some complexity. The question is: **Is it justified?**

### Justified Complexity ✅
- **State files** - Necessary for continuity (you explicitly want autonomous cycles)
- **Quality gates** - Necessary for maintaining standards (you set score >95 requirement)
- **Skills structure** - Standard Anthropic pattern (reusing, not reinventing)
- **Slash commands** - Convenience for repetitive workflows you perform

### Questionable Complexity ⚠️
*(Features to review and potentially simplify/remove)*
- **Swarm agents** - Useful for parallel tasks, but complex. Is it used often enough?
- **Memory files** - Good for context, but might accumulate cruft. Are they maintained?
- **Multiple subagents** - Do you need continuity-manager AND specialized agents?

### Unjustified Complexity ❌
*(Features that should be removed if they exist)*
- Custom build systems (use npm/make/etc instead)
- Proprietary state formats (JSON is enough)
- Abstraction layers over standard tools
- Features with no current use case

---

## Self-Audit Questions

Before adding any feature to infinity-claude, ask:

1. **Is it simple?**
   - Can you explain it in one sentence?
   - Is the implementation <100 lines for core logic?
   - Could it be simpler?

2. **Is it lovable?**
   - Will you actually use this?
   - Does it save significant time/effort?
   - Does it bring joy or just "completeness"?

3. **Is it complete?**
   - Does it solve the full problem?
   - Or is it a half-built "hook for future use"?
   - Can you ship it as-is?

4. **Does it reuse?**
   - Is there an existing tool/pattern that does this?
   - Are you rebuilding something standard?
   - Why not use the standard version?

5. **Did you ask for it?**
   - Is this in state.json as a next action?
   - Did you explicitly request this feature?
   - Or is this "nice to have" creep?

**If any answer is NO**, revise or remove the feature.

---

## Guidelines for Future Development

### When Adding Features
1. **Check MINDSET.md first** - Does this align?
2. **Ask yourself**: "Am I building this because it's needed, or because it's interesting?"
3. **Start with the simplest version** - No configuration, no options, just core functionality
4. **Use existing tools** - Wrap, don't rewrite
5. **Document clearly** - If you can't explain it simply, it's too complex

### When Removing Features
Don't hesitate to delete:
- Features you haven't used in 3+ sessions
- Features that duplicate existing functionality
- Features that "might be useful someday"
- Features you can't quickly explain to someone else

**Deleting code is improvement, not regression.**

### When Modifying Features
- Make it simpler, not more capable
- Remove options, don't add them
- Reduce abstraction, don't increase it
- If a feature grows beyond 200 lines, split or simplify

---

## Red Flags (System Violating MINDSET.md)

Watch for these signs that infinity-claude is over-engineering:

🚩 **Creating agents without explicit request**
- Agents should be created when YOU ask, not proactively

🚩 **Adding "hooks" or "future extensibility"**
- YAGNI (You Aren't Gonna Need It)

🚩 **Building abstractions over simple operations**
- If a 5-line script becomes a 50-line "framework", simplify

🚩 **Automated actions you didn't request**
- Automation should serve clear, explicit needs

🚩 **Configuration files that control simple behavior**
- Hardcode defaults, only configure what genuinely varies

🚩 **Features suggested because "best practices say..."**
- Best practices must justify themselves for THIS project

If you see any of these, **STOP** and review against MINDSET.md.

---

## Success Metrics

The infinity-claude system is succeeding when:

✅ You can explain every feature to someone in <1 minute
✅ You actually use most features regularly
✅ Adding/removing features is trivial (1 file change, no refactoring)
✅ The system helps you ship faster, not think harder
✅ You feel in control, not automated away
✅ New Claude instances can understand the system by reading a few files

The infinity-claude system is failing when:

❌ You're not sure what some features do
❌ Features exist "just in case"
❌ Changes require coordination across many files
❌ You spend more time configuring than building
❌ The system makes decisions you don't understand
❌ Documentation is longer than the code

---

## Final Note

**The infinity-claude system is a power tool, not a magic wand.**

Like a good power drill:
- It has focused capabilities (skills, agents, state)
- You control when and how to use it (slash commands, explicit invocation)
- It's transparent (you can see how it works)
- It saves time on repetitive tasks (continuity, quality checks)
- But **you're still the carpenter** - it doesn't build the house for you

When the system tries to be an architect instead of a tool, refer back to MINDSET.md and simplify.

**Own the system. Don't let it own you.**
