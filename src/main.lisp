(uiop:define-package #:format-ansi
  (:use #:cl)
  (:export #:format-ansi
           #:ansi-color
           #:?ansi-color
           #:ansi-style
           #:?ansi-style
           #:ansi-entry?
           #:ansi-entries?
           #:ansi-entry-list
           #:ansi-key
           #:ansi-color-key
           #:+reset-all+)
  (:nicknames #:ansi)
  (:documentation "Basic functionality to format text with ANSI colors and styles."))

(in-package #:format-ansi)


#+development
(declaim (optimize (debug 3) (safety 3) (speed 0)))


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
  '((:BLACK    . 30)
    (:RED      . 31)
    (:GREEN    . 32)
    (:YELLOW   . 33)
    (:BLUE     . 34)
    (:MAGENTA  . 35)
    (:CYAN     . 36)
    (:WHITE    . 37)
    (:BBLACK   . 90)
    (:BRED     . 91)
    (:BGREEN   . 92)
    (:BYELLOW  . 93)
    (:BBLUE    . 94)
    (:BMAGENTA . 95)
    (:BCYAN    . 96)
    (:BWHITE   . 97)
    (:RESET    . 39)))

(defparameter *bg-colors*
  '((:BLACK    . 40)
    (:RED      . 41)
    (:GREEN    . 42)
    (:YELLOW   . 43)
    (:BLUE     . 44)
    (:MAGENTA  . 45)
    (:CYAN     . 46)
    (:WHITE    . 47)
    (:BBLACK   . 100)
    (:BRED     . 101)
    (:BGREEN   . 102)
    (:BYELLOW  . 103)
    (:BBLUE    . 104)
    (:BMAGENTA . 105)
    (:BCYAN    . 106)
    (:BWHITE   . 107)
    (:RESET    . 49)))

(deftype ansi-color ()
  "The valid ANSI-COLORS."
  `(or (integer 0 255) (member
                        :BLACK :RED :GREEN :YELLOW :BLUE :MAGENTA :CYAN :WHITE :RESET
                        :BBLACK :BRED :BGREEN :BYELLOW :BBLUE :BMAGENTA :BCYAN :BWHITE)))

(deftype ?ansi-color ()
  "Optional ANSI-COLOR."
  `(or null ansi-color))

(deftype ansi-style ()
  "The valid ANSI-STYLES."
  `(member :BOLD :DIM :ITALIC :UNDERLINE :BLINK :NEGATIVE :HIDDEN :CROSS-OUT
           :NORMAL :NO-UNDERLINE :POSITIVE :VISIBLE :NO-CROSS-OUT))

(deftype ?ansi-style ()
  "Optional ANSI-STYLE."
  `(or null ansi-style))

(deftype ansi-key ()
  "Type of keys in items of ANSI-ENTRY-LIST."
  `(member :fg :bg :st))

(deftype ansi-color-key ()
  "Type of keys for ANSI-COLOR in ANSI-ENTRY-LIST."
  `(member :fg :bg))

(defun ansi-entry? (entry)
  "Returns T if ENTRY is an ANSI-ENTRY, NIL otherwise.
  See ANSI-ENTRY-LIST for details about what is an ANSI-ENTRY."
  (typecase entry
    (list   (loop for rem on entry
                  do (typecase (car rem)
                       ;; STRING followed by anything is ok
                       (string (return T))
                       (ansi-color-key ; check and skip next entry, or fail
                        (typecase (second rem)
                          (ansi-color (setq rem (cdr rem)))
                          (otherwise (return nil))))
                       (ansi-key ; same as previous, but must be style here
                        (typecase (second rem)
                          (ansi-style (setq rem (cdr rem)))
                          (otherwise (return nil)))))))
    (string T)))

(defun ansi-entries? (lst)
  "Function that checks if LST satisfies type ANSI-ENTRY-LIST."
  (and (listp lst)
       (every #'ansi-entry? lst)))

(deftype ansi-entry-list ()
  "A list of ANSI entries.
 Each member of the LIST must satisfy one of the following conditions:
     * it is a STRING.
     * it is a LIST matching the following conditions:
         - it contains a STRING followed by any number of items.
         - it contains pairs of ANSI-COLOR-KEY -> ANSI-COLOR or
           :ST -> ANSI-STYLE items, then a STRING followed by any number of items."
  `(satisfies ansi-entries?))

(defparameter +reset-all+ (concatenate 'string '(#\ESC) "[0m"))

(declaim (ftype (function (cons T)) print-code))
(defun print-code (code-cell stream)
  (let ((key (car code-cell))
        (val (cdr code-cell)))
    (etypecase val
      ;; case where VAL is a CELL from the tables above.
      (cons (let ((code (cdr val)))
              (check-type code integer)
              (format stream "~A[~Am" #\ESC code)))
      ;; if integer, it's a color from 0 to 255,
      ;; printed as ESC[48;5;{ID}m for BG, or ESC[38;5;{ID}m for FG.
      (integer (let ((code (ecase key
                             (:bg 48)
                             (:fg 38))))
                 (format stream "~A[~A;5;~Am" #\ESC code val))))))

(defmacro find-code (key key-name)
  "If KEY is INTEGER and KEY-NAME is of type ANSI-COLOR-KEY,
   return (CONS KEY-NAME KEY) (where KEY is a 0-255 color).
   Otherwise, find KEY in the appropriate ALIST (of colors or styles).
   Returns the cell corresponding to the KEY in (CONS KEY-NAME CELL).
   If not found, an error is raised."
  (let ((cell (gensym))
        (items (gensym)))
    `(typecase ,key
       (integer
        (unless (typep ,key-name 'ansi-color-key)
          (error "Expected ansi-color-key, not ~A" ,key-name))
        (cons ,key-name ,key))
       (t (let* ((,items (ecase ,key-name
                           (:bg *bg-colors*)
                           (:fg *fg-colors*)
                           (:st *styles*)))
                 (,cell (assoc ,key ,items)))
            (or (cons ,key-name ,cell)
                (error "not valid key ~A into ~A" (symbol-name ,key) ,items)))))))

(defmacro do-around (before after &body body)
  `(progn
     (,before)
     ,@body
     (,after)))

(declaim (ftype (function ((or string ansi-entry-list)
                           (?ansi-color)
                           (?ansi-color)
                           (?ansi-style))
                          (values string &optional))
                format-to-string))

(declaim (ftype (function (T (or string ansi-entry-list)
                             &key
                             (:bg ?ansi-color)
                             (:fg ?ansi-color)
                             (:st ?ansi-style))
                          (values (or string null) &optional))
                format-ansi))

(declaim (ftype (function (ansi-key (or ansi-style ansi-color) T)) print-ansi))

(defun format-ansi (stream args &key bg fg st)
  "Format text with ANSI codes.
   STREAM can be anything accepted by CL:FORMAT.
   ARGS is either a STRING or a ANSI-ENTRY-LIST.
   BG is the background color of the whole output.
   FG is the foreground color of the whole output.
   ST is the ANSI-STYLE of the whole output.

   STRINGs in an ANSI-ENTRY-LIST are used as CONTROL-STRING,
   and hence may be followed by arguments.

   Returns a STRING if STREAM is NIL, NIL otherwise.

   Example usage:
     ;; print BOLD output, 'hi ' in ITALIC, then the value of NAME
     ;; with blue background, yellow foreground.
     (format-ansi T `((:st :italic \"hi\")
                      (:bg :blue :fg :yellow ,name))
                    :st :bold)
   "
  (if (null stream)
      (format-to-string args bg fg st)
      (let ((bg-code (when bg (find-code bg :bg)))
            (fg-code (when fg (find-code fg :fg)))
            (st-code (when st (find-code st :st))))
        (flet ((print-outer ()
                 (when bg-code (print-code bg-code stream))
                 (when fg-code (print-code fg-code stream))
                 (when st-code (print-code st-code stream)))
               (reset-all ()
                 (princ +reset-all+ stream)))
          (reset-all)
          (etypecase args
            (string
             (do-around print-outer reset-all
               (princ args stream)))
            (list (dolist (entry args)
                    (do-around print-outer reset-all
                      (etypecase entry
                        (string (format stream entry))
                        (list (loop for rem on entry
                                    do (etypecase (car rem)
                                         (string ; STRING followed by anything ends iteration
                                          (apply #'format stream rem)
                                          (return))
                                         (ansi-key ; use the KEY-VALUE and skip VALUE next iteration
                                          (print-ansi (car rem) (second rem) stream)
                                          (setq rem (cdr rem)))))))))))
          nil))))

(defun print-ansi (key value stream)
  "Prints an ANSI code."
  (print-code (find-code value key) stream))

(defun format-to-string (args bg fg st)
  (let ((s (make-string-output-stream)))
    (format-ansi s args :bg bg :fg fg :st st)
    (get-output-stream-string s)))
