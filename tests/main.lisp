x(in-package :format-ansi/tests)

(declaim (optimize (debug 3)))

(define-test no-args
  (is equal "hi" (format-ansi nil "hi")))

(define-test style-only
  (is equal
      (conc-str #\ESC "[1mhello" #\ESC "[0m")
      (format-ansi nil "hello" :style :bold)))

(define-test bg-color-only
  (is equal
      (conc-str #\ESC "[41mhi there" #\ESC "[0m")
      (format-ansi nil "hi there" :bg-color :red)))

(define-test fg-color-only
  (is equal
      (conc-str #\ESC "[31mhi there" #\ESC "[0m")
      (format-ansi nil "hi there" :fg-color :red)))

(define-test bg-fg-colors
  (is equal
      (conc-str #\ESC "[40;32mfoo;bar" #\ESC "[0m")
      (format-ansi nil "foo;bar" :bg-color :black :fg-color :green)))

(define-test bg-st-colors
  (is equal
      (conc-str #\ESC "[43;2mfoo;bar" #\ESC "[0m")
      (format-ansi nil "foo;bar" :bg-color :yellow :style :dim)))

(define-test fg-st-colors
  (is equal
      (conc-str #\ESC "[33;3mfoo;bar" #\ESC "[0m")
      (format-ansi nil "foo;bar" :fg-color :yellow :style :italic)))

(define-test st-bg-fg-colors
  (is equal
      (conc-str #\ESC "[44;35;4mfoo;bar" #\ESC "[0m")
      (format-ansi nil "foo;bar" :style :underline :bg-color :blue :fg-color :magenta)))

(define-test stream-arg-passed-to-format-as-is
  (let ((captured-args (mocking-format (format-args)
                         (format-ansi T "hello" :style :visible)
                         format-args)))
    (is equalp (list T "~A[~Am~A~A" (list #\ESC 28 "hello" +reset-all+)) captured-args)))
