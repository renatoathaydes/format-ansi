(in-package :format-ansi/tests)

(defmacro with-temporary-function ((name new-fn) &body body)
  `(let ((old (fdefinition ,name)))
     (unwind-protect
          (progn
            (setf (fdefinition ,name) ,new-fn)
            ,@body)
       (setf (fdefinition ,name) old))))

(defmacro mocking-format ((captured-args) &body body)
  `(let ((,captured-args nil))
     (with-temporary-function
         ('format-ansi::%format
          (lambda (destination control-string &rest format-arguments)
            (setf ,captured-args (list destination control-string format-arguments))))
       ,@body)))


(defun conc-str (&rest args)
  (flet ((tostr (v)
           (etypecase v
             (string v)
             (character (vector v)))))
    (apply #'concatenate 'string (mapcar #'tostr args))))
