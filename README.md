# Format-Ansi

Basic functionality to format text with ANSI colors and styles.

This library is focused on performance, hence it avoids allocating memory.
It provides an API similar to `CL:FORMAT`, which allows for efficient output.

## Usage

```lisp
(ansi:format-ansi T "Example" 
    :bg-color :blue
    :fg-color :yellow 
    :style :bold)
```

To see all colors and styles, run:

```lisp
CL-USER> (mapcar #'(lambda (e) (car e))
                 ansi::*bg-colors*)
(:BLACK :RED :GREEN :YELLOW :BLUE :MAGENTA :CYAN :WHITE :RESET)
CL-USER> (mapcar #'(lambda (e) (car e))
                 ansi::*styles*)
(:BOLD :DIM :ITALIC :UNDERLINE :BLINK :NEGATIVE :HIDDEN :CROSS-OUT :NORMAL
 :NO-UNDERLINE :POSITIVE :VISIBLE :NO-CROSS-OUT)
```

## Installation

Load the ASD file, then run `(ql:quickload "format-ansi")`.

## Status

Early development. It works but I hope to make `format-ansi` work just like `format`, but with arguments optionally annotated with decorations, like this:

```lisp
(ansi:format-ansi T "hello ~A" '("Joe" :bg-color :blue :style :italic))
```
