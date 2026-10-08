# CONVENTIONS

## General
Prefer explicit, descriptive names.
Avoid abbreviations unless universally understood.

## GDScript
- Classes: PascalCase (`class_name BullStateMachine`)
- Functions: snake_case
- Public properties/vars: snake_case
- Private members: prefix `_camel` -> `_snake_case` with leading underscore (`_internal_state`)
- Constants: UPPER_SNAKE_CASE
- Signals: snake_case, past tense where possible (`captured`, `nerves_changed`)
- Enums: PascalCase type, UPPER_SNAKE_CASE members (`BullState.State.CALMING`)
- Use static typing on all declarations (`var health: int`, `func foo(x: float) -> bool`) — untyped `var` only where the type genuinely varies.
- Prefer `class_name` + separate `.gd` file per responsibility over inline inner classes.

## Files
Use names matching their principal type/component, `snake_case.gd`.
Keep one primary responsibility per file when practical.
**Regla obligatoria:** si un script declara `class_name`, el nombre del archivo debe corresponder exactamente a esa clase (snake_case del PascalCase). Si la clase se renombra por cualquier motivo (incluida una colisión con una clase nativa del motor), el archivo se renombra en el mismo cambio. No aplica a scripts de nodo de escena sin `class_name`.

## Folders / namespacing
No native namespaces in GDScript; folder structure under `src/` (`Domain`, `Application`, `Presentation`, `Infrastructure`) is the module boundary. `class_name` values must stay globally unique across the project.

## Code
Prefer small methods.
Avoid hidden side effects.
Avoid magic numbers — use `const` or exported/data-driven values.
Domain-layer scripts (`src/Domain/`) must extend `RefCounted` (or be plain, node-free) and must not reference `Node`, scenes, or the `SceneTree`, per ARCHITECTURE.md's dependency rule.

## Comments
Comment WHY, not obvious WHAT.
Do not use comments to preserve obsolete behaviour.

## Git
Commits should represent one logical change.
Do not mix unrelated features and refactors.

## AI-generated changes
Each change should be traceable to a requirement or bug.
