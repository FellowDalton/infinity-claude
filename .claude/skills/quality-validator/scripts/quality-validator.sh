#!/bin/bash

# Quality Validator Skill
# Runs specific quality checks and reports results

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$PROJECT_ROOT"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if linter exists and run it
check_linting() {
    echo -e "${BLUE}Checking linting...${NC}"

    if [ -f "package.json" ] && grep -q "lint" package.json; then
        if npm run lint --silent 2>&1; then
            echo -e "${GREEN}✓ Linting passed${NC}"
            return 0
        else
            echo -e "${RED}✗ Linting failed${NC}"
            return 1
        fi
    elif [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; then
        if command -v pylint &> /dev/null; then
            if find . -name "*.py" -not -path "./venv/*" -not -path "./.venv/*" | xargs pylint 2>&1; then
                echo -e "${GREEN}✓ Pylint passed${NC}"
                return 0
            else
                echo -e "${RED}✗ Pylint failed${NC}"
                return 1
            fi
        fi
    fi

    echo -e "${YELLOW}⚠ No linter configured${NC}"
    return 0
}

# Check type safety
check_types() {
    echo -e "${BLUE}Checking types...${NC}"

    if [ -f "tsconfig.json" ]; then
        if npx tsc --noEmit 2>&1; then
            echo -e "${GREEN}✓ Type checking passed${NC}"
            return 0
        else
            echo -e "${RED}✗ Type checking failed${NC}"
            return 1
        fi
    elif command -v mypy &> /dev/null && [ -f "pyproject.toml" ]; then
        if mypy . 2>&1; then
            echo -e "${GREEN}✓ mypy passed${NC}"
            return 0
        else
            echo -e "${RED}✗ mypy failed${NC}"
            return 1
        fi
    fi

    echo -e "${YELLOW}⚠ No type checker configured${NC}"
    return 0
}

# Run tests
check_tests() {
    echo -e "${BLUE}Running tests...${NC}"

    if [ -f "package.json" ] && (grep -q "jest" package.json || grep -q "vitest" package.json); then
        if npm test -- --passWithNoTests 2>&1; then
            echo -e "${GREEN}✓ Tests passed${NC}"
            return 0
        else
            echo -e "${RED}✗ Tests failed${NC}"
            return 1
        fi
    elif command -v pytest &> /dev/null; then
        if pytest 2>&1; then
            echo -e "${GREEN}✓ pytest passed${NC}"
            return 0
        else
            echo -e "${RED}✗ pytest failed${NC}"
            return 1
        fi
    fi

    echo -e "${YELLOW}⚠ No test framework configured${NC}"
    return 0
}

# Check test coverage
check_coverage() {
    echo -e "${BLUE}Checking test coverage...${NC}"

    if [ -f "coverage/coverage-summary.json" ]; then
        COVERAGE=$(jq -r '.total.lines.pct' coverage/coverage-summary.json 2>/dev/null || echo "0")
        echo "Coverage: ${COVERAGE}%"

        if (( $(echo "$COVERAGE >= 80" | bc -l) )); then
            echo -e "${GREEN}✓ Coverage meets requirement (>80%)${NC}"
            return 0
        else
            echo -e "${RED}✗ Coverage below 80%${NC}"
            return 1
        fi
    elif [ -f "coverage.json" ]; then
        COVERAGE=$(jq -r '.totals.percent_covered' coverage.json 2>/dev/null || echo "0")
        echo "Coverage: ${COVERAGE}%"

        if (( $(echo "$COVERAGE >= 80" | bc -l) )); then
            echo -e "${GREEN}✓ Coverage meets requirement (>80%)${NC}"
            return 0
        else
            echo -e "${RED}✗ Coverage below 80%${NC}"
            return 1
        fi
    fi

    echo -e "${YELLOW}⚠ No coverage report found${NC}"
    return 0
}

# Security scan
check_security() {
    echo -e "${BLUE}Running security scan...${NC}"

    if [ -f "package-lock.json" ]; then
        if npm audit --audit-level=high 2>&1; then
            echo -e "${GREEN}✓ No high/critical vulnerabilities${NC}"
            return 0
        else
            echo -e "${RED}✗ Security vulnerabilities found${NC}"
            return 1
        fi
    elif [ -f "requirements.txt" ] && command -v pip-audit &> /dev/null; then
        if pip-audit 2>&1; then
            echo -e "${GREEN}✓ No vulnerabilities found${NC}"
            return 0
        else
            echo -e "${RED}✗ Security vulnerabilities found${NC}"
            return 1
        fi
    fi

    echo -e "${YELLOW}⚠ No security scanner available${NC}"
    return 0
}

# Check for secrets
check_secrets() {
    echo -e "${BLUE}Scanning for secrets...${NC}"

    if command -v gitleaks &> /dev/null; then
        if gitleaks detect --no-git 2>&1; then
            echo -e "${GREEN}✓ No secrets detected${NC}"
            return 0
        else
            echo -e "${RED}✗ Secrets detected${NC}"
            return 1
        fi
    fi

    echo -e "${YELLOW}⚠ No secrets scanner installed${NC}"
    return 0
}

# Build check
check_build() {
    echo -e "${BLUE}Checking build...${NC}"

    if [ -f "package.json" ] && grep -q "\"build\"" package.json; then
        if npm run build 2>&1; then
            echo -e "${GREEN}✓ Build successful${NC}"
            return 0
        else
            echo -e "${RED}✗ Build failed${NC}"
            return 1
        fi
    fi

    echo -e "${YELLOW}⚠ No build script configured${NC}"
    return 0
}

# Quick check (fast subset)
quick_check() {
    echo "Running quick quality checks..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    PASSED=0
    FAILED=0

    if check_linting; then ((PASSED++)); else ((FAILED++)); fi
    if check_types; then ((PASSED++)); else ((FAILED++)); fi

    echo ""
    echo "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"

    [ $FAILED -eq 0 ]
}

# Full check (comprehensive)
full_check() {
    echo "Running full quality checks..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    bash .claude/scripts/run_quality_gates.sh
}

# Pre-commit check
precommit_check() {
    echo "Running pre-commit checks..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    PASSED=0
    FAILED=0

    if check_linting; then ((PASSED++)); else ((FAILED++)); fi
    if check_types; then ((PASSED++)); else ((FAILED++)); fi
    if check_tests; then ((PASSED++)); else ((FAILED++)); fi
    if check_security; then ((PASSED++)); else ((FAILED++)); fi

    echo ""
    echo "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"

    if [ $FAILED -gt 0 ]; then
        echo -e "${RED}Pre-commit checks failed. Fix issues before committing.${NC}"
        return 1
    else
        echo -e "${GREEN}All pre-commit checks passed!${NC}"
        return 0
    fi
}

# Main command handler
case "${1:-quick}" in
    lint|linting)
        check_linting
        ;;
    types|type)
        check_types
        ;;
    test|tests)
        check_tests
        ;;
    coverage)
        check_coverage
        ;;
    security)
        check_security
        ;;
    secrets)
        check_secrets
        ;;
    build)
        check_build
        ;;
    quick)
        quick_check
        ;;
    full)
        full_check
        ;;
    precommit|pre-commit)
        precommit_check
        ;;
    *)
        echo "Quality Validator Skill"
        echo ""
        echo "Usage: $0 <command>"
        echo ""
        echo "Commands:"
        echo "  lint         - Run linter only"
        echo "  types        - Check type safety only"
        echo "  tests        - Run tests only"
        echo "  coverage     - Check test coverage"
        echo "  security     - Run security scan"
        echo "  secrets      - Scan for secrets"
        echo "  build        - Check build"
        echo "  quick        - Fast checks (lint + types)"
        echo "  full         - All quality gates"
        echo "  precommit    - Pre-commit checks"
        echo ""
        echo "Examples:"
        echo "  $0 quick"
        echo "  $0 precommit"
        echo "  $0 full"
        ;;
esac
