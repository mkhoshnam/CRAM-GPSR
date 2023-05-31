(in-package :demo)




;;;; list of objects
(setf list-of-objects '(:bowl :spoon :cup :milk :breakfast-cereal))

;;;;navigating locations for Robot
(defparameter *location-near-sidetable*
  (cl-transforms-stamped:make-pose-stamped
   "map" 0.0
   (cl-transforms:make-3d-vector -2.2d0 -0.20d0 0.0d0)
   (cl-transforms:make-quaternion 0.0d0 0.0d0 -0.7071067811865475d0 0.7071067811865476d0)))

(defparameter *location-near-counter*
  (cl-transforms-stamped:make-pose-stamped
   "map" 0.0
   (cl-transforms:make-3d-vector -0.150d0 2.0d0 0.0d0)
   (cl-transforms:make-quaternion 0.0d0 0.0d0 -1.0d0 0.0d0)))
   
;;;locations on the objects
(defparameter *location-on-counter*
  (cl-transforms-stamped:make-pose-stamped
   "map" 0.0
   (cl-transforms:make-3d-vector -0.8 2 0.9)
   (cl-transforms:make-quaternion 0.0d0 0.0d0 -1.0d0 0.0d0)))

 (defparameter *location-on-sidetable*
  (cl-transforms-stamped:make-pose-stamped
   "map" 0.0
   (cl-transforms:make-3d-vector -2.323 -1 0.82)
   (cl-transforms:make-quaternion 0.0d0 0.0d0 0.0d0 1.0d0)))

(defparameter *starting-point*
  (cl-transforms-stamped:make-pose-stamped
   "map" 0.0
   (cl-transforms:make-3d-vector 0 0 0)
   (cl-transforms:make-identity-rotation)))
  
 

;;;;;;;;;;; dependencies
 (defun spawn-object (spawn-pose &optional (obj-type :bottle) (obj-name 'bottle-1) (obj-color '(1 0 0)))
  (unless (assoc obj-type btr::*mesh-files*)
    (btr:add-objects-to-mesh-list "cram_pr2_pick_place_demo"))
  (btr-utils:spawn-object obj-name obj-type :color obj-color :pose spawn-pose)
  (btr:simulate btr:*current-bullet-world* 10))

(defun list-available-objects ()
  (mapcar #'car btr::*mesh-files*))




;;;; functions dependencies
(defun place-objects ()
	(spawn-object '((-0.9 1.8  0.9) (0 0 0 1)) :spoon 'object-1 '(0.3 1 0))
	(spawn-object '((-0.9 2  0.9) (0 0 0 1)) :bottle 'object-2 '(1 0.3 0.7))
	(spawn-object '((-0.9 1.6  0.9) (0 0 0 1)) :bowl 'object-3 '(0.1 0.2 0))
	(spawn-object '((-0.9 2.2  0.9) (0 0 0 1)) :cup 'object-4 '(0.1 0.2 0.5))
	(spawn-object '((-0.9 1.7  0.9) (0 0 0 1)) :milk 'object-5 '(0.1 0.1 0.1))
 )


(defun finding-object (?object ?searching-location) ;;; (object : type) (location : keyword) e.g (finding-object :bowl :bedroom)
	;;;; check for searching location
	(if (eq ?searching-location :nil)
	   (setf ?possible-location (get-searching-pose ?object)))  ;;;; search for location in knowledge
	   
	(if (not (eq ?searching-location :nil))                    ;;; go to the given location 
	    (setf ?possible-location (get-searching-pose ?searching-location)))
	
	(cpl:with-retry-counters ((search-retries 2))                           
	  (cpl:with-failure-handling
	      (((or common-fail:manipulation-low-level-failure
					   common-fail:navigation-goal-in-collision
					   common-fail:searching-failed
		                          desig:designator-error) (e)
		 (roslisp:ros-warn (pp-plans pick-up)
		                   "Searching messed up: ~a~%Retring..."
		                   e)
		 (cpl:do-retry search-retries

		 (cpl:retry))
		 (roslisp:ros-warn (pp-plans pick-up) "No more retries left..... going back ")
		 (navigation-start-point)
		 (return-from finding-object "fail")
		                    
		 ))
	(let ((?search-location *location-on-counter*))
	  (setf *per-object* (exe:perform
				  (desig:an action
					    (type searching)
					    (object (desig:an object
							      (type ?object)
							      (location (desig:a location
								               (pose ?search-location)))))))))))
	(return-from finding-object "search")								               	
)



 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; plans 
(defparameter ?possible-location nil)  
   
(defun fetching-object(?object ?location-to-go)  ;;; (object : type) (location : keyword) e.g (fetching-object :bowl :bedroom)
 
(cpl:with-retry-counters ((grasp-retries 4))                           
  (cpl:with-failure-handling
      (((or common-fail:manipulation-low-level-failure
                                  common-fail:object-unreachable
                                  common-fail:gripper-closed-completely
				   common-fail:navigation-goal-in-collision
				   common-fail:searching-failed
                                  desig:designator-error) (e)
         (roslisp:ros-warn (pp-plans pick-up)
                           "Manipulation messed up: ~a~%Retring..."
                           e)
         (cpl:do-retry grasp-retries

         (cpl:retry))
         (roslisp:ros-warn (pp-plans pick-up) "No more retries left..... going back ")
	 (navigation-start-point)
	 (return-from fetching-object "fail")
                            
         ))
	(if (eq ?object :object) ;;; get the object from buffer
		(setf ?object *previous-object*))
	;;;; search for the object
	(setf grasped-object nil)
	(let ((?looking-for-object (finding-object ?object ?location-to-go)))
	
	(if (eq ?looking-for-object "fail")
	    (return-from fetching-object "fail")) 
	   
	(if (not (eq ?looking-for-object "fail"))                
	     (setf *per-object*(exe:perform (desig:an action
					       (type detecting)
					       (object (desig:an object
							  (type ?object))))))
	))
		
	(let ((?perceived-object *per-object*))
	   	(exe:perform (desig:an action
				(type picking-up)
				 (object ?perceived-object))))
	       (exe:perform
		   (desig:an action
		             (type parking-arms)))

	 (when (prolog:prolog `(cpoe:object-in-hand ?object :right ?_ ?_))
		               (progn (print "Yes, I grasps the Object")
		                      (setf grasped-object T))
		                      (return-from fetching-object "fetch"))
))                                              	                                       	                                     
)	

(defun delivering-object (?object ?location-to-go) ;;; (object : type) (location : transformation in map)

	(setf ?deliver-check nil)
	
	(if (eq ?object :object) ;;; get the object from buffer
		(setf ?object *previous-object*))
		
	(when (prolog:prolog `(cpoe:object-in-hand ?object :right ?_ ?_))
		               (progn (print "Yes, I have Object in hand !")
		               (setf ?deliver-check T)
		                     ))

	(when (eq (prolog:prolog `(cpoe:object-in-hand ?object :right ?_ ?_)) nil)
		               (progn (print "Object is not in hand !.... going to grasp it..."))

				(setf ?output-check (fetching-object ?object ?location-to-go))
					(when (eq ?output-check "fetch")
						(setf ?deliver-check T))
					(when (eq ?output-check "fail")
						(setf ?deliver-check nil)
						(return-from delivering-object "fail"))
				)
	
	(when (eq ?deliver-check T)
		(cpl:with-retry-counters ((place-retries 3))                           
	  		(cpl:with-failure-handling
			      (((or common-fail:navigation-goal-in-collision
                    		    common-fail:object-undeliverable
                    		    common-fail:manipulation-low-level-failure
				    common-fail:navigation-low-level-failure) (e)
				 (roslisp:ros-warn (pp-plans pick-up)
						   "Manipulation messed up: ~a~%Retring..."
						   e)
				 (cpl:do-retry place-retries
					(cpl:retry))
				 (roslisp:ros-warn (pp-plans pick-up) "No more retries left..... going back ")
				 (navigation-start-point)
				 (return-from delivering-object "fail")
						    
				 ))		
	(let ((?pose *location-near-sidetable*))
	 (exe:perform
		   (desig:an action
		             (type going)
		             (target (desig:a location
		                              (pose ?pose))))))
	
		(let ((?drop-pose *location-on-sidetable*))
		  (exe:perform
		   (desig:an action
		             (type placing)
		             (target (desig:a location
		                              (pose ?drop-pose))))))
		(return-from delivering-object "deliver")		                        
		                     
	 ))
	)                           
              	                                       	                                     
)

(defun navigation-start-point()

   (cpl:with-failure-handling
      ((common-fail:navigation-low-level-failure (e)
         (roslisp:ros-warn (pp-plans navigate)
                           "Low-level navigation failed: ~a~%.Ignoring anyway." e)
         (return)))
	 (let ((?pose *starting-point*))  ;;;; search for location in knowledge
		 (exe:perform
			   (desig:an action
				     (type going)
				     (target (desig:a location
				                      (pose ?pose)))))))
        (exe:perform
		   (desig:an action
                             (type parking-arms)))
				                      

)

;;;;;;; HSR
(defun searching-object(?object)
	(setf *perceived-object* nil)
	 (setf *perceived-object* (exe:perform (desig:an action
					       (type detecting)
					       (object (desig:an object
								(type ?object))))
				  )
	)
	(return-from searching-object "search")
	
)

