(in-package :su-demos)

;;;; Dependencies Functions
(defun make-pose (reference-frame pose)
  (cl-transforms-stamped:make-pose-stamped
   reference-frame 0.0
   (apply #'cl-transforms:make-3d-vector (first pose))
   (apply #'cl-transforms:make-quaternion (second pose))))
  

(defun find-keyword(?word-to-find ?list-of-list)
	(mapcar (lambda (element)
		        	(position ?word-to-find element))
		     			 ?list-of-list)) 

(defun find-non-nil-element (?list)
	(find :non-nil-element ?list :test (lambda (non-nil-element element-in-list) (not (null element-in-list)))))

(defun all-positions-list (?word ?lookup-list)
  (let ((?outcome nil))
    (dotimes (i (length ?lookup-list))
      (if (eq (nth i ?lookup-list) ?word)
          (push i ?outcome)))
    (nreverse ?outcome)))
  
 
(defun get-nth-element(?number-list ?lookup-list)
	(let ((?outcome nil))
		(dolist (n ?number-list)
		(push (nth n ?lookup-list) ?outcome))
	(nreverse ?outcome))
)
 
 ;;;;;; Head movement psoitions
 
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
  
  
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;; object knowledge
 
  (defvar *gpsr-objects* '((:apple :apple :fruits :living-room :bookcase)    ;; nlp-name cram-name category df-room df-loc-in-room  
                      (:bag :bag :container :living-room :end-table)
                      (:basket :basket :container :living-room :end-table)
                      (:bottle :bottle :container :kitchen :end-table)
                      (:bowl :bowl :tableware :kitchen :storage-table)
                      (:cloth :cloth :cleaningstuff :bedroom :side-table)
                      (:cup :cup :tableware :kitchen :storage-table)
                      (:cascade :cascade :container :bedroom :side-table)
                      (:chocolate :chocolate :snacks :living-room :bookcase)
                      (:crackers :crackers :snacks :living-room :bookcase)
                      (:coke :coke :drinks :kitchen :counter)
                      (:cereal :cerealbox :food :kitchen :cupboard)
                      (:dish :dish :tableware :kitchen :storage-table)
                      (:fork :fork :cutlery :kitchen :storage-table)
                      (:glass :glass :tableware :kitchen :storage-table)
                      (:grape-juice :grapejuice :drinks :kitchen :counter)
                      (:juice :juice :drinks :kitchen :counter)
                      (:knife :knife :cutlery :kitchen :storage-table)
                      (:milk :milkpack :drinks :kitchen :counter)
                      (:noodles :noodles :food :kitchen :cupboard)
                      (:orange :orange :fruits :living-room :bookcase)
                      (:orange-juice :orangejuice :drink :kitchen :counter)
                      (:paprika :paprika :fruits :living-room :bookcase)
                      (:pringles :pringles :snacks :living-room :bookcase)
                      (:plate :plate :tableware :kitchen :end-table)
                      (:potatochips :potatochips :snacks :living-room :bookcase)
                      (:spoon :spoon :cutlery :kitchen :storage-table)
                      (:sprite :sprite :drinks :kitchen :counter)
                      (:sausages :sausages :food :kitchen :cupboard)
                      (:scrubby :scrubby :cleaningstuff :bedroom :side-table)
                      (:sponge :sponge :cleaningstuff :bedroom :side-table)
                      (:tray :tray :containers :living-room :end-table)))
 

;;;; location knowledge

(defvar *gpsr-rooms-locations* '((:bedroom :bed :desk :side-table)  ;;;; :room :location1-in-room :location2-in-room ...
  				     (:living-room :exit :couch :endtable :bookcase)
  				     (:kitchen :cupboard :storage-table :sink :counter :dishwasher)
  				     (:dinning-room :dinning-table)
  				     (:corridor :entrance)))
 

;;; person 
(defvar *persons* '((:alex :female :male)
			(:charlie :female :male)
			(:elizabeth :female)
			(:francis :female :male)
			(:jennifer :female)
			(:linda :female)
			(:mary :female)
			(:patricia :female)
			(:robin :female :male)
			(:james :male)
			(:john :male)
			(:michael :male)
			(:robert :male)
			(:skyler :female :male)
			(:william :male)

))
;;;; nlp personal pronouns mapping with cram

(defvar *pronouns* '((:object :objects :it)  ;;;; :title :per-pronoun1 :per-pronoun2 ...
			(:location :there :here)
			(:person :people :me :him :her :women :woman :boy :men :man :girl)))




 
;;;;navigating locations for Robot

