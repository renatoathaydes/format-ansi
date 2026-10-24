#!/usr/bin/env sbcl --script

(require 'asdf)

;; Add local paths to ASDF source registry
(asdf:initialize-source-registry
 '(:source-registry
   (:directory "/Users/renatoathaydes/programming/projects/")
   :inherit-configuration))

;; Load and test
(asdf:load-system :format-ansi/tests)
(asdf:test-system :format-ansi)
