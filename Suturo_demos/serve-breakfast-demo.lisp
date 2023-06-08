(in-package :su-demos)

(defparameter *objects* (list :muesli :milk :bowl :spoon))

(defun doortest()
  (park-robot)
  (cpl:with-retry-counters ((perceive-retries 5))
    (cpl:with-failure-handling
        ((common-fail:perception-object-not-found (e)
           (cpl:do-retry perceive-retries
             (roslisp:ros-warn (perceive) "~a" e)
             (cpl:retry))))
      (let* ((?source-object-desig
               (desig:an object
                         (type :open-door)))
             ;; detect object and safe the return value
             (?object-desig
               (exe:perform (desig:an action
                                      (type detecting)
                                      (object ?source-object-desig)))))
    
        ;; Extracts pose from the return value of the detecting Designator.
       
          (nav-shelf-left)))))
  

(defun serve-breakfast-demo()
 "Demo for the 'serve breakfast' challenge for the first stage of the robocup. Full plan will look roughly as follows:
- move to shelf
- open shelf
- perceive items in shelf
- pick up relevant items and transport them towards dinner table one after another
- pick up cerealbox
- pour cereals into the breakfast bowl
- place down cerealbox"
  
  ;; Takes standard pose
  (park-robot)
  ;; Calls knowledge to receive coordinates of the shelf pose, then relays that pose to navigation
  ;; (move-hsr (create-pose (call-knowledge "hsr_pose_shelf" :result 'pose)))
  (nav-shelf-right)

  (mani-pose)

  (let* ((?source-object-desig
           (desig:an object
                     (type :muesli)))
         ;; detect object and safe the return value
         (?object-desig
           (exe:perform (desig:an action
                                  (type detecting)
                                  (object ?source-object-desig))))
         )


                

        
        ;; Extracts pose from the return value of the detecting Designator.
        (roslisp:with-fields 
            ((?pose
              (cram-designators::pose cram-designators:data)))
            
             ;(?name (cut:var-value :type cram-designators:description))) 
            ?object-desig
          ?pose
          (call-text-to-speech-action "Successfully perceived object muesli")
          (call-text-to-speech-action "Trying to grasp")
          (mani-pose)
          ;; picks up the object by executing the following motions:
          ;; - opening the gripper
          ;; - reaching for the object
          ;; - closing the gripper, thus gripping the object
          ;; - lifting the object
          ;; - retracting the arm to retrieve the object from, for example, a shelf
          (let ((?object-size
                  (cl-tf2::make-3d-vector 0.04 0.1 0.2)))
            (exe:perform (desig:an action
                                   (type picking-up)
                                   (object-pose ?pose)
                                   (object-size ?object-size)
                                   (collision-mode :allow-all))))
        
        (park-robot)

       
        (let*
        ;;TF link hier angeben
            ((object-ident (call-knowledge2 "has_urdf_name" :param-list "table_kitchen_shelves:table:table_front_edge_center" :result 'object))
             (pose (call-knowledge-object-rel-pose object-ident "perceive" "-y"))
             (?place-pose (create-pose (list "map" (list 4.1 4 0.75) (list 0 0 0 1))))
             (?object-height 0.215d0)
             )
      
      
          (move-hsr (create-pose pose))
      
      
      ;; (roslisp:with-fields
      ;;     ((?pose
      ;;         (cram-designators::pose cram-designators:data)))
          
      ;;     ?place-pose

    
          (exe:perform (desig:an action
                                 (type :placing)
                                 (target-pose ?place-pose)
                                 (object-height ?object-height)
                                 (collision-mode :allow-all)))
          (move-hsr (create-pose pose)))
      

        

        (park-robot)))

  (nav-shelf-left)

  (mani-pose)

  (call-text-to-speech-action "Trying to perceive object milk")
      (let* ((?source-object-desig
               (desig:an object
                         (type :milk)))
             ;; detect object and safe the return value
             (?object-desig
               (exe:perform (desig:an action
                                      (type detecting)
                                      (object ?source-object-desig))))
             )
    
        ;; Extracts pose from the return value of the detecting Designator.
        (roslisp:with-fields 
            ((?pose
              (cram-designators::pose cram-designators:data))) 
            ?object-desig

          (call-text-to-speech-action "Successfully perceived object milk")
          (call-text-to-speech-action "Trying to grasp")
          (mani-pose)
          
          ;; picks up the object by executing the following motions:
          ;; - opening the gripper
          ;; - reaching for the object
          ;; - closing the gripper, thus gripping the object
          ;; - lifting the object
          ;; - retracting the arm to retrieve the object from, for example, a shelf
          (let ((?object-size
                  (cl-tf2::make-3d-vector 0.05 0.05 0.2)))
            (exe:perform (desig:an action
                                   (type picking-up)
                                   (object-pose ?pose)
                                   (object-size ?object-size)
                                   (collision-mode :allow-all)))))
        
        (park-robot)


        (let*
        ;;TF link hier angeben
            ((object-ident (call-knowledge2 "has_urdf_name" :param-list "table_kitchen_shelves:table:table_front_edge_center" :result 'object))
             (pose (call-knowledge-object-rel-pose object-ident "perceive" "-x"))
             (?place-pose (create-pose (list "map" (list 4.75 4.2 0.75) (list 0 0 0 1))))
             (?object-height 0.215d0)
             )
      
      
          (move-hsr (create-pose pose))
      
      
      ;; (roslisp:with-fields
      ;;     ((?pose
      ;;         (cram-designators::pose cram-designators:data)))
          
      ;;     ?place-pose

    
          (exe:perform (desig:an action
                                 (type :placing)
                                 (target-pose ?place-pose)
                                 (object-height ?object-height)
                                 (collision-mode :allow-all)))
          (move-hsr (create-pose pose)))

        (park-robot)))



(defun serve-breakfast-demo2()
 "Demo for the 'serve breakfast' challenge for the first stage of the robocup. Full plan will look roughly as follows:
- move to shelf
- open shelf
- perceive items in shelf
- pick up relevant items and transport them towards dinner table one after another
- pick up cerealbox
- pour cereals into the breakfast bowl
- place down cerealbox"
  
  ;; Takes standard pose
  (park-robot)
  ;; Calls knowledge to receive coordinates of the shelf pose, then relays that pose to navigation
  ;; (move-hsr (create-pose (call-knowledge "hsr_pose_shelf" :result 'pose)))
  (nav-shelf-left)

  (park-robot)

  
  (let ((run t)
        (retries 3))
    (block searching-muesli-1
      (when run
        (call-text-to-speech-action "Trying to perceive object muesli")
        (cpl:with-retry-counters ((perceive-retries retries))
          (cpl:with-failure-handling
              ((common-fail:perception-object-not-found (e)
                 (cpl:par
                   (cpl:par
                     (setf retries (- retries  1))
                     (print "setf retires done"))
                   (if (> retries  0)
                       (cpl:do-retry perceive-retries
                         (roslisp:ros-warn (perceive) "~a" e)
                         (cpl:retry))
                       (cpl:par (setf run nil)
                         (return-from searching-muesli-1))))))
      (let* ((?source-object-desig
               (desig:an object
                         (type :muesli)))
             ;; detect object and safe the return value
             (?object-desig
               (exe:perform (desig:an action
                                      (type detecting)
                                      (object ?source-object-desig))))
             )


                

        
        ;; Extracts pose from the return value of the detecting Designator.
        (roslisp:with-fields 
            ((?pose
              (cram-designators::pose cram-designators:data)))
            
             ;(?name (cut:var-value :type cram-designators:description))) 
            ?object-desig
          ?pose
          (call-text-to-speech-action "Successfully perceived object muesli")
          (call-text-to-speech-action "Trying to grasp")
          (mani-pose)
          ;; picks up the object by executing the following motions:
          ;; - opening the gripper
          ;; - reaching for the object
          ;; - closing the gripper, thus gripping the object
          ;; - lifting the object
          ;; - retracting the arm to retrieve the object from, for example, a shelf
          (let ((?object-size
                  (cl-tf2::make-3d-vector 0.04 0.1 0.2)))
            (exe:perform (desig:an action
                                   (type picking-up)
                                   (object-pose ?pose)
                                   (object-size ?object-size)
                                   (collision-mode :allow-all)))))
        
        (park-robot)

       
        (let*
        ;;TF link hier angeben
            ((object-ident (call-knowledge2 "has_urdf_name" :param-list "table_kitchen_shelves:table:table_front_edge_center" :result 'object))
             (pose (call-knowledge-object-rel-pose object-ident "perceive" "-y"))
             (?place-pose (create-pose (list "map" (list 4.1 4 0.75) (list 0 0 0 1))))
             (?object-height 0.215d0)
             )
      
      
          (move-hsr (create-pose pose))
      
      
      ;; (roslisp:with-fields
      ;;     ((?pose
      ;;         (cram-designators::pose cram-designators:data)))
          
      ;;     ?place-pose

    
          (exe:perform (desig:an action
                                 (type :placing)
                                 (target-pose ?place-pose)
                                 (object-height ?object-height)
                                 (collision-mode :allow-all)))
          (move-hsr (create-pose pose)))
      

        

        (park-robot)))))))

  (call-text-to-speech-action "Trying to perceive object milk")
  (cpl:with-retry-counters ((perceive-retries 3))
    (cpl:with-failure-handling
        ((common-fail:perception-object-not-found (e)
           (cpl:do-retry perceive-retries
             (roslisp:ros-warn (perceive) "~a" e)
             (cpl:retry))))
      (let* ((?source-object-desig
               (desig:an object
                         (type :milk)))
             ;; detect object and safe the return value
             (?object-desig
               (exe:perform (desig:an action
                                      (type detecting)
                                      (object ?source-object-desig))))
             )
    
        ;; Extracts pose from the return value of the detecting Designator.
        (roslisp:with-fields 
            ((?pose
              (cram-designators::pose cram-designators:data))) 
            ?object-desig

          (call-text-to-speech-action "Successfully perceived object milk")
          (call-text-to-speech-action "Trying to grasp")
          (mani-pose)
          
          ;; picks up the object by executing the following motions:
          ;; - opening the gripper
          ;; - reaching for the object
          ;; - closing the gripper, thus gripping the object
          ;; - lifting the object
          ;; - retracting the arm to retrieve the object from, for example, a shelf
          (let ((?object-size
                  (cl-tf2::make-3d-vector 0.04 0.1 0.2)))
            (exe:perform (desig:an action
                                   (type picking-up)
                                   (object-pose ?pose)
                                   (object-size ?object-size)
                                   (collision-mode :allow-all)))))
        
        (park-robot)

        ;; Calls knowledge to receive coordinates of the dinner table pose, then relays that pose to navigation
        ;;(move-hsr (create-pose (call-knowledge "hsr_pose_dinner_table" :result 'pose)))
        
        ;; places the object by executing the following motions:
        ;; - preparing to place the object, by lifting the arm to an appropriate height
        ;; - placing the object
        ;; - opening the gripper, thus releasing the object
        ;; (let ((?object-height 0.28d0))    
    ;;       (exe:perform (desig:an action
    ;;                              (type :placing)
    ;;                              (target-pose ?target-pose)
    ;;                              (object-height ?object-height)
    ;;                              (collision-mode :allow-all))))

    ;; ;; Calls knowledge to receive coordinates of the dinner table pose, then relays that pose to navigation
        ;;     (move-hsr (create-pose (call-knowledge "hsr_pose_dinner_table" :result 'pose)))

        (let*
        ;;TF link hier angeben
            ((object-ident (call-knowledge2 "has_urdf_name" :param-list "table_kitchen_shelves:table:table_front_edge_center" :result 'object))
             (pose (call-knowledge-object-rel-pose object-ident "perceive" "-y"))
             (?place-pose (create-pose (list "map" (list 4.1 3.7 0.75) (list 0 0 0 1))))
             (?object-height 0.215d0)
             )
      
      
          (move-hsr (create-pose pose))
      
      
      ;; (roslisp:with-fields
      ;;     ((?pose
      ;;         (cram-designators::pose cram-designators:data)))
          
      ;;     ?place-pose

    
          (exe:perform (desig:an action
                                 (type :placing)
                                 (target-pose ?place-pose)
                                 (object-height ?object-height)
                                 (collision-mode :allow-all)))
          (move-hsr (create-pose pose)))

        (park-robot))))

  (call-text-to-speech-action "Trying to perceive object bowl")
  (cpl:with-retry-counters ((perceive-retries2 1))
    (cpl:with-failure-handling
        ((common-fail:perception-object-not-found (e)
           (cpl:do-retry perceive-retries2
             (call-text-to-speech-action "Could not detect bowl")
             (return))))
      
      (cpl:with-retry-counters ((perceive-retries 3))
        (cpl:with-failure-handling
            ((common-fail:perception-object-not-found (e)
               (cpl:do-retry perceive-retries
                 (roslisp:ros-warn (perceive) "~a" e)
                 (cpl:retry))))
          (let* ((?source-object-desig
                   (desig:an object
                             (type :bowl)))
                 ;; detect object and safe the return value
                 (?object-desig
                   (exe:perform (desig:an action
                                          (type detecting)
                                          (object ?source-object-desig)))))
            (roslisp:with-fields 
                ((?name
                  (cram-designators::name cram-designators:data))) 
                ?object-desig
              
              (when (eq ?name "bowl-1")
                (call-text-to-speech-action "Detected bowl, please put it on the table for me. I will wait there for you ")))
            
            (let*
                ;;TF link hier angeben
                ((object-ident (call-knowledge2 "has_urdf_name" :param-list "table_kitchen_shelves:table:table_front_edge_center" :result 'object))
                 (pose (call-knowledge-object-rel-pose object-ident "perceive" "-y"))
                 )
      
 
              (move-hsr (create-pose pose)))
        
            (park-robot)
            (sleep 4)

            (cpl:with-retry-counters ((perceive-retries4 1))
              (cpl:with-failure-handling
                  ((common-fail:perception-object-not-found (e)
                     (cpl:do-retry perceive-retries4
                       (call-text-to-speech-action "Could not detect bowl")
                       (return))))
                
                (cpl:with-retry-counters ((perceive-retries3 3))
                  (cpl:with-failure-handling
                      ((common-fail:perception-object-not-found (e)
                         (cpl:do-retry perceive-retries3
                           (roslisp:ros-warn (perceive) "~a" e)
                           (cpl:retry))))
                    (let* ((?source-object-desig
                             (desig:an object
                                       (type :bowl)))
                           ;; detect object and safe the return value
                           (?object-desig
                             (exe:perform (desig:an action
                                                    (type detecting)
                                                    (object ?source-object-desig)))))
                      (roslisp:with-fields 
                          ((?name
                            (cram-designators::name cram-designators:data))) 
                          ?object-desig
                        
                        (when (eq ?name "bowl-1")
                          (call-text-to-speech-action "Detected bowl, thank you for assisting me"))))))))



            
            )))))

        

        

        (park-robot))
  


;; LUCA TODO
;; rewrite~/SUTURO/SUTURO_WSS/planning_ws/src/cram/cram_external_interfaces/cram_giskard/src/collision-scene.lisp to function without using the bulletworld as reasoning tool, but rather use knowledge as reasoning tool. For example "update-object-pose-in-collision-scene" 

;; (cram-occasions-events:on-event
;;      (make-instance 'cram-plan-occasions-events:object-perceived-event
;;                          :object-designator desig
;;                          :perception-source :whatever))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; Hardcoded stuff for debugging ;;;;;;;;;;;;

(defun park-robot ()
  "Default pose"
  ;; (call-take-pose-action 0 0 -0.35 0 0 0 -1.5 0))
  (call-take-pose-action 0 0 0 0 0 -1.5 -1.5 0))

(defun mani-pose ()
  "Default pose"
  (call-take-pose-action 0 0 -0.35 0 0 0 -1.5 0))

(defun take-new-default1 ()
  "Potential alternatives to the default pose"
  (call-take-pose-action 0 0 0 0.3 -2.6 0 1 0))

(defun take-new-default2 ()
  "Potential alternatives to the default pose"
  (call-take-pose-action 0 0 0 0.3 -2.6 1.5 -1.5 0.5))

(defun nav-zero-pos ()
  "Starting pose in IAI office lab"
  (let ((vector (cl-tf2::make-3d-vector 0 0 0))
        (rotation (cl-tf2::make-quaternion 0 0 0 1)))
    (move-hsr (cl-tf2::make-pose-stamped "map" 0 vector rotation))))

(defun nav-shelf-left ()
  "Starting pose in IAI office lab"
  (let ((vector (cl-tf2::make-3d-vector 4.4 5.7 0))
        (rotation (cl-tf2::make-quaternion 0 0 0 1)))
    (move-hsr (cl-tf2::make-pose-stamped "map" 0 vector rotation))))

(defun nav-shelf-right ()
  "Starting pose in IAI office lab"
  (let ((vector (cl-tf2::make-3d-vector 4.4 2.1 0))
        (rotation (cl-tf2::make-quaternion 0 0 0 1)))
    (move-hsr (cl-tf2::make-pose-stamped "map" 0 vector rotation))))

(defun nav-table ()
  "Starting pose in IAI office lab"
  (let ((vector (cl-tf2::make-3d-vector 3.3 3.9 0))
        (rotation (cl-tf2::make-quaternion 0 0 0 1)))
    (move-hsr (cl-tf2::make-pose-stamped "map" 0 vector rotation))))


(defun nav-robot-test ()
  "Starting pose in IAI office lab"
  (let ((vector (cl-tf2::make-3d-vector 3.4 2 0))
        (rotation (cl-tf2::make-quaternion 0 0 0 1)))
    (move-hsr (cl-tf2::make-pose-stamped "map" 0 vector rotation)))
  (let ((vector (cl-tf2::make-3d-vector 2.6 5.7 0))
        (rotation (cl-tf2::make-quaternion 0 0 0 1)))
    (move-hsr (cl-tf2::make-pose-stamped "map" 0 vector rotation))))
