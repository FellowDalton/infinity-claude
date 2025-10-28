# Continue Command

Execute a manual continuity cycle - simulates what the automated cron job does every 30 minutes.

## Instructions

You are in a continuity cycle. Follow the standard protocol to maintain autonomous progress.

### Continuity Protocol

1. **Read State**: Load `.claude/state/current.json` to understand:
   - Current phase and cycle number
   - Next actions queue (prioritized)
   - Recent completed actions
   - Any blockers or issues
   - Quality metrics

2. **Execute Next Actions**: Process items from `nextActions` queue:
   - Sort by priority (critical → high → medium → low)
   - Execute actions in order
   - Mark each as completed when done
   - Move to `completedActions` array

3. **Update State**: Record all progress:
   - Increment `cycleCount`
   - Move completed items from `nextActions` to `completedActions`
   - Update metrics (tasks completed, quality scores, etc.)
   - Update `lastRun` timestamp
   - Document any new blockers

4. **Quality Check**: If code was written:
   - Run quality gates: `bash .claude/scripts/run_quality_gates.sh`
   - Ensure quality score stays >95
   - Fix any issues before proceeding
   - Update quality metrics in state

5. **Plan Next Actions**: Before finishing, add new items to `nextActions`:
   - Be specific (not "continue development", but "implement user authentication")
   - Assign priorities
   - Consider dependencies
   - Break down large tasks

6. **Check for Blockers**:
   - If stuck on same task for 3+ cycles, create a helper agent or tool
   - If truly blocked, set `requiresHuman: true` and document in `blockers`
   - Otherwise, continue autonomously

### State Management

Use the continuity-manager subagent if needed to help with state updates.

### Quality Requirements

- Quality score must stay >95
- Test coverage must be >80%
- All security scans must pass
- Documentation must be complete

### Remember

- Always plan next actions before finishing
- Update state file at end of EVERY cycle
- Use internet access to research improvements
- Document decisions in `.claude/memory/`
- Create agents/tools as needed to unblock yourself

The system depends on continuity - always ensure the next cycle can pick up where you left off.
