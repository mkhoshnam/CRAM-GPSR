(in-package :su-demos)
(defun cram-talker (command)
  "Periodically print a string message on the /chatter topic"
    (let ((pub (roslisp:advertise "CRAMpub" "std_msgs/String")))
      
         (roslisp:publish-msg pub :data (format nil command))))
         

(defun hsrtospeak (topic-name)
    (setf *dialog-subscriber* (roslisp:subscribe topic-name "std_msgs/String" #'hsrspeaks-callback-function)))
    
(defun hsrspeaks-callback-function (message)
	(roslisp:with-fields (data) message
         (print data)
         (print "recoring start now")
         (call-text-to-speech-action data)))



