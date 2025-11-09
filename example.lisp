(require "uiop")
(load "src/main")
(import '(ansi:format-ansi ansi::*bg-colors* ansi::*fg-colors*))

(defun newline () (format T "~%"))

(format-ansi T "Basic examples:" :style :bold)
(newline)
(format-ansi T "Yellow background, Red foreground." :bg-color :yellow :fg-color :red)
(newline)
(format-ansi T "Blue background, White foreground." :bg-color :blue :fg-color :white)
(newline)

(format-ansi T "A checkers pattern:" :style :italic)
(newline)
(loop for i from 0 to 10
      do (loop for j from 0 to 10
               for flag = (evenp i) then (not flag)
               do (format-ansi T "  " :bg-color (if flag :white :black)))
         (newline))
(newline)

(format-ansi T "All colors:" :style :italic)
(newline)
(let ((index 0)
      (words #("FORMAT" "-ANSI" "!!!!")))
  (dolist (bg-color *bg-colors*)
    (dolist (fg-color *fg-colors*)
      (let ((text (aref words (mod index (length words)))))
        (declare (type string text))
        (format-ansi T text
                   :bg-color (car bg-color)
                   :fg-color (car fg-color))
        (setf index (1+ index))))
    (newline)))
(newline)
