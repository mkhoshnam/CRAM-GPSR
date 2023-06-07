(in-package :demo)




;;;;;;;; Dependencies


;;;;;;;;;;;;;;;;;;;;;;;;; HSR PLANS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;----->>>>>>> ALL inputs must be given in the form of keywords and these keywords are resolved by the gpsr-knowledge <<<<<----------




;;; NAVIGATION (?location ?location)
;;; TODO NAVIGATION TO THE PERSON
(defun navigate-to-location(?location-nr-furt ?room) ;;; input keywords... give atleast one input and set other :nil (room or location-nr-furt) e.g (navigate-to-location :nil :kitchen) or (navigate-to-location :side-table :nil)
      ;;; get pose 
	(if (eq location-nr-furt :nil) ;;; if location of the furniture/object not given then take the room  location
	    (setf ?navigation-pose (get-navigation-pose ?room)))
	(if (eq ?room :nil) ;;;; if room is not given then take the location of the furniture/object
	    (setf ?navigation-pose (get-navigation-location-near-furniture location-nr-furt)))
	
	(cpl:with-failure-handling
	      ((common-fail:navigation-low-level-failure (e)
		 (roslisp:ros-warn (pp-plans navigate)
				   "Low-level navigation failed: ~a~%.Ignoring anyway." e)
		 (return-from navigate-to-location "fail")))    
		(let* ((?pose ?navigation-pose))
			     (exe:perform (desig:an action
						    (type going)
						    (target (desig:a location
								     (pose ?pose)))))))
	(return-from navigate-to-location "navigate"))



