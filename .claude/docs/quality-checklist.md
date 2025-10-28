# Quality Checklist - Pre-Commit Validation

**Use this before ANY code is committed or progressed.**

## 📋 Mandatory Checks

### 1. Research Validation
- [ ] Best practices researched for this technology/pattern
- [ ] Sources documented in `.claude/memory/best-practices.md`
- [ ] Reference projects identified and studied
- [ ] Anti-patterns identified and avoided

**Search queries used**:
- `[technology] best practices 2025`
- `[technology] common mistakes`
- `[specific pattern] implementation guide`

**Sources found**:
- [URL 1]: [Key takeaway]
- [URL 2]: [Key takeaway]

---

### 2. Code Quality

#### Linting
- [ ] Linter installed and configured
- [ ] All files pass linting with ZERO warnings
- [ ] Custom rules created for project-specific standards
- [ ] Linter run command: `[command]`

#### Type Safety
- [ ] Type checking enabled (TypeScript, mypy, etc.)
- [ ] No `any` types (or equivalent) without justification
- [ ] All functions have type signatures
- [ ] Type checker passes: `[command]`

#### Formatting
- [ ] Consistent formatting throughout
- [ ] Prettier/Black/equivalent configured
- [ ] Auto-format on save enabled
- [ ] Format command: `[command]`

---

### 3. Testing

#### Unit Tests
- [ ] Unit tests written for all functions
- [ ] Test coverage >80% (check with coverage tool)
- [ ] Edge cases covered
- [ ] Error conditions tested
- [ ] Run command: `[command]`
- [ ] Coverage command: `[command]`

#### Integration Tests
- [ ] Integration tests for API endpoints
- [ ] Database operations tested
- [ ] Third-party integrations mocked/tested
- [ ] Run command: `[command]`

#### E2E Tests (if applicable)
- [ ] Critical user flows tested
- [ ] Run command: `[command]`

**Coverage Report**:
```
Total Coverage: [X]%
Lines: [X]%
Functions: [X]%
Branches: [X]%
```

---

### 4. Security

#### Dependency Security
- [ ] No known vulnerabilities in dependencies
- [ ] Security scan run: `npm audit` / `pip-audit` / equivalent
- [ ] All HIGH/CRITICAL issues resolved
- [ ] Scan command: `[command]`

#### Code Security
- [ ] No hardcoded secrets or credentials
- [ ] Input validation implemented
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (proper escaping)
- [ ] CSRF protection (if web app)
- [ ] Authentication/authorization properly implemented
- [ ] Error messages don't leak sensitive info

#### OWASP Top 10 Check
- [ ] Checked against OWASP Top 10 2021
- [ ] Research done: `OWASP [technology] security best practices`

---

### 5. Performance

#### Performance Tests
- [ ] Critical operations benchmarked
- [ ] Response times meet requirements
- [ ] Database queries optimized (EXPLAIN ANALYZE)
- [ ] No N+1 queries
- [ ] Appropriate caching implemented

#### Code Efficiency
- [ ] No obvious performance bottlenecks
- [ ] Algorithms have appropriate time complexity
- [ ] Memory usage is reasonable
- [ ] No memory leaks

**Benchmark Results**:
```
Operation: [name]
Target: [X]ms
Actual: [Y]ms
Status: [PASS/FAIL]
```

---

### 6. Code Review

#### Readability
- [ ] Code is self-documenting
- [ ] Variable/function names are clear and descriptive
- [ ] No magic numbers (constants defined)
- [ ] No commented-out code
- [ ] Complex logic explained with comments

#### Complexity
- [ ] Functions are <50 lines
- [ ] Cyclomatic complexity <10
- [ ] No deeply nested code (>3 levels)
- [ ] Single Responsibility Principle followed

#### Best Practices
- [ ] DRY (Don't Repeat Yourself)
- [ ] SOLID principles followed
- [ ] Proper error handling (no bare try-catch)
- [ ] Logging implemented appropriately
- [ ] Design patterns used correctly

#### Documentation
- [ ] All public APIs documented
- [ ] README updated if needed
- [ ] Complex algorithms explained
- [ ] Architecture docs updated
- [ ] Changelog updated

---

### 7. Architecture

#### Design Patterns
- [ ] Appropriate design patterns used
- [ ] Pattern justification documented
- [ ] No over-engineering

#### Separation of Concerns
- [ ] Clear layer boundaries
- [ ] Business logic separated from presentation
- [ ] Data access layer separate
- [ ] Dependencies properly managed

#### Scalability
- [ ] Can handle expected load
- [ ] Horizontal scaling considered
- [ ] Database indexes appropriate
- [ ] Caching strategy in place

---

### 8. Maintainability

#### Dependencies
- [ ] Dependencies justified and documented
- [ ] No unnecessary dependencies
- [ ] Dependencies kept up-to-date
- [ ] License compatibility checked

#### Configuration
- [ ] Environment-specific config externalized
- [ ] No hardcoded environment values
- [ ] Config validation implemented
- [ ] Example config provided

#### Error Handling
- [ ] Errors are properly caught and logged
- [ ] User-friendly error messages
- [ ] Error recovery strategies implemented
- [ ] No silent failures

---

### 9. Accessibility (Web Apps)

- [ ] WCAG 2.1 AA compliance
- [ ] Semantic HTML used
- [ ] ARIA labels where needed
- [ ] Keyboard navigation works
- [ ] Screen reader tested
- [ ] Color contrast meets standards

---

### 10. Compatibility

- [ ] Browser compatibility tested (if web)
- [ ] Mobile responsive (if web)
- [ ] Tested on target platforms
- [ ] Graceful degradation implemented
- [ ] Progressive enhancement considered

---

## ✅ Final Validation

### Automated Checks
```bash
# Run all automated checks
npm run lint          # or equivalent
npm run type-check    # or equivalent  
npm run test          # or equivalent
npm run security-scan # or equivalent
npm run build         # verify build succeeds
```

### Manual Review
- [ ] Code reviewed by quality_enforcer agent
- [ ] Compared against best-practices.md
- [ ] No TODOs without tracking tickets
- [ ] All acceptance criteria met
- [ ] Git commit message is descriptive

### Quality Score
Calculate quality score:
```
Base: 100
- Linter warnings: -1 per warning
- Test coverage: -(100 - coverage) if <80%
- Security issues: -10 per issue
- Best practice violations: -10 per violation
- Performance failures: -5 per failure

Final Score: [X]/100
```

**Minimum to proceed: 95/100**

---

## 🚫 Blockers

**DO NOT PROCEED IF**:
- Quality score <95
- Test coverage <80%
- Any HIGH/CRITICAL security issues
- Linter has errors (warnings might be acceptable with justification)
- Performance requirements not met
- Required documentation missing

**Instead**:
1. Document the issue in `.claude/state/current.json` blockers
2. Set `requiresHuman: true` if you can't fix it
3. Create a helper agent/tool if needed
4. Fix the issues
5. Re-run this checklist

---

## 📝 Checklist Log

**File**: [filename]  
**Date**: [date]  
**Reviewer**: [agent name]  
**Result**: [PASS/FAIL]  
**Quality Score**: [X]/100  

**Issues Found**: [count]  
**Issues Fixed**: [count]  
**Remaining**: [count]  

**Notes**:
- [Note 1]
- [Note 2]

---

## 🔄 Continuous Improvement

After completing checklist:
1. Document learnings in `.claude/memory/learnings.md`
2. Update quality standards if needed
3. Create automation for any manual checks
4. Search for "better way to validate [X]"
5. Update this checklist with improvements

---

**Remember: Quality is not optional. It's the foundation of everything we build.**