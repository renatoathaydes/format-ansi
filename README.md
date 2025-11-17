# Format-Ansi

Basic functionality to format text with ANSI colors and styles.

This library is focused on performance, hence it avoids allocating memory.
It provides an API similar to `CL:FORMAT`, which allows for efficient output.

## Usage

* Basic string argument, set background, foreground and style:

```lisp
(ansi:format-ansi T "Example"
                  :bg :blue
                  :fg :yellow 
                  :st :bold)
```

![Blue background with yellow foreground, bold](docs/images/bg_blue_fg_yellow.jpg)

* List of arguments, each with own style:

```lisp
(ansi:format-ansi T '((:bg :magenta "HELLO") (:fg :red "BYE!")))
```

![Magenta background, white foreground, red background](docs/images/bg_mag_fg_white_bg_red.jpg)

* Both list of arguments with styles and _outer_ styles:

```lisp
(ansi:format-ansi T '((:st :bold "HELLO") " there") :bg :green)
```

![Green background, bold](docs/images/bg_green_fg_white_bold.jpg)

To see all available colors and styles, run:

```lisp
CL-USER> (mapcar #'(lambda (e) (car e))
                 ansi::*bg-colors*)
(:BLACK :RED :GREEN :YELLOW :BLUE :MAGENTA :CYAN :WHITE :RESET)
CL-USER> (mapcar #'(lambda (e) (car e))
                 ansi::*styles*)
(:BOLD :DIM :ITALIC :UNDERLINE :BLINK :NEGATIVE :HIDDEN :CROSS-OUT :NORMAL
 :NO-UNDERLINE :POSITIVE :VISIBLE :NO-CROSS-OUT)
```

* [example.lisp](example.lisp)

![Example showing many colors and styles](docs/images/example.jpg)

## Installation

Load the ASD file, then run `(ql:quickload "format-ansi")`.

## Building and Testing

Run from a terminal:

```shell
# compile with warnings enabled
./build.sh

# run all tests
./test.sh
```

From REPL:

```lisp
;; load
(ql:quickload "format-ansi/tests")

;; run all tests
(parachute:test :format-ansi/tests)

;; run individual test
(parachute:test 'format-ansi/tests::no-args)
```
