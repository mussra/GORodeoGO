# AI DEVELOPMENT RULES

## Purpose
Mandatory engineering rules for any AI modifying, reviewing, testing or maintaining this project.

## Core principles
- Correctness before speed.
- Simplicity before unnecessary sophistication.
- No speculative implementation.
- No architectural degradation without explicit justification.
- Every change must be verifiable.
- Preserve existing behaviour unless the requirement explicitly changes it.

## Context before code
Before modifying existing code, inspect:
- project structure;
- relevant files;
- dependencies;
- interfaces/contracts;
- configuration;
- tests;
- current project state.

Never invent missing classes, APIs, files, methods, dependencies or behaviour.

## Architecture
Maintain clear separation between:
- domain/gameplay logic;
- application/orchestration;
- presentation;
- infrastructure/platform;
- data/configuration;
- tests.

Do not create abstractions or patterns without a concrete benefit.

## SOLID
Apply SOLID pragmatically:
- Single Responsibility;
- Open/Closed;
- Liskov Substitution;
- Interface Segregation;
- Dependency Inversion.

Avoid over-engineering.

## Dependencies
Avoid unnecessary external dependencies and circular dependencies.
Dependencies must have a clear direction.

## Single source of truth
Important rules, states and configuration values must have one authoritative source.

## GDScript quality
- use static typing on all declarations (see CONVENTIONS.md);
- avoid untyped `Variant` unless the type genuinely varies;
- never silence engine warnings without proof;
- the Godot parser/analyzer is the early defect detector: run the project and the GUT suite headless before declaring anything done;
- Domain/Application scripts stay free of Node/SceneTree dependencies.

## Errors
Never hide exceptions or failures.
Do not use empty catch blocks.
Handle errors at the appropriate layer.

## Validation
External and persisted data must be validated.
Important state transitions must be explicit.

## Testing
Important behaviour requires automated tests.
Use unit tests for isolated logic and integration tests for component interaction.
Important bugs should become regression tests when practical.

## Change discipline
Prefer small, logically isolated changes.
Do not mix unrelated refactors with feature work unless necessary.

## No patch chains
If several fixes create new failures, stop patching and analyse the root cause.

## AI-generated code
Treat generated code as UNVERIFIED until it passes:
- compilation;
- static analysis;
- relevant tests;
- integration validation.

## Completion
A task is complete only when:
- requirement implemented;
- code builds;
- relevant analysis passes;
- relevant tests pass;
- integration is checked;
- relevant project state/documentation is updated.
