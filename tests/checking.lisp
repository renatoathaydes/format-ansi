(defpackage p1 (:use :cl) (:export #:do-it #:keytype))
(in-package :p1)

(deftype keytype ()
  `(member :white :black nil))

(declaim (ftype (function (&key (foo keytype))) do-it))
(defun do-it (&key foo)
  (format T "key foo: ~A~%" foo))

(defpackage p2 (:use :cl :p1))
(in-package :p2)

(do-it :foo :black)

(loop for i from 0 to 2
      do (loop for j from 0 to 3
               for flag = (evenp i) then (not flag)
               do (do-it :foo (if flag :white :black))))
