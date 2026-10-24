(in-package :format-ansi/tests)

(lt:define-test no-args (basic)
  "Test call with no color or style arguments."
  (assert (equalp
      (expected-str "hi")
      (format-ansi nil '(("hi"))))))

(lt:define-test raw-string-arg (basic)
  (assert (equalp
      (expected-str "hello")
      (format-ansi nil "hello"))))

(lt:define-test empty-list-arg (basic)
  (assert (equalp
   "" (format-ansi nil '()))))

(lt:define-test string-list-arg (basic)
  (assert (equalp
      (expected-str "hello")
      (format-ansi nil '("hello")))))

(lt:define-test style-only (named-colors)
  (assert (equalp
      (expected-str #\ESC "[1mhello")
      (format-ansi nil '(("hello")) :st :bold))))

(lt:define-test bg-color-only (named-colors)
  (assert (equalp
      (expected-str #\ESC "[41mhi there")
      (format-ansi nil '(("hi there")) :bg :red))))

(lt:define-test fg-color-only (named-colors)
  (assert (equalp
      (expected-str #\ESC "[31mhi there")
      (format-ansi nil '("hi there") :fg :red))))

(lt:define-test bg-fg-colors (named-colors)
  (assert (equalp
      (expected-str #\ESC "[40m" #\ESC "[32mfoo;bar")
      (format-ansi nil '("foo;bar") :bg :black :fg :green))))

(lt:define-test bg-st-colors (named-colors)
  (assert (equalp
      (expected-str #\ESC "[43m" #\ESC "[2mfoo;bar")
      (format-ansi nil '("foo;bar") :bg :yellow :st :dim))))

(lt:define-test fg-st-colors (named-colors)
  (assert (equalp
      (expected-str #\ESC "[33m" #\ESC "[3mfoo;bar")
      (format-ansi nil '("foo;bar") :fg :yellow :st :italic))))

(lt:define-test st-bg-fg-colors (named-colors)
  (assert (equalp
      (expected-str #\ESC "[44m" #\ESC "[35m" #\ESC "[4mfoo;bar")
      (format-ansi nil '("foo;bar") :st :underline :bg :blue :fg :magenta))))

(lt:define-test many-ansi-entries (named-colors)
  (assert (equalp
      (expected-str #\ESC "[22m" #\ESC "[36mhi" +reset-all+
                    #\ESC "[22m" #\ESC "[9m" #\ESC "[43mho")
      (format-ansi nil '((:fg :cyan "hi") (:st :cross-out :bg :yellow "ho")) :st :normal))))

(lt:define-test only-ansi-entries (named-colors)
  (assert (equalp
      (expected-str #\ESC "[37m" #\ESC "[27m" #\ESC "[46mho")
      (format-ansi nil '((:fg :white :st :positive :bg :cyan "ho"))))))

(lt:define-test bg-fg-256-colors (colors-256)
  (assert (equalp
      (expected-str #\ESC "[38;5;32m" #\ESC "[48;5;64mfoo")
      (format-ansi nil '((:bg 64 "foo")) :fg 32))))

(lt:define-test bg-fg-256-colors-with-variable (colors-256)
  (let ((x 42))
    (assert (equalp
        (expected-str #\ESC "[38;5;32m" #\ESC "[48;5;64mx is 42")
        (format-ansi nil `((:bg 64 "x is ~A" ,x)) :fg 32)))))

(lt:define-test top-level-styles (disabled-format)
  (let ((*enabled* nil))
    (assert (equalp "hello" (format-ansi nil "hello" :fg :red :bg :yellow :st :bold)))))

(lt:define-test entries-styles (disabled-format)
  (let ((*enabled* nil))
    (assert (equalp "hello" (format-ansi nil '((:fg :red :bg :yellow :st :bold "hello")))))))
