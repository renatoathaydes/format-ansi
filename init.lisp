(require "asdf")

#-ocicl
(let ((runtime
        (merge-pathnames
         (if (uiop:os-windows-p)
             #p"AppData/Local/ocicl/ocicl-runtime.lisp"
             #p".local/share/ocicl/ocicl-runtime.lisp")
         (user-homedir-pathname))))
  (when (probe-file runtime)
    (load runtime)))

;; Fall back to Quicklisp if OCICL failed to load
(unless (member :ocicl *features*)
  (let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
    (when (probe-file quicklisp-init)
      (load quicklisp-init))))

(asdf:initialize-source-registry
  (list :source-registry
        (list :directory (uiop:getcwd))
        :inherit-configuration))
