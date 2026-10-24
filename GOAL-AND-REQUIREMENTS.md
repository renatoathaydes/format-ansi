---
id: format-ansi-goals
type: goal-and-requirements
title: format-ansi — ANSI text formatting library
status: active
---

# Goal & Requirements

## Objective

Provide a performant, usable Common Lisp library for formatting terminal output with ANSI color codes and text styles. The API mirrors CL:FORMAT, making it intuitive for Lispers.

## Target Use

Developers writing Common Lisp CLI tools, REPLs, and interactive applications who need styled terminal output.

## Key Capabilities

- **16 named colors** (both foreground and background): `:BLACK`, `:RED`, `:GREEN`, `:YELLOW`, `:BLUE`, `:MAGENTA`, `:CYAN`, `:WHITE` and their bright variants (prefixed with `B`, e.g., `:BRED`), plus `:RESET`
- **256-color palette** (integer colors 0–255) for both foreground and background
- **Text styles**: `:BOLD`, `:DIM`, `:ITALIC`, `:UNDERLINE`, `:BLINK`, `:NEGATIVE`, `:HIDDEN`, `:CROSS-OUT`, and their reset variants (`:NORMAL`, `:NO-UNDERLINE`, `:POSITIVE`, `:VISIBLE`, `:NO-CROSS-OUT`)
- **Flexible formatting API**:
  - Single string with outer styles (`bg`, `fg`, `st` parameters)
  - List of styled entries (each with its own color/style + format control string)
  - Combining both: list entries plus outer styles
- **Global enable/disable** via `*enabled*` parameter (useful for disabling colors in non-interactive contexts)
- **No runtime dependencies** — minimal, self-contained implementation

## Non-Goals

- Support for truecolor (24-bit RGB ANSI codes)
- Complex layout or text wrapping beyond CL:FORMAT's capabilities
- Automatic color selection or semantic coloring (caller's responsibility)

## Architecture Decision: Zero Dependencies

The library intentionally has no external dependencies to maximize portability and minimize footprint. All styling information is hardcoded as lookup tables.

## Known Limitations

- Performance optimizations assume a single-threaded context (the `*enabled*` parameter is not thread-safe)
- Current build/test scripts use SBCL; other Common Lisp implementations have not been formally tested in CI, but the library is designed to be portable across all ANSI Common Lisp implementations
