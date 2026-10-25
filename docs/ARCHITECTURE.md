---
id: format-ansi-architecture
parent: format-ansi-goals
type: architecture-design
title: format-ansi Architecture
status: active
---

# Architecture

## System Overview

format-ansi is a single-module library that translates user-friendly color/style specifications into ANSI escape sequences. It has no external runtime dependencies and is designed to integrate seamlessly with CL:FORMAT.

```
User Code
    ↓
format-ansi API (format-ansi function)
    ↓
Type validation & dispatch (ansi-entry? / ansi-entries?)
    ↓
Code lookup & generation (find-code / print-code)
    ↓
ANSI escape sequence emission
    ↓
Stream output
```

## Module Boundaries

### Single Production Module: format-ansi (src/main.lisp)

**Responsibility:**
- Define all ANSI type abstractions (colors, styles, entry lists)
- Provide the primary `format-ansi` function and helpers
- Manage color/style lookup tables and ANSI code generation
- Handle stream I/O and format control string processing

**Boundary:**
- **Public API:** `format-ansi`, type predicates (`ansi-entry?`, `ansi-entries?`), type definitions, `*enabled*` parameter
- **Internal only:** lookup tables (`*styles*`, `*fg-colors*`, `*bg-colors*`), code generation helpers (`print-code`, `find-code`), formatting machinery
- **No external dependencies**

**Invariants:**
- All color/style definitions are hardcoded lookup tables (no external configuration)
- ANSI code generation is deterministic: same inputs → same escape sequences
- The `*enabled*` parameter gates all ANSI code output globally
- Type checking via `ansi-entry?` happens on every list-based call (fail-fast)

## Data Model

**Colors:** Represented as keyword symbols (`:RED`, `:BLUE`, etc.) or integers (0–255 for the 256-color palette).

**Styles:** Represented as keyword symbols (`:BOLD`, `:ITALIC`, etc.).

**Entry Lists:** Flexible nested structure allowing:
- Bare strings (pass-through to CL:FORMAT)
- Pairs of `color-key → color` (`:fg :red`, `:bg :blue`)
- Pairs of `:st → style`
- Each can precede a format control string + arguments

## Design Rationale

1. **Similar to CL:FORMAT:** The entry list structure and parameter style mirrors CL:FORMAT, lowering the learning curve for Common Lispers.

2. **Type system over validation:** Heavy use of DEFTYPE and type predicates (`ansi-entry?`) ensures invalid input is caught early and type errors are clear.

3. **Lookup tables over computation:** All ANSI codes are precomputed tables; no algorithmic generation. Trades memory for simplicity and predictability.

4. **Global enable/disable:** The `*enabled*` parameter allows disabling colors without changing code paths, useful for piping to files or non-interactive contexts.

5. **No dependencies:** Self-contained implementation maximizes portability and minimizes deployment friction.
