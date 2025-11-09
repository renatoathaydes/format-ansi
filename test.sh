#! /bin/sh

sbcl --script /dev/stdin <<'EOF'
#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(setq *backtrace-frame-count* 8)
(require "quicklisp")
(require "asdf")
(load "format-ansi.asd")
(ql:quickload "format-ansi/tests")
(asdf:test-system "format-ansi")
EOF
