(require "uiop")
(load "src/main")
(import '(ansi:format-ansi ansi::*bg-colors* ansi::*fg-colors*))

(defun newline () (format T "~%"))

;; each entry may contain styles within it, or be just plain text
(format-ansi T `((:st :bold "FORMAT-ANSI ") " Examples:"))
(newline)
;; Using only "global" styles, i.e. styles that apply to all entries
;; Notice how the first string is used as CONTROL-STRING, as with CL:FORMAT.
(format-ansi T '(("~A background, ~A foreground." :yellow :red)) :bg :yellow :fg :red)
(newline)
;; this example mixes global styles with per-entry styles
(format-ansi T '((:st :underline "Blue") " background, "
                 (:st :bold "Magenta") " foreground.")
             :bg :blue :fg :magenta)
(newline)

(format-ansi T "A checkers pattern:" :st :italic)
(newline)
(loop for i from 0 to 10
      do (loop for j from 0 to 10
               for flag = (evenp i) then (not flag)
               do (format-ansi T '("  ") :bg (if flag :white :black)))
         (newline))
(newline)

(format-ansi T "All BASIC colors:" :st :italic)
(newline)
(let ((index 0)
      (words #("FORMAT" "-ANSI" "!!!!")))
  (dolist (bg-color *bg-colors*)
    (dolist (fg-color *fg-colors*)
      (let ((text (aref words (mod index (length words)))))
        (declare (type string text))
        (format-ansi T text
                     :bg (car bg-color)
                     :fg (car fg-color))
        (setf index (1+ index))))
    (newline)))
(newline)

(format-ansi T "All 256-integer colors:" :st :italic)
(newline)
(loop for c from 0 to 255
      do (format-ansi T (format nil "~8:@<~A~>" c)
                      :bg c
                      :fg (- 255 c))
         (when (zerop (mod (1+ c) 8)) (newline)))

(newline)

