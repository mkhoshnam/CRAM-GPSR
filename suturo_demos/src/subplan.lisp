---------------------------------Knowledges
(defparameter *left-downward*
  (cl-transforms-stamped:make-pose-stamped
   "base_footprint" 0.0
   (cl-transforms:make-3d-vector 0.65335d0 0.76d0 0.758d0)
   (cl-transforms:make-identity-rotation)))

 (defparameter *left-upward*
  (cl-transforms-stamped:make-pose-stamped
   "base_footprint" 0.0
   (cl-transforms:make-3d-vector 0.65335d0 0.76d0 0.958d0)
   (cl-transforms:make-identity-rotation)))
 
(defparameter *right-downward*
  (cl-transforms-stamped:make-pose-stamped
   "base_footprint" 0.0
   (cl-transforms:make-3d-vector 0.65335d0 -0.76d0 0.758d0)
   (cl-transforms:make-identity-rotation)))
 
(defparameter *right-upward*
  (cl-transforms-stamped:make-pose-stamped
   "base_footprint" 0.0
   (cl-transforms:make-3d-vector 0.65335d0 -0.76d0 0.958d0)
   (cl-transforms:make-identity-rotation)))
   
(defparameter *forward-downward*
  (cl-transforms-stamped:make-pose-stamped
   "base_footprint" 0.0
   (cl-transforms:make-3d-vector 0.65335d0 0.076d0 0.758d0)
   (cl-transforms:make-identity-rotation)))
   
(defparameter *forward-upward*
  (cl-transforms-stamped:make-pose-stamped
   "base_footprint" 0.0
   (cl-transforms:make-3d-vector 0.65335d0 0.076d0 0.958d0)
   (cl-transforms:make-identity-rotation)))







----------------------------------Functions
These are some functions that be used for in other plans, mostly for perceive the object or person. 
Each one take a parameter x as input, you could use any object that you want instead. 
For example (find-object-loop :bowl), it will try to find a bowl.
You just to put the last function (find-object-loop) at any plan that you want to find or perceive the object. 

    

(defun find-it-1 (?object ?object-type ?object-atribute)
  (setf *perceived-object* nil)
  (let ((?looking-direction *left-downward*))
    (cpl:par
      (exe:perform (desig:an action
                             (type looking)
                             (target (desig:a location 
                                              (pose ?looking-direction)))))
      
      ;; try to perceive it.
      (cpl:with-failure-handling
          ((cram-common-failures:perception-object-not-found (e)
             ;; Try different look directions until there is none left.
             (roslisp:ros-warn (perception-failure) "~a~%Detection-failed." e)

             (return)))
        (when ?object
          (setf *perceived-object* (exe:perform (an action
                                                    (type detecting)
                                                    (object (an object
                                                                (type ?object)))))))
        (when ?object-type
          (setf *perceived-object* (exe:perform (an action
                                                    (type detecting)
                                                    (object (an object
                                                                (type ?object-type)))))))))

      (values *perceived-object*)))





(defun find-it-2 (?object ?object-type ?object-atribute)
    (let ((?looking-direction *left-upward*))
      (cpl:par
        (exe:perform (desig:an action
                               (type looking)
                               (target (desig:a location 
                                                (pose ?looking-direction)))))
        
        ;; try to perceive it.
        (cpl:with-failure-handling
            ((cram-common-failures:perception-object-not-found (e)
               ;; Try different look directions until there is none left.
               (roslisp:ros-warn (perception-failure) "~a~%Detection-failed." e)

               (return)))
          (when ?object
          (setf *perceived-object* (exe:perform (an action
                                                    (type detecting)
                                                    (object (an object
                                                                (type ?object)))))))
        (when ?object-type
          (setf *perceived-object* (exe:perform (an action
                                                    (type detecting)
                                                    (object (an object
                                                                (type ?object-type)))))))))


      (values *perceived-object*)))






