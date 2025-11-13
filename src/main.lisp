(uiop:define-package #:format-ansi
  (:use #:cl)
  (:export #:format-ansi
           #:ansi-color
           #:?ansi-color
           #:ansi-style
           #:?ansi-style
           #:+reset-all+)
  (:nicknames #:ansi)
  (:documentation "Basic functionality to format text with ANSI colors and styles."))

(in-package #:format-ansi)


;; Reference: https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797

(defparameter *styles*
  '((:BOLD         . 1)
    (:DIM          . 2)
    (:ITALIC       . 3)
    (:UNDERLINE    . 4)
    (:BLINK        . 5)
    (:NEGATIVE     . 7)
    (:HIDDEN       . 8)
    (:CROSS-OUT    . 9)
    (:NORMAL       . 22)
    (:NO-UNDERLINE . 24)
    (:POSITIVE     . 27)
    (:VISIBLE      . 28)
    (:NO-CROSS-OUT . 29)))

(defparameter *fg-colors*
  '((:BLACK   . 30)
    (:RED     . 31)
    (:GREEN   . 32)
    (:YELLOW  . 33)
    (:BLUE    . 34)
    (:MAGENTA . 35)
    (:CYAN    . 36)
    (:WHITE   . 37)
    (:RESET   . 39)))

(defparameter *bg-colors*
  '((:BLACK   . 40)
    (:RED     . 41)
    (:GREEN   . 42)
    (:YELLOW  . 43)
    (:BLUE    . 44)
    (:MAGENTA . 45)
    (:CYAN    . 46)
    (:WHITE   . 47)
    (:RESET   . 49)))

(deftype ansi-color ()
  "The valid ANSI-COLORS."
  `(member :BLACK :RED :GREEN :YELLOW :BLUE :MAGENTA :CYAN :WHITE :RESET))

(deftype ?ansi-color ()
  "Optional ANSI-COLOR."
  `(or null ansi-color))

(deftype ansi-style ()
  "The valid ANSI-STYLES."
  `(member :BOLD :DIM :ITALIC :UNDERLINE :BLINK :NEGATIVE :HIDDEN :CROSS-OUT :NORMAL :NO-UNDERLINE :POSITIVE :VISIBLE :NO-CROSS-OUT))

(deftype ?ansi-style ()
  "Optional ANSI-STYLE."
  `(or null ansi-style))

(defconstant +reset-all+ (intern (concatenate 'string '(#\ESC) "[0m")))

(defmacro find-code (key items)
  (let ((key-name (symbol-name key))
        (cell (gensym)))
    `(let ((,cell (assoc ,key ,items)))
       (if ,cell
           (cdr ,cell)
           (error "not a valid ~A: ~A" ,key-name ,key)))))

(declaim (ftype (function (T string &rest T) (or string null)) %format))
(defun %format (destination control-string &rest format-arguments)
  "Wrap CL:FORMAT to be able to mock this function in tests."
  (apply #'format destination control-string format-arguments))

(declaim (ftype (function (T string &key
                             (:bg ?ansi-color)
                             (:fg ?ansi-color)
                             (:st ?ansi-style))
                          (or string null)) format-ansi))
(defun format-ansi (stream text &key bg fg st)
  "Format some TEXT using ANSI-COLOR and ANSI-STYLE.
   STREAM can be anything accepted by CL:FORMAT.
   BG is the background color.
   FG is the foreground color.
   ST is the ANSI-STYLE.

   If no keyword argument is provided, TEXT is returned unchanged.
   Otherwise, the returned value is the same as CL:FORMAT would return given
   the STREAM as argument.

   Note: TEXT is passed to CL:FORMAT as an argument, not as part of the FORMAT string.
   "
  (let ((bg-code (when bg (find-code bg *bg-colors*)))
        (fg-code (when fg (find-code fg *fg-colors*)))
        (st-code (when st (find-code st *styles*))))
    (cond
      ((and bg-code fg-code st-code)
       (%format stream "~A[~A;~A;~Am~A~A" #\ESC bg-code fg-code st-code text +reset-all+))
      ((and bg-code fg-code)
       (%format stream "~A[~A;~Am~A~A" #\ESC bg-code fg-code text +reset-all+))
      ((and bg-code st-code)
       (%format stream "~A[~A;~Am~A~A" #\ESC bg-code st-code text +reset-all+))
      ((and fg-code st-code)
       (%format stream "~A[~A;~Am~A~A" #\ESC fg-code st-code text +reset-all+))
      (bg-code
       (%format stream "~A[~Am~A~A" #\ESC bg-code text +reset-all+))
      (fg-code
       (%format stream "~A[~Am~A~A" #\ESC fg-code text +reset-all+))
      (st-code
       (%format stream "~A[~Am~A~A" #\ESC st-code text +reset-all+))
      ('otherwise text))))
