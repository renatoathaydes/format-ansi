#!/bin/bash

rm -f {src,tests}/*.fasl

sbcl --noinform --non-interactive \
  --load init.lisp \
  --load format-ansi.asd \
  --eval '(pushnew :development *features*)' \
  --eval '(setq *backtrace-frame-count* 8)' \
  --eval '(asdf:make "format-ansi")' \
  --eval '(uiop:quit)'