(defun find-it-3 (?object ?object-type ?object-atribute)
    (let ((?looking-direction *right-downward*))
      (cpl:par
        (exe:perform (desig:an action
                               (type looking)
                               (target (desig:a location 
                                                (pose ?looking-direction)))))
        
        ;; try to perceive it.
        (cpl:with-failure-handling
            ((cram-common-failures:perception-object-not-found (e)
               ;; Try different look directions until there is none left.
               (roslisp:ros-warn (perception-failure) "~a~%Detection-failed." e)

               (return)))
          (when ?object
          (setf *perceived-object* (exe:perform (an action
                                                    (type detecting)
                                                    (object (an object
                                                                (type ?object)))))))
        (when ?object-type
          (setf *perceived-object* (exe:perform (an action
                                                    (type detecting)
                                                    (object (an object
                                                                (type ?object-type)))))))))

      (values *perceived-object*)))






(defun find-it-4 (?object ?object-type ?object-atribute)
    (let ((?looking-direction *right-upward*))
      (cpl:par
        (exe:perform (desig:an action
                               (type looking)
                               (target (desig:a location 
                                                (pose ?looking-direction)))))
        
        ;; try to perceive it.
        (cpl:with-failure-handling
            ((cram-common-failures:perception-object-not-found (e)
               ;; Try different look directions until there is none left.
               (roslisp:ros-warn (perception-failure) "~a~%Detection-failed." e)

               (return)))
          (when ?object
          (setf *perceived-object* (exe:perform (an action
                                                    (type detecting)
                                                    (object (an object
                                                                (type ?object)))))))
        (when ?object-type
          (setf *perceived-object* (exe:perform (an action
                                                    (type detecting)
                                                    (object (an object
                                                                (type ?object-type)))))))))

      (values *perceived-object*)))






(defun find-it-5 (?object ?object-type ?object-atribute)
    (let ((?looking-direction *forward-downward*))
      (cpl:par
        (exe:perform (desig:an action
                               (type looking)
                               (target (desig:a location 
                                                (pose ?looking-direction)))))
        
        ;; try to perceive it.
        (cpl:with-failure-handling
            ((cram-common-failures:perception-object-not-found (e)
               ;; Try different look directions until there is none left.
               (roslisp:ros-warn (perception-failure) "~a~%Detection-failed." e)

               (return)))
          (when ?object
          (setf *perceived-object* (exe:perform (an action
                                                    (type detecting)
                                                    (object (an object
                                                                (type ?object)))))))
        (when ?object-type
          (setf *perceived-object* (exe:perform (an action
                                                    (type detecting)
                                                    (object (an object
                                                                (type ?object-type)))))))))
      (values *perceived-object*)))








(defun find-it-6 (?object ?object-type ?object-atribute)
    (let ((?looking-direction *forward-upward*))
      (cpl:par
        (exe:perform (desig:an action
                               (type looking)
                               (target (desig:a location 
                                                (pose ?looking-direction)))))
        
        ;; try to perceive it.
        (cpl:with-failure-handling
            ((cram-common-failures:perception-object-not-found (e)
               ;; Try different look directions until there is none left.
               (roslisp:ros-warn (perception-failure) "~a~%Detection-failed." e)

               (return)))
          (when ?object
          (setf *perceived-object* (exe:perform (an action
                                                    (type detecting)
                                                    (object (an object
                                                                (type ?object)))))))
        (when ?object-type
          (setf *perceived-object* (exe:perform (an action
                                                    (type detecting)
                                                    (object (an object
                                                                (type ?object-type)))))))))
      (values *perceived-object*)))
      
      
      
      
      
(defun find-human-1 (?person ?person-name ?person-action)
      (setf *perceived-person* nil)
      (let ((?looking-direction *left-downward*))
        (cpl:par
          (exe:perform (desig:an action
                                 (type looking)
                                 (target (desig:a location 
                                                  (pose ?looking-direction)))))
          
          ;; try to perceive it.
          (cpl:with-failure-handling
              ((cram-common-failures:perception-object-not-found (e)
                 ;; Try different look directions until there is none left.
                 (roslisp:ros-warn (perception-failure) "~a~%Detection-failed." e)

                 (return)))
              (setf *perceived-person* (exe:perform (an action
                                                      (type detecting)
                                                      (object (an object
                                                                  (type :HUMAN)
                                                                  (desig:when ?human-name
                                                                    (size ?human-name))
                                                                  (desig:when ?human-action
                                                                    (location ?human-action)))))))))

        (values *perceived-person*)))
        
        
        