;;; SEARCHING-object or person  (?object ?person ?location ?location)
;; plan depends on  navigation-to-location 
(defun searching-object (?object ?person ?location-nr-furt ?room)  ;give object/person and give one location at least e.g (searching-object :bottle :nil :couch :nil) or (searching-object :nil :alex :couch :nil)
 (setf *perceived-object* nil)

;;if looking for object
(if (not (eq ?object :nil))
	(setf ?object-looking-check T) ;;(if object check is T else nil)
	(setf ?object-looking-check nil))

;;if looking for person
(if (not (eq ?person nil))
	(setf ?person-looking-check T) ;;(if person check is T else nil)
	(setf ?person-looking-check nil))


;;; go to the location
(if (and (eq ?location-nr-furt :nil) (eq ?room :nil))
	(navigate-to-location (get-specific-info-word ?object :default-location-in-room *gpsr-objects*) :nil) ;;; if no location is given get it from gpsr-knowledge where the object is supposed to be
	(navigate-to-location ?location-nr-furt ?room)) ;;;; else go to the location

;;;(call-text-to-speech-action "Trying to perceive object or person")
 (let* ((possible-look-directions `(,*forward-upward*
                                     ,*left-downward*
                                     ,*right-upward*
                                     ,*forward-downward*))
         (?looking-direction (first possible-look-directions)))
    (setf possible-look-directions (cdr possible-look-directions))
	(cpl:with-failure-handling
			  (((or common-fail:perception-object-not-found
			  	common-fail:perception-low-level-failure
			  					desig:designator-error) (e)
					 (when possible-look-directions
					 (roslisp:ros-warn  (perception-failure) "Searching messed up: ~a~%Retring by turning head..." e)
				     (setf ?looking-direction (first possible-look-directions))
				     (setf possible-look-directions (cdr possible-look-directions))
				     (exe:perform (desig:an action 
				                           (type looking)
				                           (target (desig:a location
				                                            (pose ?looking-direction)))))
				     (cpl:retry))
				     
					 (roslisp:ros-warn (pp-plans pick-up) "No more retries left..... going back ")
					 (return-from searching-object "fail")
				                
			 ))
		;;; for object
               (when (eq ?object-looking-check T)
		       (setf *perceived-object* (exe:perform (desig:an action
							       (type detecting)
							       (object (desig:an object
							       	(type ?object))))))
							       	;;(call-text-to-speech-action "Successfully perceived object")
               ) 
               
               ;;;; for person    
               (when (eq ?person-looking-check T)
               	(if (not (eq *personnname* :nil))
               		(setf ?human-name *personnname*)
               		(setf ?human-name nil))
               	(if (not (eq *personaction* :nil))
               		(setf ?human-action *personaction*)
               		(setf ?human-action nil))

		       (setf *perceived-object* (exe:perform (desig:an action
							       (type detecting)
							       (object (desig:an object
							       	(type :HUMAN)
							       	(desig:when ?human-action
							       		(location ?human-action)))))))
               )                
						       ;;(call-text-to-speech-action "Successfully perceived person")
						       (return-from searching-object "search"))))
						                   							


;;; FETCH the object (?object ?location)
;; plan depends on searching plan-->>  navigation-to-location 
(defun fetching-object (?object ?location-nr-furt ?room)

  (searching-object ?object :nil ?location-nr-furt ?room) ;;; search for the object on the furniture and save object designator in *perceived-object* 
	
	;;--->>>>> ADD pickup plan with failure handling and (searching plan save the object designator in global variable ) use  *perceived-object* to get object designator
 (roslisp:with-fields
          ((?pose
           (cram-designators::pose cram-designators:data)))
           *perceived-object*
  ;;(setf ?object-size (cl-tf2::make-3d-vector 0.05 0.05 0.2))   ;;TO-DO: espicify the object size for each different object   
		 ;;;; Failure handlers
		 (cpl:with-retry-counters ((grasp-retries 2))   
		    (cpl:with-failure-handling
			(((or common-fail:navigation-high-level-failure
			      common-fail:manipulation-low-level-failure
			      common-fail:object-unreachable
			      common-fail:navigation-low-level-failure
			      common-fail:navigation-goal-in-collision
			      CRAM-COMMON-FAILURES:GRIPPER-CLOSED-COMPLETELY
			      desig:designator-error) (e)
			   (print "I couldn't pick it up yet")
			   (roslisp:ros-warn (pp-plans pick-up)
		                   "Manipulation messed up: ~a~%Retring..."
		                   e)
		           (cpl:do-retry grasp-retries
				(cpl:retry))
			(roslisp:ros-warn (pp-plans pick-up) "No more retries left..... going back ")
			;;;; TODO add navigation plan for going back to starting point
			(return-from fetching-object "fail")))
	      
	      (exe:perform (desig:an action
		                     (type picking-up)
		                     (object-pose ?pose)
		                     (object-size ?object-size)
		                     (collision-mode :allow-all)))
		                     ))) ;;;TODO ADD parking arm
		;;;; check object in hand
		 ;;(when (prolog:prolog `(cpoe:object-in-hand ?object :right ?_ ?_))
		   ;;            (progn (print "Yes, I grasps the Object")
		    ;;                  (setf grasped-object T))
		    ;;                  (return-from fetching-object "fetch"))
					(print "fetching plan")
					 (return-from fetching-object "fetch")
)


;;;; DELIVER the object to the person/ on the location (?object ?location ?)
;; plan depends on searching plan-->>  navigation-to-location or fetching-object
;; TODO ADD person features.. currently its not person specific
(defun delivering-object (?object ?location-on-fr ?room ?person)

	(setf ?deliver-check nil)
	
	;;; check the property of the object if its pronoun or a nlp object name
	(if (eq ?object :object) 
		(setf ?object *previous-object*) ;; for pronoun get the object from buffer
		(setf ?object (object-to-be *objectname*))) ;; convert object nlp-name to cram-name
	
	
	;;; check if object is already in hand 	
	;;(when (prolog:prolog `(cpoe:object-in-hand ?object :right ?_ ?_))
	;;	               (progn (print "Yes, I have Object in hand !")
	;;	               (setf ?deliver-check T)
	;;	                     ))
	;;; if object is not in hand fetch it 
	;;(when (eq (prolog:prolog `(cpoe:object-in-hand ?object :right ?_ ?_)) nil)
	;;	               (progn (print "Object is not in hand !.... going to grasp it..."))

	;;			(setf ?output-check  (fetching-object ?object :nil :nil))
	;;				(when (eq ?output-check "fetch")
	;;					(setf ?deliver-check T))
	;;				(when (eq ?output-check "fail")
	;;					(setf ?deliver-check nil)
	;;					(return-from delivering-object "fail")))	
	;;;; find deliver to where or Whom?
	(if (not(eq ?person nil))
		(setf ?deliver-to-person T)
		(setf ?deliver-to-person nil))
	
	;;;; if any of the location is not given 
	(if (and (eq ?locatio-on-fr :nil) (eq ?locatio-on-fr :nil))
		(setf ?location-check nil)
		(setf ?location-check T))
	
	;;; if location is given goto the location
	(when ?location-check
		(navigate-to-location ?location-on-fr ?room))
	
	;;; if deliver check is true 
	(when ?deliver-check 
		(when (eq ?deliver-to-person T)	
			;;--->>>>> ADD plan to deliver to the person 
			;; go to the person
			;; rise the hand 
			;; say to the person to grasp the object
			;; (call-text-to-speech-action "Please take the object")
			;; check for the object is not in hand
			(print "deliver to person")
			(return-from delivering-object  "deliver"))
		
		(when (eq ?deliver-to-person nil)
			;;--->>>>> ADD plan to deliver to the location with failure handling
			
			;;;;;;;;;;;;;;; FOR TESTING PURPOSE 
			(setf ?place-pose (make-pose "map" '((1.4154692465230447d0 -0.49576755079049184d0 0.806323621845479d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
			(setf ?object-height 0.215d0)
			;;;;;;;;;;;;;;;
				 (cpl:with-retry-counters ((place-retries 2)) 
				 (cpl:with-failure-handling
				      (((or common-fail:navigation-high-level-failure
				         	common-fail:navigation-low-level-failure
				         	common-fail:object-undeliverable
				         	common-fail:manipulation-low-level-failure
				         	desig:designator-error) (e)
				            (print "I couldn't place it yet")
				        (roslisp:ros-warn (pp-plans pick-up)
						   "Manipulation messed up: ~a~%Retring..."
						   e)
					 (cpl:do-retry place-retries
						(cpl:retry))
					 (roslisp:ros-warn (pp-plans pick-up) "No more retries left..... going back ")
					 ;;;; TODO add navigation plan for going back to starting point
						    (return-from delivering-object "fail")))
					 (exe:perform (desig:an action
						         (type :placing)
						         (target-pose ?place-pose)
						         (object-height ?object-height)
						         (collision-mode :allow-all)))
						         ))
			(print "deliver to location")
			(return-from delivering-object  "deliver"))
	)
)

;;;; TRANSPORT the object to the location or to the person
;; 
(defun transporting-object(?object ?object-in-room ?object-in-location ?deliver-room ?deliver-location ?person)
	
	;;; check the property of the object if its pronoun or a nlp object name
	(if (eq ?object :object) 
		(setf ?object *previous-object*) ;; for pronoun get the object from buffer
		(setf ?object (object-to-be *objectname*))) ;; convert object nlp-name to cram-name
	
	;;;; find transport to where or Whom?
	(if (not(eq ?person nil))
		(setf ?transport-to-person T)
		(setf ?transport-to-person nil)) ;;; if person then no delivery location needed
			
	;;; fetch the object
	;; check both locations of furniture is given or not
	(if (and (eq ?object-in-location :nil) (eq ?deliver-location :nil))
		(setf ?double-locations-check nil)
		(setf ?double-locations-check T))
	;; check both locations of room is given or not	
	(if (and (eq ?object-in-room :nil) (eq ?deliver-room :nil))
		(setf ?double-rooms-check nil)
		(setf ?double-rooms-check T))
	
	;;;;;; ADD LSIT
	;;(defparameter *loc-list* (list))	
	;;(if (not (eq ?object-in-location :nil))
	;;	(nconc *loc-list* (list :anything))
	
	;;)
	
	
	(when ?double-locations-check 
		(setf ?object-is-at ?object-in-location)
		(setf ?object-is-to ?deliver-location))
	(when ?double-rooms-check 
		(setf ?object-is-at ?object-in-room)
		(setf ?object-is-to ?deliver-room))	
		
		;;TODO locations for fetching (fetching-object ?object ?object-in-location ?object-in-room)	
	
	(print "transporation plan")
	 (return-from transporting-object "transport")
)

(defun guide-people(?person ?room1 ?location1)
	(print "guide plan")
	 (return-from guide-people "guide")
	)

