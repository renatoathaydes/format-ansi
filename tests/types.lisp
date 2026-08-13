(in-package :format-ansi/tests)

(defsuite type-checking ())

(deftest ansi-entry-ok (type-checking)
  (assert-true (ansi-entry? ""))
  (assert-true (ansi-entry? '("")))
  (assert-true (ansi-entry? '(:fg :red "")))
  (assert-true (ansi-entry? '(:bg :red "")))
  (assert-true (ansi-entry? '(:st :bold "")))
  (assert-true (ansi-entry? '(:st :bold :fg :blue "with arg: ~A" 1)))
  (assert-true (ansi-entry? '("with args: ~A + ~A" "foo" #\B))))

(deftest ansi-entry-not-ok (type-checking)
  (assert-false (ansi-entry? nil))
  (assert-false (ansi-entry? '(:fg)))
  (assert-false (ansi-entry? '(:fg :red)))
  (assert-false (ansi-entry? '(:fg :bold "")))
  (assert-false (ansi-entry? '(:st :red ""))))

(deftest ansi-entries-ok (type-checking)
  (assert-true (ansi-entries? nil))
  (assert-true (ansi-entries? '((""))))
  (assert-true (ansi-entries? '((:fg :red "")))))

(deftest ansi-entries-not-ok (type-checking)
  (assert-false (ansi-entries? 1))
  (assert-false (ansi-entries? ""))
  (assert-false (ansi-entries? '("" :fg :red))))