(defun find-human-2 (?person ?person-name ?person-action)
      (setf *perceived-person* nil)
      (let ((?looking-direction *left-upward*))
        (cpl:par
          (exe:perform (desig:an action
                                 (type looking)
                                 (target (desig:a location 
                                                  (pose ?looking-direction)))))
          
          ;; try to perceive it.
          (cpl:with-failure-handling
              ((cram-common-failures:perception-object-not-found (e)
                 ;; Try different look directions until there is none left.
                 (roslisp:ros-warn (perception-failure) "~a~%Detection-failed." e)

                 (return)))
              (setf *perceived-person* (exe:perform (an action
                                                      (type detecting)
                                                      (object (an object
                                                                  (type :HUMAN)
                                                                  (desig:when ?human-name
                                                                    (size ?human-name))
                                                                  (desig:when ?human-action
                                                                    (location ?human-action)))))))))

        (values *perceived-person*)))        


                                                                                   



(defun find-human-3 (?person ?person-name ?person-action)
      (setf *perceived-person* nil)
      (let ((?looking-direction *right-downward*))
        (cpl:par
          (exe:perform (desig:an action
                                 (type looking)
                                 (target (desig:a location 
                                                  (pose ?looking-direction)))))
          
          ;; try to perceive it.
          (cpl:with-failure-handling
              ((cram-common-failures:perception-object-not-found (e)
                 ;; Try different look directions until there is none left.
                 (roslisp:ros-warn (perception-failure) "~a~%Detection-failed." e)

                 (return)))
              (setf *perceived-person* (exe:perform (an action
                                                      (type detecting)
                                                      (object (an object
                                                                  (type :HUMAN)
                                                                  (desig:when ?human-name
                                                                    (size ?human-name))
                                                                  (desig:when ?human-action
                                                                    (location ?human-action)))))))))

        (values *perceived-person*)))



(defun find-human-4 (?person ?person-name ?person-action)
      (setf *perceived-person* nil)
      (let ((?looking-direction *right-upward*))
        (cpl:par
          (exe:perform (desig:an action
                                 (type looking)
                                 (target (desig:a location 
                                                  (pose ?looking-direction)))))
          
          ;; try to perceive it.
          (cpl:with-failure-handling
              ((cram-common-failures:perception-object-not-found (e)
                 ;; Try different look directions until there is none left.
                 (roslisp:ros-warn (perception-failure) "~a~%Detection-failed." e)

                 (return)))
              (setf *perceived-person* (exe:perform (an action
                                                      (type detecting)
                                                      (object (an object
                                                                  (type :HUMAN)
                                                                  (desig:when ?human-name
                                                                    (size ?human-name))
                                                                  (desig:when ?human-action
                                                                    (location ?human-action)))))))))

        (values *perceived-person*)))




(defun find-human-5 (?person ?person-name ?person-action)
      (setf *perceived-person* nil)
      (let ((?looking-direction *forward-downward*))
        (cpl:par
          (exe:perform (desig:an action
                                 (type looking)
                                 (target (desig:a location 
                                                  (pose ?looking-direction)))))
          
          ;; try to perceive it.
          (cpl:with-failure-handling
              ((cram-common-failures:perception-object-not-found (e)
                 ;; Try different look directions until there is none left.
                 (roslisp:ros-warn (perception-failure) "~a~%Detection-failed." e)

                 (return)))
              (setf *perceived-person* (exe:perform (an action
                                                      (type detecting)
                                                      (object (an object
                                                                  (type :HUMAN)
                                                                  (desig:when ?human-name
                                                                    (size ?human-name))
                                                                  (desig:when ?human-action
                                                                    (location ?human-action)))))))))

        (values *perceived-person*)))




