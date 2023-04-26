(in-package :demo)

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
  
 

;;;;;;;;;;; dependencies
 
 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; plans 



(defparameter ?possible-location nil)  
   
(defun fetching-object(?object ?location-to-go)
 
(spawn-object '((-0.9 1.8  0.9) (0 0 0 1)) :spoon 'object-1 '(0.3 1 0))
(spawn-object '((-0.9 2  0.9) (0 0 0 1)) :bottle 'object-2 '(1 0.3 0.7))
 (spawn-object '((-0.9 1.6  0.9) (0 0 0 1)) :bowl 'object-3 '(0.1 0.2 0))
(spawn-object '((-0.9 2.2  0.9) (0 0 0 1)) :cup 'object-4 '(0.1 0.2 0.5))
(spawn-object '((-0.9 1.7  0.9) (0 0 0 1)) :milk 'object-5 '(0.1 0.1 0.1))
;;;; check for picking up location
	
(if (eq ?location-to-go :nil)
   (setf ?possible-location *location-on-counter*))  ;;;; search for location in knowledge
   
(if (not (eq ?location-to-go :nil))                    ;;; go to the location 
    (setf ?possible-location *location-on-counter*))

(cpl:with-retry-counters ((grasp-retries 5))                           
  (cpl:with-failure-handling
      (((or common-fail:manipulation-low-level-failure
                                  common-fail:object-unreachable
                                  common-fail:gripper-closed-completely
                                  desig:designator-error) (e)
         (roslisp:ros-warn (pp-plans pick-up)
                           "Manipulation messed up: ~a~%Retring..."
                           e)
                            (cpl:do-retry grasp-retries

                            (cpl:retry))
                            
         ))
	
	(setf grasped-object nil)
    	(let ((?search-location *location-on-counter*))
	  (setf *per-object* (exe:perform
				  (desig:an action
					    (type searching)
					    (object (desig:an object
							      (type ?object)
							      (location (desig:a location
								               (pose ?search-location)))))))))

	 (let ((?perceived-object *per-object*))
	   	(exe:perform (desig:an action
				(type picking-up)
				 (object ?perceived-object))))
	       (exe:perform
		   (desig:an action
		             (type parking-arms)))
	 (when (prolog:prolog `(cpoe:object-in-hand ?object :right ?_ ?_))
		               (progn (print "Yes, I grasps the Object")
		                      (setf grasped-object T)))
))                                              	                                       	                                     
)	

(defun delivering-object (?object ?location-to-go)

	(setf ?deliver-check nil)

	(when (prolog:prolog `(cpoe:object-in-hand ?object :right ?_ ?_))
		               (progn (print "Yes, I have Object in hand !")
		               (setf ?deliver-check T)
		                     ))

	(when (eq (prolog:prolog `(cpoe:object-in-hand ?object :right ?_ ?_)) nil)
		               (progn (print "Object is not in hand !.... going to grasp it..."))

				(fetching-object ?object ?location-to-go)
				(setf ?deliver-check T))
	
	(when (eq ?deliver-check T)		
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
		                     
	 )                           
              	                                       	                                     
)
