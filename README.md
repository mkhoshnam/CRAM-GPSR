# CRAM-Stuff-GPSR

## Failure handling
while writing plans, after trying failure handling clause and if it fails , direct the robot to initial position for the next commmand.
Some example 
``` lisp = 
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
				 (return)))
         (let ((?search-location *location-on-counter*))
              (setf *per-object* (exe:perform
                                    (desig:an action
                                        (type searching)
                                        (object (desig:an object
                                              (type ?object)
                                              (location (desig:a location
                                                         (pose ?search-location)))))))))
```
         
