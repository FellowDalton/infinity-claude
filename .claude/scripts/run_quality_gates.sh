#!/bin/bash

# Quality Gates Runner
# Executes all quality checks and generates a report
# Exit code 0 = all passed, 1 = failures detected

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
STATE_FILE="$PROJECT_ROOT/.claude/state/current.json"
REPORT_FILE="$PROJECT_ROOT/.claude/state/quality_report.txt"

cd "$PROJECT_ROOT"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
BOLD='\033[1m'

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
QUALITY_SCORE=100

# Log function
log() {
    echo -e "$1" | tee -a "$REPORT_FILE"
}

# Check function
run_check() {
    local name="$1"
    local command="$2"
    local critical="$3"  # true/false
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    log "\n${BLUE}[CHECK]${NC} $name"
    
    if eval "$command" >> "$REPORT_FILE" 2>&1; then
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        log "${GREEN}✓ PASSED${NC}"
        return 0
    else
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
        if [ "$critical" = "true" ]; then
            log "${RED}✗ FAILED (CRITICAL)${NC}"
            QUALITY_SCORE=$((QUALITY_SCORE - 20))
        else
            log "${YELLOW}✗ FAILED (WARNING)${NC}"
            QUALITY_SCORE=$((QUALITY_SCORE - 5))
        fi
        return 1
    fi
}

# Initialize report
echo "Quality Gates Report" > "$REPORT_FILE"
echo "Generated: $(date)" >> "$REPORT_FILE"
echo "======================================" >> "$REPORT_FILE"

log "${BOLD}${BLUE}═══════════════════════════════════════${NC}"
log "${BOLD}${BLUE}    Quality Gates Execution${NC}"
log "${BOLD}${BLUE}═══════════════════════════════════════${NC}"

# ============================================
# 1. LINTING
# ============================================
log "\n${BOLD}1. CODE QUALITY - LINTING${NC}"

# JavaScript/TypeScript
if [ -f "package.json" ]; then
    if grep -q "eslint" package.json; then
        run_check "ESLint" "npm run lint --silent" true
    fi
fi

# Python
if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    if command -v pylint &> /dev/null; then
        run_check "Pylint" "find . -name '*.py' -not -path './venv/*' -not -path './.venv/*' | xargs pylint" false
    fi
    if command -v flake8 &> /dev/null; then
        run_check "Flake8" "flake8 ." false
    fi
fi

# ============================================
# 2. TYPE CHECKING
# ============================================
log "\n${BOLD}2. TYPE SAFETY${NC}"

# TypeScript
if [ -f "tsconfig.json" ]; then
    run_check "TypeScript" "npx tsc --noEmit" true
fi

# Python
if command -v mypy &> /dev/null && [ -f "pyproject.toml" ]; then
    run_check "mypy" "mypy ." false
fi

# ============================================
# 3. TESTING
# ============================================
log "\n${BOLD}3. TESTING${NC}"

# JavaScript/TypeScript
if [ -f "package.json" ]; then
    if grep -q "jest" package.json || grep -q "vitest" package.json; then
        run_check "Unit Tests" "npm test -- --coverage --passWithNoTests" true
        
        # Check coverage
        if [ -f "coverage/coverage-summary.json" ]; then
            COVERAGE=$(jq -r '.total.lines.pct' coverage/coverage-summary.json 2>/dev/null || echo "0")
            log "Coverage: $COVERAGE%"
            if (( $(echo "$COVERAGE < 80" | bc -l) )); then
                log "${YELLOW}⚠ Coverage below 80%${NC}"
                QUALITY_SCORE=$((QUALITY_SCORE - 10))
            else
                log "${GREEN}✓ Coverage meets requirement${NC}"
            fi
        fi
    fi
fi

# Python
if [ -f "pytest.ini" ] || [ -f "pyproject.toml" ]; then
    if command -v pytest &> /dev/null; then
        run_check "pytest" "pytest --cov --cov-report=json" true
        
        # Check coverage
        if [ -f "coverage.json" ]; then
            COVERAGE=$(jq -r '.totals.percent_covered' coverage.json 2>/dev/null || echo "0")
            log "Coverage: $COVERAGE%"
            if (( $(echo "$COVERAGE < 80" | bc -l) )); then
                log "${YELLOW}⚠ Coverage below 80%${NC}"
                QUALITY_SCORE=$((QUALITY_SCORE - 10))
            fi
        fi
    fi
fi

# ============================================
# 4. SECURITY
# ============================================
log "\n${BOLD}4. SECURITY${NC}"

# npm audit
if [ -f "package-lock.json" ]; then
    run_check "npm audit" "npm audit --audit-level=high" true
fi

