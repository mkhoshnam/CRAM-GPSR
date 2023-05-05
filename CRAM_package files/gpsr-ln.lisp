(in-package :demo)


;;;; list of plans
(setf list-of-plans '(:fetch :deliver :search))

;;;; list of objects
(setf list-of-objects '(:bowl :spoon :cup :milk :breakfast-cereal))

  
  ;(spawn-object '((-0.9 1.8  0.9) (0 0 0 1)) :bowl 'object-1)


(defparameter *per-object* nil)
(defparameter *dialog-subscriber*  nil)

(defparameter *dialog-fluent* (cpl:make-fluent :name :dialog-fluent :value nil))

(defparameter *dialog-subscriber* nil)
(defparameter *Listner-string* nil)

(defun planlistener (topic-name)
 ; (roslisp:with-ros-node ("listener" :spin t)
    (setf *dialog-subscriber* (roslisp:subscribe topic-name "gpsr_nlp/nlpCommands" #'subscriber-callback-function))
    ;)
)
;;;;;;;;;;;;;;;;;;;;;; 27 April
(defun nlplistener (topic-name)
  ;(roslisp:with-ros-node ("listener" :spin t)
    (setf *plan-subscriber* (roslisp:subscribe topic-name "gpsr_nlp/nlpCommands" #'plan-callback-function))
    ;)
)
(defparameter *nlplistner-word* nil)
(defun plan-callback-function (message)
    
    (roslisp:with-fields (commands) message
         
         (setf *input* commands)
         (setf *nlplistner-word* (intern (string-upcase (aref *input* 0)) :keyword))
         (when (eq *nlplistner-word* :DONE)
         
         (sleep 1)
         (urdf-proj:with-simulated-robot
		(navigation-start-point)) ;;; go to the initial position 
         )
         (cram-talker "done")
         (print *nlplistner-word*)
         ))


;;;;;;;;;;;;;;;;;;;;;;;;
(defparameter *test* nil)
(defun subscriber-callback-function (message)
    (roslisp:with-fields (commands) message
      ;(print commands)
      (setf *test* commands)
	(print (length *test*))
	(setf *plan* (intern (string-upcase (aref *test* 0)) :keyword))
	(setf *objectname* (intern (string-upcase (aref *test* 1)) :keyword))
	(setf *objecttype* (intern (string-upcase (aref *test* 2)) :keyword))
	(setf *personname* (intern (string-upcase (aref *test* 3)) :keyword))
	(setf *persontype* (intern (string-upcase (aref *test* 4)) :keyword))
	(setf *attribute* (intern (string-upcase (aref *test* 5)) :keyword))
	(setf *personaction* (intern (string-upcase (aref *test* 6)) :keyword))
	(setf *color* (intern (string-upcase (aref *test* 7)) :keyword))
	(setf *number* (intern (string-upcase (aref *test* 8)) :keyword))
	(setf *location1* (intern (string-upcase (aref *test* 9)) :keyword))
	(setf *location2* (intern (string-upcase (aref *test* 10)) :keyword))
	(setf *room1* (intern (string-upcase (aref *test* 11)) :keyword))
	(setf *room2* (intern (string-upcase (aref *test* 12)) :keyword))
	(cram-talker "plan")
	(dolist (?plan-type list-of-plans) ;;; find plans if it is present in the list or not (list of plans declared above)
        (when (eq ?plan-type *plan*)
          (print "plan found...")
          (sleep 1)
          
         (urdf-proj:with-simulated-robot	
		 (when (eq *plan* :FETCH)
		 	(print "Performing fetching ...")
			(fetching-object *objectname* *location1*) 
			(print "Fetching Plan Done ...")
			(cram-talker "fetch")
			)

		 (when (eq *plan* :DELIVER)
		 	(print "Performing delivering ...")
			(delivering-object *objectname* *location1*)
			(print "Delivering Plan Done ...")
			(cram-talker "deliver")
			)
	 )))
))




