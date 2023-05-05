(in-package :demo)
(defun cram-talker (command)
  "Periodically print a string message on the /chatter topic"
    (let ((pub (roslisp:advertise "CRAMpub" "std_msgs/String")))
      
         (roslisp:publish-msg pub :data (format nil command))))

         

