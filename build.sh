#! /bin/sh

rm {src,tests}/*.fasl

sbcl --script /dev/stdin <<'EOF'
#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(setq *backtrace-frame-count* 8)

;; enable debug info, including warnings!
(pushnew :development *features*)

(require "quicklisp")
(require "asdf")
(load "format-ansi.asd")
(ql:quickload "format-ansi")
(asdf:make "format-ansi")
EOF
