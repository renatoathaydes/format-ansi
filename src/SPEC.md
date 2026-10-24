---
id: format-ansi-main
parent: format-ansi-architecture
type: module-design
title: format-ansi Main Module
status: active
---

# format-ansi Main Module (src/main.lisp)

## Responsibility

Implement the complete public API for ANSI text formatting. This is the sole production module; it holds all type definitions, lookup tables, and formatting logic.

## Public Exports

### Primary Function
- **`format-ansi`** `(stream args &key bg fg st)` → string or nil
  - Format text with ANSI codes and emit to stream or return as string.
  - `stream`: T (stdout), NIL (return string), or any stream
  - `args`: string or `ansi-entry-list`
  - `bg`, `fg`, `st`: optional outer styles applied to entire output

### Type Definitions
- **`ansi-color`**: keyword `:BLACK`, `:RED`, …, or integer 0–255
- **`?ansi-color`**: nullable `ansi-color`
- **`ansi-style`**: keyword `:BOLD`, `:DIM`, `:ITALIC`, `:UNDERLINE`, `:BLINK`, `:NEGATIVE`, `:HIDDEN`, `:CROSS-OUT`, `:NORMAL`, `:NO-UNDERLINE`, `:POSITIVE`, `:VISIBLE`, `:NO-CROSS-OUT`
- **`?ansi-style`**: nullable `ansi-style`
- **`ansi-key`**: `:fg`, `:bg`, or `:st`
- **`ansi-color-key`**: `:fg` or `:bg`
- **`ansi-entry-list`**: list of entries, each a string or list of style pairs + string

### Type Predicates
- **`ansi-entry?`** `(entry)` → boolean: Check if single entry is valid
- **`ansi-entries?`** `(lst)` → boolean: Check if list satisfies `ansi-entry-list`

### Parameter
- **`*enabled*`** (default T): Global toggle for ANSI code emission. Set to NIL to disable colors/styles.

### Constants
- **`+reset-all+`**: The ANSI reset sequence (ESC[0m)

### Package Nickname
- `:ansi` (can use `(ansi:format-ansi ...)` as shorthand)

## Internal Implementation Details

### Lookup Tables
- **`*styles*`**: Alist mapping style keywords to ANSI codes
- **`*fg-colors*`**: Alist mapping foreground color keywords to codes
- **`*bg-colors*`**: Alist mapping background color keywords to codes

### Internal Functions
- **`print-code`** `(code-cell stream)`: Emit an ANSI code to stream
  - Handles both named color cells (alist) and integer colors (256-palette)
- **`find-code`** `(key key-name)`: Macro for looking up a key in the appropriate table
  - Returns `(cons key-name cell)` for named colors or `(cons key-name key)` for integers
- **`format-to-string`** `(args bg fg st)` → string: Internal helper to collect output in a string
- **`print-ansi`** `(key value stream)`: Emit a single ANSI code for a given key-value pair

### Core Dispatch Logic
- **`format-ansi` behavior:**
  1. If `stream` is NIL, delegate to `format-to-string` (accumulate in string buffer)
  2. Parse optional outer styles (`bg`, `fg`, `st`)
  3. Emit outer style codes
  4. Dispatch on `args`:
     - If string: emit it via `format` (supports format control strings)
     - If list: iterate entries; for each, handle as either a string or a style-list
  5. Emit reset code

## Boundary

**Allowed dependencies:**
- CL (core Lisp): `cl:format`, `cl:make-string-output-stream`, `cl:get-output-stream-string`, etc.
- UIOP (utilities): `uiop:define-package`

**Forbidden reaches:**
- No external libraries (intentional design constraint)
- No I/O beyond streams passed by caller

**Invariants:**
- ANSI sequences are only emitted when `*enabled*` is T (callers may see no codes if disabled)
- Type checking via `ansi-entry?` is performed eagerly on list-based calls
- All ANSI codes are precomputed; no algorithmic generation at runtime
