# Quality Framework - Best Practices Enforcement

## 🎯 Mission Critical
**Code quality is non-negotiable. Every line must meet industry best practices.**

## Your Mandate

You have internet access. Use it aggressively to ensure quality:

### 1. Research Phase (First Priority)
Before writing ANY code:
- [ ] Search for "[technology] best practices 2025"
- [ ] Find official style guides (e.g., Airbnb JavaScript, Google Python)
- [ ] Study high-quality open source projects in the same domain
- [ ] Research common anti-patterns and pitfalls
- [ ] Find security best practices (OWASP, etc.)
- [ ] Document findings in `.claude/memory/best-practices.md`

### 2. Validation Systems to Create

You MUST create agents/tools for:

#### A. Static Analysis
```bash
# Create tools for:
- Linting (ESLint, Pylint, etc.)
- Type checking (TypeScript, mypy, etc.)
- Security scanning (npm audit, Snyk, etc.)
- Complexity analysis
- Dead code detection
```

#### B. Code Review Agent
Create an agent that:
- Reviews every file before commit
- Checks against documented best practices
- Validates naming conventions
- Verifies documentation completeness
- Ensures test coverage
- Flags potential security issues

#### C. Testing Framework
- Unit tests (>80% coverage minimum)
- Integration tests
- E2E tests where applicable
- Performance benchmarks
- Security tests

#### D. Architecture Validation
- Design pattern compliance
- SOLID principles adherence
- DRY principle enforcement
- Separation of concerns
- Proper error handling
- Logging and monitoring

### 3. Quality Gates

**NO CODE PROCEEDS WITHOUT:**
1. ✅ Passing linter with ZERO warnings
2. ✅ Type safety validated
3. ✅ Tests written and passing (>80% coverage)
4. ✅ Security scan clean
5. ✅ Code review by quality agent approved
6. ✅ Performance benchmarks met
7. ✅ Documentation complete

### 4. How to Research Best Practices

**Use web_search tool to find:**
```
Examples:
- "React best practices 2025"
- "Node.js security best practices"
- "Python code quality standards"
- "PostgreSQL performance optimization"
- "REST API design best practices"
- "Git workflow best practices"
```

**Look for:**
- Official documentation
- Industry leaders' blogs (Kent C. Dodds, Dan Abramov, etc.)
- Major tech company engineering blogs (Google, Netflix, Airbnb)
- OWASP security guidelines
- Framework-specific guides
- Academic papers for algorithms

### 5. Reference Projects

Search and analyze these types of projects:
- Top GitHub stars in your tech stack
- Projects by major tech companies
- Well-documented open source projects
- Projects with extensive test suites

**Document why they're high quality:**
```markdown
## Reference: [Project Name]
- GitHub: [URL]
- Stars: [count]
- Why Quality:
  - [Reason 1]
  - [Reason 2]
- Patterns to Adopt:
  - [Pattern 1]
  - [Pattern 2]
```

### 6. Self-Improvement Loop

After each cycle:
1. Review code written
2. Search for "better way to [what you just did]"
3. Compare against best practices
4. Refactor if needed
5. Update your quality rules
6. Document learnings

### 7. Quality Metrics to Track

In `.claude/state/current.json`:
```json
"quality": {
  "codeReviews": 0,
  "testsWritten": 0,
  "testCoverage": 0,
  "linterPasses": 0,
  "securityScans": 0,
  "performanceTests": 0,
  "bestPracticeViolations": 0,
  "qualityScore": 100
}
```

**Quality score calculation:**
```
qualityScore = 100 - (violations * 10)
If qualityScore < 80: BLOCK and refactor
```

### 8. Tools You Should Create

Create these early (within first 10 cycles):

1. **`quality_check.sh`** - Runs all quality gates
2. **`pre_commit.sh`** - Validates before any code commit
3. **`code_review.sh`** - Automated code review checklist
4. **`best_practices_validator.sh`** - Checks against researched standards
5. **`security_scan.sh`** - Security vulnerability checks
6. **`performance_test.sh`** - Performance benchmarks

### 9. Documentation Requirements

Every piece of code needs:
- **Purpose**: What does it do?
- **Why**: Why this approach?
- **Best Practice**: Which best practice does it follow?
- **References**: Links to documentation/standards
- **Tests**: Where are the tests?
- **Trade-offs**: What alternatives were considered?

### 10. Red Flags (Auto-Block)

These should NEVER pass quality gates:
- ❌ Any code without tests
- ❌ Console.logs in production code
- ❌ Hardcoded credentials or secrets
- ❌ SQL injection vulnerabilities
- ❌ Uncaught exceptions
- ❌ Magic numbers without constants
- ❌ Functions >50 lines
- ❌ Cyclomatic complexity >10
- ❌ Copy-pasted code
- ❌ TODO comments without tickets

## Implementation Plan

### Cycle 1-5: Setup Quality System
```
1. Research best practices for chosen tech
2. Create quality_enforcer agent
3. Set up linting and formatting
4. Create testing framework
5. Document quality standards
```

### Cycle 6-10: Implement Quality Gates
```
1. Create pre-commit hooks
2. Build automated code review
3. Set up security scanning
4. Create performance benchmarks
5. Establish quality metrics
```

### Every Cycle Thereafter
```
1. Run quality gates on all changes
2. Update quality metrics
3. Research improvements
4. Refactor to higher standards
5. Document learnings
```

## How Claude Should Use This

1. **Before ANY code**: Research best practices
2. **During development**: Validate continuously
3. **After code written**: Run ALL quality gates
4. **If quality fails**: Block, fix, learn, document
5. **Every cycle**: Improve quality standards

## Success Criteria

You are succeeding if:
- ✅ Quality score stays >95
- ✅ Test coverage >80%
- ✅ Zero security vulnerabilities
- ✅ All code has documentation
- ✅ Quality gates catching issues before they're committed
- ✅ Best practices documented and followed
- ✅ Regular quality improvements logged

## Failure Indicators

Flag for human intervention if:
- ❌ Quality score drops below 80
- ❌ Unable to find best practices for a technology
- ❌ Quality gates consistently failing
- ❌ Test coverage dropping
- ❌ Security vulnerabilities found

---

**Remember: Quality is not optional. It is the primary measure of success.**

Research → Validate → Implement → Test → Review → Improve → Repeat