# pip-audit
if [ -f "requirements.txt" ]; then
    if command -v pip-audit &> /dev/null; then
        run_check "pip-audit" "pip-audit" true
    fi
fi

# Check for secrets
if command -v gitleaks &> /dev/null; then
    run_check "Secrets scan" "gitleaks detect --no-git" true
elif command -v trufflehog &> /dev/null; then
    run_check "Secrets scan" "trufflehog filesystem ." true
else
    log "${YELLOW}⚠ No secrets scanner installed (gitleaks/trufflehog)${NC}"
fi

# ============================================
# 5. CODE COMPLEXITY
# ============================================
log "\n${BOLD}5. CODE COMPLEXITY${NC}"

# JavaScript/TypeScript complexity
if command -v npx &> /dev/null && [ -f "package.json" ]; then
    run_check "Complexity Check" "npx eslint . --no-eslintrc --plugin complexity --rule 'complexity: [error, 10]'" false
fi

# ============================================
# 6. BUILD VERIFICATION
# ============================================
log "\n${BOLD}6. BUILD VERIFICATION${NC}"

# JavaScript/TypeScript
if [ -f "package.json" ] && grep -q "build" package.json; then
    run_check "Build" "npm run build" true
fi

# Python
if [ -f "setup.py" ]; then
    run_check "Python Build" "python setup.py check" false
fi

# ============================================
# 7. DOCUMENTATION
# ============================================
log "\n${BOLD}7. DOCUMENTATION${NC}"

# Check README exists
if [ ! -f "README.md" ]; then
    log "${YELLOW}⚠ README.md missing${NC}"
    QUALITY_SCORE=$((QUALITY_SCORE - 5))
else
    log "${GREEN}✓ README.md exists${NC}"
fi

# Check if code has JSDoc/docstrings
if [ -f "package.json" ]; then
    UNDOCUMENTED=$(find src -name "*.ts" -o -name "*.js" 2>/dev/null | xargs grep -L "\/\*\*" | wc -l || echo "0")
    if [ "$UNDOCUMENTED" -gt 0 ]; then
        log "${YELLOW}⚠ $UNDOCUMENTED files lack documentation${NC}"
    fi
fi

# ============================================
# FINAL REPORT
# ============================================
log "\n${BOLD}${BLUE}═══════════════════════════════════════${NC}"
log "${BOLD}QUALITY GATES SUMMARY${NC}"
log "${BOLD}${BLUE}═══════════════════════════════════════${NC}"

log "\nTotal Checks: $TOTAL_CHECKS"
log "${GREEN}Passed: $PASSED_CHECKS${NC}"
log "${RED}Failed: $FAILED_CHECKS${NC}"

# Ensure quality score doesn't go negative
if [ $QUALITY_SCORE -lt 0 ]; then
    QUALITY_SCORE=0
fi

log "\n${BOLD}Quality Score: $QUALITY_SCORE/100${NC}"

if [ $QUALITY_SCORE -ge 95 ]; then
    log "${GREEN}${BOLD}✓ EXCELLENT - All quality gates passed!${NC}"
    EXIT_CODE=0
elif [ $QUALITY_SCORE -ge 80 ]; then
    log "${YELLOW}${BOLD}⚠ ACCEPTABLE - Some issues detected${NC}"
    log "${YELLOW}Consider fixing issues before proceeding${NC}"
    EXIT_CODE=0
else
    log "${RED}${BOLD}✗ FAILED - Quality score too low${NC}"
    log "${RED}Must fix issues before proceeding${NC}"
    EXIT_CODE=1
fi

# Update state file with quality metrics
if [ -f "$STATE_FILE" ]; then
    TMP_FILE=$(mktemp)
    jq --arg score "$QUALITY_SCORE" \
       --arg checks "$TOTAL_CHECKS" \
       --arg passed "$PASSED_CHECKS" \
       --arg failed "$FAILED_CHECKS" \
       '.metrics.quality.qualityScore = ($score | tonumber) | 
        .metrics.quality.checksRun = ($checks | tonumber) |
        .metrics.quality.checksPassed = ($passed | tonumber) |
        .metrics.quality.checksFailed = ($failed | tonumber) |
        .health.lastQualityCheck = now | 
        .health.qualityStatus = (if ($score | tonumber) >= 95 then "excellent" 
                                elif ($score | tonumber) >= 80 then "acceptable" 
                                else "poor" end)' \
       "$STATE_FILE" > "$TMP_FILE"
    mv "$TMP_FILE" "$STATE_FILE"
fi

log "\n${BLUE}Full report saved to: $REPORT_FILE${NC}"
log "${BLUE}═══════════════════════════════════════${NC}\n"

exit $EXIT_CODE