(in-package :su-demos)


;;;; list of plans
(setf list-of-plans '(:fetch :deliver :search))


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
		(cram-talker "DONE") 
         )
         (when (eq *nlplistner-word* :FAIL)
		(cram-talker "FAIL")        
         )
         
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
	(setf *objectname* (intern (string-upcase (substitute #\- #\space (aref *test* 1))) :keyword))
	(setf *objecttype* (intern (string-upcase (aref *test* 2)) :keyword))
	(setf *personname* (intern (string-upcase (aref *test* 3)) :keyword))
	(setf *persontype* (intern (string-upcase (aref *test* 4)) :keyword))
	(setf *attribute* (intern (string-upcase (substitute #\- #\space (aref *test* 5))) :keyword))
	(setf *personaction* (intern (string-upcase (substitute #\- #\space (aref *test* 6))) :keyword))
	(setf *color* (intern (string-upcase (aref *test* 7)) :keyword))
	(setf *number* (intern (string-upcase (aref *test* 8)) :keyword))
	(setf *location1* (intern (string-upcase (substitute #\- #\space (aref *test* 9))) :keyword))
	(setf *location2* (intern (string-upcase (substitute #\- #\space (aref *test* 10))) :keyword))
	(setf *room1* (intern (string-upcase (substitute #\- #\space (aref *test* 11))) :keyword))
	(setf *room2* (intern (string-upcase (substitute #\- #\space (aref *test* 12))) :keyword))
	(cram-talker "plan")
	(dolist (?plan-type list-of-plans) ;;; find plans if it is present in the list or not (list of plans declared above)
        (when (eq ?plan-type *plan*)  ;;; TO DO Add condiation... if plan is not there in the list
          (print "plan found...")
          (sleep 1)
          ;;;; buffer knowledge
          (if (not (eq *objectname* :it))  ;;;; for buffer knowledege of previous object
			(setf *previous-object* *objectname*))
   ;;;;; Actions
   (su-real:with-hsr-process-modules
		; (when (eq *plan* :SEARCH)
		 ;	(print "Performing searching ...")
			;(setf ?output (finding-object (object-to-be *objectname*) *location1*)) ;; *objectname* = get-object-cram-name(?nlp-object-name)
			;(print "searching Plan Done ...")
			;(cram-talker ?output)
			;)
		 
		 (when (eq *plan* :search)
		 	(print "Performing searching ...")
			(setf ?output (searching-object (object-to-be *objectname*))) ;; *objectname* = get-object-cram-name(?nlp-object-name)
			(print "searching Plan Done ...")
			(cram-talker ?output)
			)
		 
		 (when (eq *plan* :FETCH)
		 	(print "Performing fetching ...")
			(setf ?output (fetching-object (object-to-be *objectname*) *location1*)) ;; *objectname* = get-object-cram-name(?nlp-object-name)
			(print "Fetching Plan Done ...")
			(cram-talker ?output)
			)

		 (when (eq *plan* :DELIVER)
		 	(print "Performing delivering ...")
			(setf ?output (delivering-object (object-to-be *objectname*) *location1*))
			(print "Delivering Plan Done ...")
			(cram-talker ?output)
			)
			(print *previous-object*)
			
	
	 )
	 ))
))




