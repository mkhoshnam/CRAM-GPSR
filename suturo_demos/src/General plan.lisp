(defun navigation-to-location (?furniture-location ?room)
  (su-real:with-hsr-process-modules
    (cpl:with-failure-handling
      (((or common-fail:navigation-high-level-failure
            CRAM-COMMON-FAILURES:PERCEPTION-OBJECT-NOT-FOUND
            common-fail:navigation-low-level-failure
            CRAM-COMMON-FAILURES:GRIPPER-CLOSED-COMPLETELY) (e))
       (print "I didn't reach yet")
       (return-from navigation-to-location "fail"))

    (if ?room
      (exe:perform (desig:an action
                             (type going)
                             (target (desig:a location
                                              (pose ?room))))))
      (if ?furniture-location
        (exe:perform (desig:an action
                               (type going)
                               (target (desig:a location
                                                (pose ?furniture-location))))))

    (cpl:fail (make-instance 'common-fail:navigation-low-level-failure)))
  "navigate"))
  



(defun searching (?object ?person ?object-type ?object-atribute ?person-name ?person-action ?furniture-location ?room)
  (setf *perceived-object* nil)
  (setf *perceived-person* nil)
  
  (navigation-to-location ?furniture-location ?room) 
  
  (when ?object
    (find-object-loop ?object ?object-type ?object-atribute)

    (when (and ?location (eq *perceived-object* nil))
      (return-from searching "fail"))) 
    
    (when ?person  
      (if (not (eq ?person-name :nil))
          (setf ?human-name ?personname)
          (setf ?human-name nil))
      (if (not (eq ?person-action :nil))
          (setf ?human-action (get-person-action-name ?person-action))
          (setf ?human-action nil))
          
      (find-person-loop ?person ?person-name ?person-action)
      
      (when (and ?person (eq *perceived-person* nil))
        (return-from searching "fail"))))           
          
          
          
          
(defun fetch (?object ?person ?object-type ?object-atribute ?room ?location ?person-name ?person-action ?furniture-location)
  (setf *grasping* nil)
  (searching ?object ?person ?object-type ?object-atribute ?room ?location ?person-name ?person-action ?furniture-location)
  (roslisp:with-fields
      ((?pose
        (cram-designators::pose cram-designators:data)))
      *perceived-object*
    (let ((?object-size
            (cl-tf2::make-3d-vector 0.05 0.05 0.2)))   ;;TO-DO: espicify the object size for each different object
      
      (cpl:with-failure-handling
          (((or common-fail:navigation-high-level-failure
                CRAM-COMMON-FAILURES:PERCEPTION-OBJECT-NOT-FOUND
                common-fail:navigation-low-level-failure
                CRAM-COMMON-FAILURES:GRIPPER-CLOSED-COMPLETELY) (e)
             (print "I couldn't pick it up yet")
             (return-from fetch "fail")))
        (exe:perform (desig:an action
                               (type picking-up)
                               (object-pose ?pose)
                               (object-size ?object-size)
                               (collision-mode :allow-all)))
        (cpl:fail (make-instance 'common-fail:navigation-low-level-failure))
        (setf *grasping* t)
      (return-from fetch "fetch")))))
      
      
      
(defun deliver-to-location (?object ?object-type ?object-attribute ?furniture-location-1 ?room-1 ?furniture-location-2 ?room-2 ?num) 
  (su-real:with-hsr-process-modules
      (if (not (eq *grasping* t)) 
          (progn (navigation-to-location ?furniture-location ?room)
                 (fetch ?object ?object-type ?object-attribute ?furniture-location))
          (progn (navigation-to-location ?furniture-location ?room)        
                 (let*
                     (
                      (?place-pose (create-pose (list "map" (list 1.4154692465230447d0 -0.49576755079049184d0 0.806323621845479d0) (list 0 0 0 1))))
                      (?object-height 0.215d0)
                      )
                   (cpl:with-failure-handling
                       (((or common-fail:navigation-high-level-failure
                             CRAM-COMMON-FAILURES:PERCEPTION-OBJECT-NOT-FOUND
                             common-fail:navigation-low-level-failure
                             CRAM-COMMON-FAILURES:GRIPPER-CLOSED-COMPLETELY) (e)
                          (print "I couldn't pick it up yet")
                          (return-from delivery "fail")))
                     (exe:perform (desig:an action
                                            (type :placing)
                                            (target-pose ?place-pose)
                                            (object-height ?object-height)
                                            (collision-mode :allow-all)))
                     (cpl:fail (make-instance 'common-fail:navigation-low-level-failure)))
                   (return-from deliver "deliver"))))))
                                 
                                 
                                 
                                 
                                 
(defun deliver-to-location (?object ?location ?object-type ?object-attribute ?furniture-location-1 ?room-1 ?furniture-location-2 ?room-2 ?num)
  (su-real:with-hsr-process-modules
      (let* ((?num (if ?num ?num 1))) ; Set ?num to 1 if it is not provided
        (loop repeat ?num do
          (if (not (eq *grasping* t))
              (fetch ?object ?object-type ?object-attribute ?furniture-location-1 ?room-1)
              (progn
                (navigation-to-location ?furniture-location-2 ?room-2)
                (let*
                    (
                     (?place-pose (create-pose (list "map" (list 1.4154692465230447d0 -0.49576755079049184d0 0.806323621845479d0) (list 0 0 0 1))))
                     (?object-height 0.215d0)
                     )
                  (cpl:with-failure-handling
                      (((or common-fail:navigation-high-level-failure
                            CRAM-COMMON-FAILURES:PERCEPTION-OBJECT-NOT-FOUND
                            common-fail:navigation-low-level-failure
                            CRAM-COMMON-FAILURES:GRIPPER-CLOSED-COMPLETELY) (e)
                         (print "I couldn't pick it up yet")
                         (return-from delivery "fail")))
                    (exe:perform (desig:an action
                                           (type :placing)
                                           (target-pose ?place-pose)
                                           (object-height ?object-height)
                                           (collision-mode :allow-all)))
                    (cpl:fail (make-instance 'common-fail:navigation-low-level-failure)))
                  (return-from deliver "deliver"))))))))                                
                                 
                                 
                                 
                                 


(defun transport-to-location (?object ?person ?object-type ?object-attribute ?person-name ?person-action ?furniture-location 
                              ?furniture-location-1 ?room-1 ?furniture-location-2 ?room-2)
  (deliver-to-location ?object ?location ?object-type ?object-attribute ?furniture-location-1 ?room-1 ?furniture-location-2 ?room-2)
  (return-from transport-to-location "transport"))                                  
                                 
                                 
                                 
                                 
(defun counting (?object ?person ?object-type ?object-atribute ?person-name ?person-action ?furniture-location ?room ?dir)  ;;dir  left or right, For examle the most left apple
  (defparameter xpm-list (list 0))
  (defparameter ypm-list (list 0))
  (su-real:with-hsr-process-modules
    (searching ?object ?person ?object-type ?object-atribute ?person-name ?person-action ?furniture-location ?room)
    (when ?object
      (counting-the-object ?object ?object-type ?object-atribute ?dir))
    (when ?dir
      (give-object ?object ?object-type ?object-atribute ?dir)) 
    (when ?person
      (count-people-gender ?person ?person-name ?person-action))))
        
        
        
      
        
(defun describing (?object ?person ?person-name ?person-action ?furniture-location ?room)
  (su-real:with-hsr-process-modules
      (counting ?object ?person ?person-name ?person-action ?furniture-location ?room))) 
      
      
      
   
      

(defun guiding (?furniture-location ?person ?person-name ?person-action ?room ?furniture-location-1 ?room-1 ?furniture-location-2 ?room-2)
  (navigation-to-location ?furniture-location-1 ?room-1)
  (when ?person  
    (if (not (eq ?person-name :nil))
        (setf ?human-name ?person-name)
        (setf ?human-name nil))
    (if (not (eq ?person-action :nil))
        (setf ?human-action (get-person-action-name ?person-action))
        (setf ?human-action nil))

    (find-person-loop ?person ?person-name ?person-action)
    (when (and (or ?person? ?person-type ?person-action) (eq *perceived-person* nil))
      (return-from guiding "fail")))
  (navigation-to-location ?furniture-location-2 ?room-2))                                   
          
          
   
   
          
(defun following (?person ?person-name ?person-action ?furniture-location ?room)
  (setf *perceived-object* nil)
  (setf *condition-stop* nil)
  (su-real:with-hsr-process-modules
      (searching ?object ?person ?object-type ?object-atribute ?person-name ?person-action ?furniture-location ?room)
    (loop until condition-stop do
    (find-person-loop ?person ?person-name ?person-action)
      (when *perceived-person*                       
        (setf *person-loc-x* (cl-transforms:x (cl-transforms:translation (man-int:get-object-transform *perceived-person*))))
        (setf *person-loc-y* (cl-transforms:y (cl-transforms:translation (man-int:get-object-transform *perceived-person*))))
        (setf *robot-x* (cl-transforms:x (cl-transforms:origin (btr:pose (btr:get-robot-object)))))
        (setf *robot-y* (cl-transforms:y (cl-transforms:origin (btr:pose (btr:get-robot-object)))))
        (when *perceived-person*
          (defparameter *location*
            (cl-transforms-stamped:make-pose-stamped
             "base_footprint" 0.0
             (cl-transforms:make-3d-vector (- *person-loc-x* 1) *person-loc-y* 0)
             (cl-transforms:make-identity-rotation))))
        (setf *percecived-person* nil)
        (let ((?pose *location*))
          (cpl:with-failure-handling
              (((or common-fail:navigation-high-level-failure
                    CRAM-COMMON-FAILURES:PERCEPTION-OBJECT-NOT-FOUND
                    common-fail:navigation-low-level-failure) (e)
                 (print "Location can not be reached")
                 (return-from following "fail")))
            (exe:perform (desig:an action
                                   (type going)
                                   (target (desig:a location 
                                                    (pose ?pose)))))
            (cpl:fail (make-instance 'common-fail:navigation-low-level-failure)))
          (return-from following "follow"))))))                 
