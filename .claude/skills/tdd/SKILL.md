---
name: tdd
description: Test-Driven Development skill that writes reference-grade tests focused on contracts,
  boundaries, and behaviours — not coverage. Then interactively refactors using SOLID principles and locality of behaviour.
  Use when user wants to write tests, do TDD, or test-drive a feature.
---

# Test-Driven Development

Write reference-grade tests. Then interactively refactor toward SOLID and locality of behaviour.

## Philosophy

Follow Kent C. Dodds' Testing Trophy:
- **"Write tests. Not too many. Mostly integration."**
- Integration tests give the highest confidence-per-effort ratio
- Unit tests only for pure logic, algorithms, and edge-heavy functions
- Never test implementation details — tests should survive refactoring unchanged
- Stop at ~70% coverage; diminishing returns beyond that

## 1. Mode Selection

Determine the mode based on context:

- **Red-Green-Refactor (new code):** Write a failing test first → minimal implementation to pass → refactor. Strict cycle.
- **Retrofit (existing code):** Read the existing code, identify contracts and boundaries, then write tests that lock down current behaviour before any changes.

Ask the user which mode if unclear from context.

## 2. Test Plan

Before writing any test code, produce a numbered **test plan** for user review:

1. Identify the **public contracts** — what does this module promise to its callers?
2. Identify **boundaries** — where does this module talk to external systems, other modules, or I/O?
3. Identify **key behaviours** — what are the important state transitions, business rules, and edge cases?
4. For each test case, write one line in behaviour-driven style:
   - `should reject expired tokens`
   - `should return empty list when no matches found`
   - `should propagate database errors without swallowing them`

Categorize each test as **integration** (default) or **unit** (only for pure logic).

**Exit criteria:** User approves the test plan before any test code is written.

## 3. Write Tests

Adapt to the project's language, framework, and test runner. Detect existing conventions by reading nearby test files.

### Rules

- **Behaviour-driven names:** Describe what the system does, not how. Use `should...` or `given...when...then...` style.
- **Minimize mocks:** Only mock external I/O (network, filesystem, clock, randomness). Never mock internal collaborators. Use real dependencies or in-memory fakes.
- **One assertion per behaviour:** Each test validates one logical behaviour. Multiple asserts are fine if they verify the same behaviour.
- **Arrange-Act-Assert structure:** Clear separation. No logic in tests — no conditionals, no loops.
- **No implementation coupling:** Tests must not reference private methods, internal state, or execution order. Test through the public API only.

### In Red-Green-Refactor mode

1. Write one failing test
2. Run it — confirm it fails for the right reason
3. Write the minimal code to make it pass
4. Run it — confirm it passes
5. Repeat for each test in the plan

### In Retrofit mode

1. Write all tests from the plan
2. Run them — all should pass against existing code
3. Flag any surprise failures for investigation

## 4. Interactive Refactoring

Once tests are green, propose refactoring opportunities one at a time. For each:

1. **Name** the refactoring and the SOLID principle it serves
2. **Show** what would change (before/after)
3. **Wait** for user approval before applying

### SOLID Principles (apply all five as opportunities arise)

- **S — Single Responsibility:** Each module/class has one reason to change
- **O — Open/Closed:** Extend behaviour through composition, not modification
- **L — Liskov Substitution:** Subtypes must be substitutable for their base types
- **I — Interface Segregation:** No client should depend on methods it doesn't use
- **D — Dependency Inversion:** Depend on abstractions, not concretions

### Locality of Behaviour

- **Colocate related logic:** A reader should understand a feature by reading one place, not tracing across layers
- **Resist premature abstraction:** Prefer duplication over the wrong abstraction. Don't extract until the third use.
- **Readability at the call site:** The code where behaviour is invoked should make that behaviour obvious

### After each refactoring

- Re-run all tests to confirm they still pass
- If a test breaks, the refactoring changed behaviour — revert and reconsider

## Guards

- Never chase coverage numbers. Test what matters.
- Never test framework/library internals.
- Never add tests that would break on a valid refactor.
- If a test needs more than 3 lines of setup, the design may need work — flag it.
