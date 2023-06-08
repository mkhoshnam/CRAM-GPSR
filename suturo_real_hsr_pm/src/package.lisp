(defpackage :suturo-real-hsr-pm
  (:nicknames :su-real)
  ;;(:use #:common-lisp :roslisp :cpl)
  (:use #:common-lisp #:cram-prolog #:cram-designators #:cram-executive #:cram-giskard)
  (:export
   #:with-hsr-process-modules
   ;; Make sure that exported functions are always working and up to date
   ;; Functions that are not exported may be WIP

   #:pick-up
   #:place
   #:demo
   
))
