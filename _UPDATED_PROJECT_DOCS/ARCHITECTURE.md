# ARCHITECTURE

## Target stack
- Godot 4.x
- GDScript (statically typed; C# was dropped, see DECISIONS.md D002)
- Android
- 2D

## Architectural goal
Keep gameplay logic independent from presentation and platform-specific implementation so AI agents can modify systems safely.

## Logical layers

### Domain
Pure game rules and state where practical.
Examples:
- entities;
- state machines;
- rules;
- calculations;
- domain events.

### Application
Coordinates use cases and system interactions.
Examples:
- gameplay orchestration;
- level flow;
- progression;
- save/load coordination.

### Presentation
Godot scenes, nodes, UI, animations and visual/audio feedback.

Presentation must not become the source of truth for game state.

### Infrastructure
Platform services, persistence, Android integrations and external services.

### Configuration/Data
Data-driven values and content definitions.

### Tests
Unit and integration tests separated from production code.

## Dependency rule
Prefer:
Presentation -> Application -> Domain
Infrastructure -> Application/Domain through explicit contracts where required.

Domain should not depend directly on presentation.

## Component rules
Each component has one clear responsibility.
Prefer composition over inheritance.
Prefer small interfaces.
Do not create generic abstractions without a real need.

## State
Important state has one owner and one authoritative representation.

## Events
Use events to reduce coupling when useful, but avoid opaque event chains.

## Configuration
Gameplay parameters should be data-driven where practical.

## Future multiplayer
Do not implement multiplayer in the MVP.
Avoid architecture that makes future networking impossible, but do not add networking abstractions prematurely.

## Architectural change
Any transversal architectural change must be documented in DECISIONS.md and validated against tests.
