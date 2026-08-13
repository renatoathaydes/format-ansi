(in-package :format-ansi/tests)

(defun conc-str (&rest args)
  (flet ((tostr (v)
           (etypecase v
             (string v)
             (character (vector v)))))
    (apply #'concatenate 'string (mapcar #'tostr args))))

(defmacro expected-str (&rest text-parts)
  `(progn
     (conc-str +reset-all+ ,@text-parts +reset-all+)))
