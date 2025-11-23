(in-package :format-ansi/tests)

(defmacro expected-str (&rest text-parts)
  `(progn
     (conc-str +reset-all+ ,@text-parts +reset-all+)))

(defsuite basic ())

(defsuite named-colors ())

(defsuite colors-256 ())

(deftest no-args (basic)
  "Test call with no color or style arguments."
  (assert-equalp
      (expected-str "hi")
      (format-ansi nil '(("hi")))))

(deftest raw-string-arg (basic)
  (assert-equalp
      (expected-str "hello")
      (format-ansi nil "hello")))

(deftest string-list-arg (basic)
  (assert-equalp
      (expected-str "hello")
      (format-ansi nil '("hello"))))

(deftest style-only (named-colors)
  (assert-equalp
      (expected-str #\ESC "[1mhello")
      (format-ansi nil '(("hello")) :st :bold)))

(deftest bg-color-only (named-colors)
  (assert-equalp
      (expected-str #\ESC "[41mhi there")
      (format-ansi nil '(("hi there")) :bg :red)))

(deftest fg-color-only (named-colors)
  (assert-equalp
      (expected-str #\ESC "[31mhi there")
      (format-ansi nil '("hi there") :fg :red)))

(deftest bg-fg-colors (named-colors)
  (assert-equalp
      (expected-str #\ESC "[40m" #\ESC "[32mfoo;bar")
      (format-ansi nil '("foo;bar") :bg :black :fg :green)))

(deftest bg-st-colors (named-colors)
  (assert-equalp
      (expected-str #\ESC "[43m" #\ESC "[2mfoo;bar")
      (format-ansi nil '("foo;bar") :bg :yellow :st :dim)))

(deftest fg-st-colors (named-colors)
  (assert-equalp
      (expected-str #\ESC "[33m" #\ESC "[3mfoo;bar")
      (format-ansi nil '("foo;bar") :fg :yellow :st :italic)))

(deftest st-bg-fg-colors (named-colors)
  (assert-equalp
      (expected-str #\ESC "[44m" #\ESC "[35m" #\ESC "[4mfoo;bar")
      (format-ansi nil '("foo;bar") :st :underline :bg :blue :fg :magenta)))

(deftest many-ansi-entries (named-colors)
  (assert-equalp
      (expected-str #\ESC "[22m" #\ESC "[36mhi" +reset-all+
                    #\ESC "[22m" #\ESC "[9m" #\ESC "[43mho")
      (format-ansi nil '((:fg :cyan "hi") (:st :cross-out :bg :yellow "ho")) :st :normal)))

(deftest only-ansi-entries (named-colors)
  (assert-equalp
      (expected-str #\ESC "[37m" #\ESC "[27m" #\ESC "[46mho")
      (format-ansi nil '((:fg :white :st :positive :bg :cyan "ho")))))

(deftest bg-fg-256-colors (colors-256)
  (assert-equalp
      (expected-str #\ESC "[38;5;32m" #\ESC "[48;5;64mfoo")
      (format-ansi nil '((:bg 64 "foo")) :fg 32)))
