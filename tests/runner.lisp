(in-package :format-ansi/tests)

(declaim (optimize (debug 3)))

(defun run-tests ()
  (setf clunit:*clunit-report-format* :tap)
  (clunit:run-all-suites :report-progress nil))