(defvar *gpsr-navigation-locations* '((:start-point (make-pose "base_footprint" '((0.0d0 0.0d0 0.0d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
				(:bedroom (make-pose "base_footprint" '((0.0d0 0.0d0 0.0d0) (0.0d0 0.0d0 0.0d0 1.0d0))))  
				(:living-room (make-pose "base_footprint" '((0.0d0 0.0d0 0.0d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
				(:kitchen (make-pose "base_footprint" '((0.0d0 0.0d0 0.0d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
				(:dinning-room (make-pose "base_footprint" '((0.0d0 0.0d0 0.0d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
				(:corridor (make-pose "base_footprint" '((0.0d0 0.0d0 0.0d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
				(:side-table (make-pose "base_footprint" '((-0.0d0 0.0d0 0.0d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
				(:counter (make-pose "base_footprint" '((0.0d0 0.0d0 0.0d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
				(:sink (make-pose "base_footprint" '((0.0d0 0.0d0 0.0d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
				
				))
				
				
;;;; locations on the object / searching locations / pickup and place locations

(defvar *gpsr-locations-on-object* '((:counter (make-pose "base_footprint" '((0.65335d0 0.076d0 0.758d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
					(:side-table (make-pose "base_footprint" '((0.65335d0 0.076d0 0.758d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
					(:end-table (make-pose "base_footprint" '((0.65335d0 0.076d0 0.758d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
					(:storage-table (make-pose "base_footprint" '((0.65335d0 0.076d0 0.758d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
					(:cupboard (make-pose "base_footprint" '((0.65335d0 0.076d0 0.758d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
					(:bookcase (make-pose "base_footprint" '((0.65335d0 0.076d0 0.758d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
					(:entrance (make-pose "base_footprint" '((0.65335d0 0.076d0 0.758d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
					(:dinning-table (make-pose "base_footprint" '((-0.65335d0 0.076d0 0.758d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
					(:bed (make-pose "base_footprint" '((0.65335d0 0.076d0 0.758d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
					(:desk (make-pose "base_footprint" '((0.65335d0 0.076d0 0.758d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
					(:exit (make-pose "base_footprint" '((0.65335d0 0.076d0 0.758d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
					(:couch (make-pose "base_footprint" '((0.65335d0 0.076d0 0.758d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
					(:dishwasher (make-pose "base_footprint" '((0.65335d0 0.076d0 0.758d0) (0.0d0 0.0d0 0.0d0 1.0d0))))
					
					))
                    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun get-info-word (?searching-word ?list)  ;;; (get-info-word :spoon *objects*)
	
	(let ((?result (find-keyword ?searching-word ?list)))
		(setf ?element (find-non-nil-element ?result))
		(if (eq ?element nil)
		    (return-from get-info-word nil))
		    
		(if (not (eq ?element nil))
		    (setf ?positions-in-list (all-positions-list ?element ?result))) 

	   (get-nth-element ?positions-in-list ?list)))





(defun get-object-position (?searching-word ?array) ;;; e.g  (get-word-position :kitchen (first (get-info-word :spoon *objects*)))
(setf ?position-outcome (all-positions-list ?searching-word ?array))
(let ((?output nil))
	(dolist (n ?position-outcome)
		(if (eq n 0)
			(push :nlp-name ?output))
		(if (eq n 1)
			(push :cram-name ?output))
		(if (eq n 2)
			(push :object-category ?output))
		(if (eq n 3)
			(push :default-room-location ?output))
		(if (eq n 4)
			(push :default-location-in-room ?output))
			)
	(nreverse ?output)))

(defun get-specific-info-word (?word ?specification ?list)
	 (let ((?word-info (first (get-info-word ?word ?list)))) 
	  (if (eq ?specification :nlp-name)
	   (setf ?result (nth 0 ?word-info)))
	  (if (eq ?specification :cram-name)
	   (setf ?result (nth 1 ?word-info)))
	   (if (eq ?specification :object-category)
	   (setf ?result (nth 2 ?word-info)))
	   (if (eq ?specification :default-room-location)
	   (setf ?result (nth 3 ?word-info)))
	   (if (eq ?specification :default-location-in-room)
	   (setf ?result (nth 4 ?word-info))))
	(return-from get-specific-info-word ?result))
	
	
(defun get-object-cram-name(?nlp-object-name)
 (get-specific-info-word ?nlp-object-name :cram-name *gpsr-objects*)
)

(defun identify-object-keyword(?object-keyword)
	(nth 0 (first (get-info-word ?object-keyword *pronouns*))))


(defun object-to-be(?object-nlp)
	
	(setf *object-in-list* (get-specific-info-word ?object-nlp :cram-name *gpsr-objects*))
	(if  (eq (get-specific-info-word ?object-nlp :cram-name *gpsr-objects*) nil)
		 (setf *object-in-list* (identify-object-keyword ?object-nlp)))
	(return-from object-to-be *object-in-list*)

)

(defun get-navigation-pose (?keyword) ;; give room name or location 
	(nth 1 (first (get-info-word ?keyword  *gpsr-navigation-locations*)))
)

;;; give object keyword
(defun get-searching-pose (?keyword) ;;;  (get-searching-pose :counter) or  (get-searching-pose :juice)
	(let ((?get-location (get-specific-info-word ?keyword :default-location-in-room *gpsr-objects*)))
	(nth 1 (first (get-info-word ?get-location *gpsr-locations-on-object*)))))
	

