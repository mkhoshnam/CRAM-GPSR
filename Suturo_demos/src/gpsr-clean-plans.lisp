(in-package :su-demos)

(defun test-perception ()
  (su-real:with-hsr-process-modules
    (exe:perform
     (desig:an action
               (type detecting)
               (object (desig:an object
                                 (type :cerealbox)))))))
