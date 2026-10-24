#!/bin/bash

sbcl --noinform --non-interactive \
  --eval '(require "quicklisp")' \
  --eval '(require "asdf")' \
  --eval '(load "format-ansi.asd")' \
  --eval '(ql:quickload "format-ansi/tests" :silent t)' \
  --eval '(asdf:test-system "format-ansi")' \
  --eval '(uiop:quit)'
