(in-package :demo)




;;;;;;;; Dependencies




;;;;;;;;;;;;;;;;;;;;;;;;; HSR PLANS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; ALL inputs must be given in the form of keywords and these keywords are resolved by the gpsr_knowledge




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
	
	;;--->>>>> ADD pickup plan with failure handling and use  *perceived-object* to get object designator
	(print "fetching plan")
	(return-from fetching-object  "fetch"))


;;;; DELIVER the object to the person/ on the location
;; plan depends on searching plan-->>  navigation-to-location or fetching-object
(defun delivering-object (?object ?location-on-fr ?room ?person)

	(setf ?deliver-check nil)
	
	;;; check the property of the object if its pronoun or a nlp object name
	(if (eq ?object :object) 
		(setf ?object *previous-object*) ;; for pronoun get the object from buffer
		(setf ?object (object-to-be *objectname*))) ;; convert object nlp-name to cram-name
	
	
	;;; check if object is already in hand 	
	(when (prolog:prolog `(cpoe:object-in-hand ?object :right ?_ ?_))
		               (progn (print "Yes, I have Object in hand !")
		               (setf ?deliver-check T)
		                     ))
	;;; if object is not in hand fetch it 
	(when (eq (prolog:prolog `(cpoe:object-in-hand ?object :right ?_ ?_)) nil)
		               (progn (print "Object is not in hand !.... going to grasp it..."))

				(setf ?output-check  (fetching-object ?object :nil :nil))
					(when (eq ?output-check "fetch")
						(setf ?deliver-check T))
					(when (eq ?output-check "fail")
						(setf ?deliver-check nil)
						(return-from delivering-object "fail")))	
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
		(when (equ ?deliver-to-person T)	
			;;--->>>>> ADD plan to deliver to the person 
			;; go to the person
			;; rise the hand 
			;; say to the person to grasp the object
			;; (call-text-to-speech-action "Please take the object")
			;; check for the object is not in hand
			(print "deliver to person")
			(return-from delivering-object  "deliver"))
		
		(when (equ ?deliver-to-person nil)
			;;--->>>>> ADD plan to deliver to the location with failure handling
			(print "deliver to location")
			(return-from delivering-object  "deliver"))
	)
)

;;;; TRANSPORT the object to the location or to the person
;; 
(defun transporting-object(?object ?room1 ?location1 ?room2 ?location2 ?person)
	
	
	(print "transporation plan")
	 (return-from transporting-object "transport")
	)

(defun guide-people(?person ?room1 ?location1)
	(print "guide plan")
	 (return-from guide-people "guide")
	)