(defun find-human-6 (?person ?person-name ?person-action)
      (setf *perceived-person* nil)
      (let ((?looking-direction *forward-upward*))
        (cpl:par
          (exe:perform (desig:an action
                                 (type looking)
                                 (target (desig:a location 
                                                  (pose ?looking-direction)))))
          
          ;; try to perceive it.
          (cpl:with-failure-handling
              ((cram-common-failures:perception-object-not-found (e)
                 ;; Try different look directions until there is none left.
                 (roslisp:ros-warn (perception-failure) "~a~%Detection-failed." e)

                 (return)))
              (setf *perceived-person* (exe:perform (an action
                                                      (type detecting)
                                                      (object (an object
                                                                  (type :HUMAN)
                                                                  (desig:when ?human-name
                                                                    (size ?human-name))
                                                                  (desig:when ?human-action
                                                                    (location ?human-action)))))))))

        (values *perceived-person*)))




(defun find-object-loop (?object ?object-type ?object-atribut)
  (let* ((find-functions '(find-it-1 find-it-1 find-it-2 find-it-2 find-it-3 find-it-3 find-it-4 find-it-4 find-it-5 find-it-5 find-it-6 find-it-6))
         (current-function (car find-functions)))
    (loop until (or (not (eq perceived-object nil)) (null find-functions))
          do
             (funcall current-function x)
             (setf find-functions (cdr find-functions))
             (setq current-function (car find-functions)))))


(defun find-person-loop (?person ?person-name ?person-action)
  (let* ((find-functions '(find-human-1 find-human-1 find-human-2 find-human-2 find-human-3 find-human-3 find-human-4 find-human-4 find-human-5 find-human-5 find-human-6 find-human-6))
         (current-function (car find-functions)))
    (loop until (or (not (eq perceived-object nil)) (null find-functions))
          do
             (funcall current-function x)
             (setf find-functions (cdr find-functions))
             (setq current-function (car find-functions)))))          
          
          
                 
                                                             
(defun find-object (?object ?object-type ?object-atribute)
  (setf *perceived-object* nil)
  (su-real:with-hsr-process-modules
      
      (find-object-loop ?object ?object-type ?object-atribute) 
    (when *perceived-object*                       
      (setf object-loc-x (cl-transforms:x (cl-transforms:translation (man-int:get-object-transform-in-map *perceived-object*))))
      (setf object-loc-y (cl-transforms:y (cl-transforms:translation (man-int:get-object-transform-in-map *perceived-object*))))
      
      ;;TO-DO >>> Location should define
      (setf xp-robot (cl-transforms:x (cl-transforms:origin (btr:pose (btr:get-robot-object)))))
      (setf yp-robot (cl-transforms:y (cl-transforms:origin (btr:pose (btr:get-robot-object)))))

      (defparameter *location*
        (cl-transforms-stamped:make-pose-stamped
         "base_footprint" 0.0
         (cl-transforms:make-3d-vector xp-robot object-loc-y 0)
         (cl-transforms:make-identity-rotation)))

      (values *location*)
      (return-from find-object "find-object"))))
          
          
          
          
(defun find-person (?person ?person-name ?person-action)
  (setf *perceived-person* nil)
  (su-real:with-hsr-process-modules
      
      (find-person-loop ?person ?person-name ?person-action) 
    (when *perceived-person*                       
      (setf *object-loc-x* (cl-transforms:x (cl-transforms:translation (man-int:get-object-transform-in-map *perceived-eprson*))))
      (setf *object-loc-y* (cl-transforms:y (cl-transforms:translation (man-int:get-object-transform-in-map *perceived-person*))))
      
      ;;TO-DO >>> Location should define
      (setf *xp-robot* (cl-transforms:x (cl-transforms:origin (btr:pose (btr:get-robot-object)))))
      (setf *yp-robot* (cl-transforms:y (cl-transforms:origin (btr:pose (btr:get-robot-object)))))
      
      
      (defparameter *location*
        (cl-transforms-stamped:make-pose-stamped
         "base_footprint" 0.0
         (cl-transforms:make-3d-vector *xp-robot* *object-loc-y* 0)
         (cl-transforms:make-identity-rotation)))
      
      (values *location*)
      (return-from find-object "find-person"))))
          
          
          
          

          
          
          
          
          
          
                
