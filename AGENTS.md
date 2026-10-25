# Agent guide

## Project essentials

Format-Ansi is a Common Lisp library for ANSI colors and styles, focused on
performance and a `CL:FORMAT`-like API. The package is `format-ansi` (nickname `ansi`).

- `src/main.lisp`: library implementation; no runtime library dependencies.
- `format-ansi.asd`: ASDF definitions for the library and test systems.
- `tests/`: automated tests using `cl-lustre-tests`.
- `README.md` and `example.lisp`: usage documentation and examples.

## Spec graph

Start with [goals and requirements](GOAL-AND-REQUIREMENTS.md),
[architecture](docs/ARCHITECTURE.md), and the [main module spec](src/SPEC.md).

Treat the project's spec graph as authoritative for requirements, architecture,
and behavioral contracts. Consult the relevant specs before changing behavior;
update the owning specs when changing a documented contract or decision. Keep
that detail in the specs rather than duplicating it here.

Use `spec_grep`, `spec_get`, and `spec_graph` when available, or read the spec
Markdown files directly. If the specs are missing from the checkout, flag that
rather than assuming their contents.

## Build and test

Run from the repository root with SBCL and OCICL or Quicklisp installed.
`init.lisp` loads the OCICL runtime when available, falling back to Quicklisp:

- `./build.sh`: compile with development diagnostics enabled.
- `./test.sh`: load the test dependencies and run the ASDF test suite.

Keep library changes portable across ANSI Common Lisp implementations.
