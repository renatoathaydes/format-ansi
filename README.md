# Format-Ansi

Basic functionality to format text with ANSI colors and styles.

This library is focused on performance and usability.
It provides an API similar to `CL:FORMAT` which allows for efficient output and is easy to remember.

## Usage

* Basic string argument, setting background, foreground and style:

```lisp
(ansi:format-ansi T "Example"
                  :bg :blue
                  :fg :yellow 
                  :st :bold)
```

![Blue background with yellow foreground, bold](docs/images/bg_blue_fg_yellow.jpg)

* List of arguments, each with its own style:

```lisp
(ansi:format-ansi T '((:bg :magenta "HELLO") (:fg :red "BYE!")))
```

![Magenta background, white foreground, red background](docs/images/bg_mag_fg_white_bg_red.jpg)

Notice that the string inside each list is a `CONTROL-STRING`, so it may be followed by arguments
just like in `CL:FORMAT`:

```lisp
(ansi:format-ansi T `((:bg :magenta "HELLO ~A" ,name)))
```

* Both list of arguments with styles and _outer_ styles:

```lisp
(ansi:format-ansi T '((:st :bold "HELLO") " there") :bg :green)
```

![Green background, bold](docs/images/bg_green_fg_white_bold.jpg)

> To disable colors and styles, use `format-ansi:*enable*`.
> For example, to disable it in the REPL, use
> `(setf format-ansi:*enabled* (not uiop:*lisp-interaction*))`.

To see all available named colors and styles, run:

```lisp
CL-USER> (mapcar #'(lambda (e) (car e))
                 ansi::*bg-colors*)
(:BLACK :RED :GREEN :YELLOW :BLUE :MAGENTA :CYAN :WHITE :BBLACK :BRED :BGREEN
 :BYELLOW :BBLUE :BMAGENTA :BCYAN :BWHITE :RESET)
CL-USER> (mapcar #'(lambda (e) (car e))
                 ansi::*styles*)
(:BOLD :DIM :ITALIC :UNDERLINE :BLINK :NEGATIVE :HIDDEN :CROSS-OUT :NORMAL
 :NO-UNDERLINE :POSITIVE :VISIBLE :NO-CROSS-OUT)
```

> Bright colors have a `B` prefixed to their names. Hence,
  `BBLACK` means _bright black_ (otherwise known as _gray_), `BRED` means _bright red_
  and so on.

* some samples from [example.lisp](example.lisp) as seen on eshell:

![Example showing many colors and styles](docs/images/example.jpg)

## 256 colors

Besides named colors, format-ansi also supports 256-integer colors:

```lisp
(ansi:format-ansi T "256 colors!" :bg 226 :fg 196)
```

![Example output with 256-int colors](docs/images/simple-256-colors.png)

Here's how to print all the integer colors:

```lisp
(format-ansi T "All 256-integer colors:~%" :st :italic)

(loop for c from 0 to 255
      do (format-ansi T (format nil "~8:@<~A~>" c)
                      :bg c
                      :fg (- 255 c))
         (when (zerop (mod (1+ c) 8)) (newline)))
```

Output (on MacOS Terminal):

![256 colors shown on MacOS Terminal](docs/images/256-colors.png)

## format-ansi function type

Function type as displayed by `company-documentation` in emacs:

![format-ansi documentation in emacs](docs/images/format-ansi-docs.png)

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

Run from the REPL:

```lisp
;; load
(ql:quickload "format-ansi/tests")

;; run all tests
(parachute:test :format-ansi/tests)

;; run individual test
(parachute:test 'format-ansi/tests::no-args)
```
