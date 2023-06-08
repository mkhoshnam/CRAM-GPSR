(in-package :su-demos)


(defparameter *planning-node* nil)

;;Init all interface clients and start a ros node
(defun init-interfaces()


  (roslisp-utilities:startup-ros)

  (init-navigation))


(defun init-everything()
  ;; init tf buffer
  (rk::init-tf-buffer-client)
  ;; init perception client
  (rk::make-robokudo-action-client))

(roslisp-utilities:register-ros-init-function init-everything)  

(defun init-navigation()
 "Initialize only local nodes for working without the real robot."
  (roslisp:ros-info (init-interfaces) "init navigation action client")
  (init-nav-client))
