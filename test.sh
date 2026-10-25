#!/bin/bash

sbcl --noinform --non-interactive \
  --load init.lisp \
  --load format-ansi.asd \
  --eval '(asdf:test-system "format-ansi")' \
  --eval '(uiop:quit)'
