(in-package :format-ansi/tests)

(declaim (optimize (debug 3)))

(defmacro expected-str (&rest text-parts)
  `(progn
     (conc-str +reset-all+ ,@text-parts +reset-all+)))

(define-test no-args
    (is equal
        (expected-str "hi")
        (format-ansi nil '(("hi")))))

(define-test raw-string-arg
    (is equal
        (expected-str "hello")
        (format-ansi nil "hello")))

(define-test string-list-arg
    (is equal
        (expected-str "hello")
        (format-ansi nil '("hello"))))

(define-test style-only
  (is equal
      (expected-str #\ESC "[1mhello")
      (format-ansi nil '(("hello")) :st :bold)))

(define-test bg-color-only
  (is equal
      (expected-str #\ESC "[41mhi there")
      (format-ansi nil '(("hi there")) :bg :red)))

(define-test fg-color-only
  (is equal
      (expected-str #\ESC "[31mhi there")
      (format-ansi nil '("hi there") :fg :red)))

(define-test bg-fg-colors
  (is equal
      (expected-str #\ESC "[40m" #\ESC "[32mfoo;bar")
      (format-ansi nil '("foo;bar") :bg :black :fg :green)))

(define-test bg-st-colors
  (is equal
      (expected-str #\ESC "[43m" #\ESC "[2mfoo;bar")
      (format-ansi nil '("foo;bar") :bg :yellow :st :dim)))

(define-test fg-st-colors
  (is equal
      (expected-str #\ESC "[33m" #\ESC "[3mfoo;bar")
      (format-ansi nil '("foo;bar") :fg :yellow :st :italic)))

(define-test st-bg-fg-colors
  (is equal
      (expected-str #\ESC "[44m" #\ESC "[35m" #\ESC "[4mfoo;bar")
      (format-ansi nil '("foo;bar") :st :underline :bg :blue :fg :magenta)))

;; (define-test stream-arg-passed-to-format-as-is
;;   (let ((captured-args (mocking-format (format-args)
;;                          (format-ansi T "hello" :st :visible)
;;                          format-args)))
;;     (is equalp (list T "~A[~Am~A~A" (list #\ESC 28 "hello" +reset-all+)) captured-args)))
