---
name: quality-validator
description: This skill should be used when Claude needs to run quality checks on the codebase including linting, type checking, tests, security scans, and coverage analysis. It ensures code meets quality gate requirements (score >95).
---

# Quality Validator

This skill provides comprehensive quality checking functionality for the infinity-claude system.

## Purpose

The quality-validator skill runs various quality checks on the codebase and reports results with scores. It enforces the quality-first principle by ensuring all code meets minimum quality standards before proceeding.

## When to Use This Skill

Use this skill when:
- Before committing code changes
- After implementing new features
- To verify quality score is above threshold (>95)
- Diagnosing quality issues
- Running specific quality gates (lint, tests, security, etc.)
- Need a quick health check of the codebase

## Usage

Execute the quality-validator script from the project root:

```bash
bash .claude/skills/quality-validator/scripts/quality-validator.sh <mode>
```

### Available Modes

#### `quick`
Fast quality check running only linting and type checking. Use for rapid feedback during development.

**Runtime:** ~10-30 seconds
**Checks:** Linting, Type Safety

**Example:**
```bash
bash .claude/skills/quality-validator/scripts/quality-validator.sh quick
```

**Use when:**
- During active development
- Quick sanity check
- Before running full validation

#### `precommit`
Standard pre-commit validation including linting, types, and tests. Use before any commit.

**Runtime:** ~1-3 minutes
**Checks:** Linting, Type Safety, Unit Tests

**Example:**
```bash
bash .claude/skills/quality-validator/scripts/quality-validator.sh precommit
```

**Use when:**
- Before creating commits
- After completing a task
- Standard workflow validation

#### `full`
Comprehensive quality validation running all quality gates. Use for complete verification.

**Runtime:** ~3-10 minutes
**Checks:** Linting, Type Safety, Unit Tests, Security Scan, Test Coverage

**Example:**
```bash
bash .claude/skills/quality-validator/scripts/quality-validator.sh full
```

**Use when:**
- Before major releases
- Quality score verification
- Complete system health check
- After significant changes
- When quality <80 (emergency)

## Quality Gates

### 1. Linting
**Weight:** 20 points
**Tools:** ESLint (JavaScript/TypeScript), Pylint (Python)
**Pass Criteria:** No errors, warnings acceptable

### 2. Type Safety
**Weight:** 20 points
**Tools:** TypeScript compiler, mypy (Python)
**Pass Criteria:** No type errors

### 3. Unit Tests
**Weight:** 30 points
**Tools:** Jest, pytest, or project-configured test runner
**Pass Criteria:** All tests pass

### 4. Security Scan
**Weight:** 15 points
**Tools:** npm audit, Safety (Python), snyk
**Pass Criteria:** Zero high/critical vulnerabilities

### 5. Test Coverage
**Weight:** 15 points
**Tools:** Coverage reports from test runners
**Pass Criteria:** >80% coverage

## Output Format

The validator outputs:
1. **Individual Gate Results**: Pass/Fail status for each check
2. **Quality Score**: 0-100 based on gates passed (weighted)
3. **Summary**: Overall pass/fail with recommendations

**Example output:**
```
✓ Linting passed (20/20)
✓ Type Safety passed (20/20)
✓ Unit Tests passed (30/30)
✗ Security Scan failed (0/15) - 2 high vulnerabilities
✓ Test Coverage passed (15/15)

Quality Score: 85/100
Status: BELOW THRESHOLD (requires >95)
```

## Quality Requirements

- **Minimum Score:** 95/100 to proceed
- **Critical Gates:** Linting, Type Safety, Unit Tests (must all pass)
- **Emergency Threshold:** 80/100 (STOP and fix if below)

## Best Practices

1. **Run quick during development**: Fast feedback loop
2. **Run precommit before commits**: Standard validation
3. **Run full periodically**: Complete health checks
4. **Fix issues immediately**: Don't accumulate quality debt
5. **Understand failures**: Read error output, don't just retry
6. **Update dependencies**: Keep security vulnerabilities low

## Integration with System

The quality-validator integrates with:
- Git pre-commit hooks (automatically runs on commit)
- Continuity cycles (validates before state updates)
- The /quality-check slash command (manual validation)
- CI/CD pipelines (automated validation)
- State metrics (quality score tracked in state)

## Troubleshooting

### No linter configured
Solution: Add lint script to package.json or install pylint

### Type checking fails
Solution: Fix TypeScript errors or configure tsconfig.json properly

### Tests fail
Solution: Run tests individually to identify failing tests

### Security vulnerabilities
Solution: Run `npm audit fix` or update vulnerable dependencies

### Low coverage
Solution: Add tests for uncovered code paths
