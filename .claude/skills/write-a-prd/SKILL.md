---
name: write-a-prd
description: Create a PRD and implementation plan through user interview, codebase exploration, and module design.
  Use when user wants to write a PRD, product requirements document, spec, plan, or design a new product of feature.
  Prefer this skill over jumping straight to code when the user's request is ambiguous or large in scope.
---

This phase is dedicated to research and planning. Do NOT implement any solution yet. 
Let us set the right context to avoid solving the wrong problem.

# 1. Research Phase

- Ask the user for a detailed description of the problem to solve and any potential solution.
- Ask the user the required files and folders to verify their assertions and understand the current state of the codebase.
- Interview the user relentlessly about every aspect of this plan until you reach a shared understanding.
  Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.

**Exit criteria:** You have enough clarity to describe the solution without saying "it depends" or "we could do X or Y."

Share your findings with the user to validate understanding before planning.

# 2. Planning Phase

- Describe the major modules to build or modify:
    - Component responsibilities and boundaries
    - Key interfaces between components
    - Data flow through the system
- Sketch a system design diagram using ASCII art to visualize components and their dependencies.

# 3. Output Phase

Default output location is ./docs/PRD.md. Confirm with the user ([Y/n]).

## PRD Template

```markdown
## Problem Statement

[The problem from the user's perspective - what pain exists today]

## Solution

[The solution from the user's perspective - what will be different]

## User Stories

[Numbered list covering all aspects of the feature]

1. As a <actor>, I want <capability>, so that <benefit>
   - Acceptance: <how we know this story is complete>

Example:
1. As a mobile bank customer, I want to see my account balance, so that I can make informed spending decisions
   - Acceptance: Balance displays within 2 seconds, updates on pull-to-refresh

## Implementation Decisions

[Architectural choices, module boundaries, interfaces, schema changes, API contracts]

Do NOT include specific file paths or code snippets - they become outdated quickly.

## Implementation Plan

Write a step-by-step implementation plan that another developer (or Claude) can follow to build the product.

## Testing Strategy

- What makes a good test for this feature (test behavior, not implementation)
- Use the [TDD](~/.claude/skills/tdd/SKILL.md) skill philosophy
- Which modules need tests and what kind (unit, integration, e2e)
- Similar tests in the codebase to use as reference

## Out of Scope

[Explicit list of what this PRD does NOT cover]

## Open Questions

[Unresolved items that need follow-up]

## Priority & Sequencing

[Suggested order of implementation, dependencies between stories]
```
