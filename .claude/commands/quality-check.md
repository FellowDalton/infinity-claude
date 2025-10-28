# Quality Check Command

Run all quality gates and generate a comprehensive quality report.

## Instructions

Execute all quality validation checks and ensure the code meets the required standards (quality score >95).

### Run Quality Gates

Execute the quality gates script:
```bash
bash .claude/scripts/run_quality_gates.sh
```

### Quality Gates

The system will check:

**1. Code Quality - Linting**
- ESLint (JavaScript/TypeScript)
- Pylint/Flake8 (Python)
- Language-specific linters
- **Requirement**: Zero warnings

**2. Type Safety**
- TypeScript type checking
- mypy (Python)
- **Requirement**: All types valid, no `any` types

**3. Testing**
- Unit tests
- Integration tests
- E2E tests (if applicable)
- **Requirement**: >80% code coverage

**4. Security**
- Dependency scanning (npm audit, pip-audit)
- Secrets detection (gitleaks, trufflehog)
- OWASP compliance checks
- **Requirement**: Zero high/critical vulnerabilities

**5. Code Complexity**
- Cyclomatic complexity <10
- Function length <50 lines
- Nesting depth <3 levels

**6. Build Verification**
- Project builds successfully
- No build errors or warnings

**7. Documentation**
- README.md exists and is complete
- All public APIs documented
- Architecture docs updated

### Quality Score Calculation

```
Base: 100 points
- Critical failure: -20 points
- Warning failure: -5 points
- Coverage <80%: -10 points
- Documentation issues: -5 points

Minimum Required: 95/100
```

### If Quality Fails

**DO NOT PROCEED if quality score <95:**

1. **Review Report**: Check `.claude/state/quality_report.txt` for details
2. **Fix Issues**: Address each failure systematically
3. **Document**: Log what went wrong in `.claude/memory/learnings.md`
4. **Re-run**: Execute quality check again
5. **Update Standards**: If needed, improve quality rules

### After Passing

1. **Update Metrics**: Record quality metrics in `.claude/state/current.json`:
   ```json
   "metrics": {
     "quality": {
       "qualityScore": 98,
       "testCoverage": 87,
       "linterPasses": 1,
       "securityScans": 1,
       "checksRun": 7,
       "checksPassed": 7
     }
   }
   ```

2. **Document**: Note any improvements in `.claude/memory/learnings.md`

3. **Continue**: Proceed with next development actions

### Continuous Quality

Run quality checks:
- Before every commit
- After writing any new code
- After refactoring
- At the end of each cycle
- When quality score drops

### Best Practices Research

If any check fails, research better approaches:
- Search: "[technology] best practices for [failed check]"
- Search: "how to fix [specific error]"
- Search: "industry standard for [quality aspect]"

Document findings in `.claude/memory/best-practices.md`

### Integration

Quality checking is integrated into the continuity system:
- Quality gates run automatically during development cycles
- Failures block progress (set `requiresHuman: true` if can't fix)
- Quality metrics tracked over time
- Standards continuously improved

**Remember: Quality is non-negotiable. A quality score of 95+ is required for all code.**
