(import '(asdf:defsystem asdf:test-op))

(defsystem "format-ansi"
  :version "0.0.1"
  :author "Renato Athaydes"
  :license "GPL"
  :depends-on ()
  :pathname "src"
  :components ((:file "main"))
  :description "Basic functionality to format text with ANSI colors and styles.
   This library is focused on performance, hence it avoids allocating memory.
   It provides an API similar to CL:FORMAT,
   which allows for efficient output."
  :in-order-to ((test-op (test-op "format-ansi/tests"))))

(defsystem "format-ansi/tests"
  :author "Renato Athaydes"
  :license "GPL"
  :depends-on ("format-ansi" "parachute")
  :pathname "tests"
  :components ((:file "package")
               (:file "test-helpers" :depends-on ("package"))
               (:file "main" :depends-on ("test-helpers" "package")))
  :description "Test system for format-ansi"
  :perform (test-op (op c) (uiop:symbol-call :parachute :test :format-ansi/tests)))
