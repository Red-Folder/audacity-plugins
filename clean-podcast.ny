;nyquist plug-in
;version 4
;type process
;name "Clean Podcast"

(setf start-position 0)
(setf selections-to-delete ())

(defun add-selection (label)
  (setf selection-to-delete
      (list start-position (second label) (third label)))
  (push selection-to-delete selections-to-delete))

(defun process()
  (let ((label-info (aud-get-info "Labels")))
    (dolist (track label-info)
      (dolist (label (second track))
        (if (string= (third label) "bad")
          (add-selection label))
        (setf start-position (second label)))))
  (dolist (selection-to-delete selections-to-delete)
    (aud-do (format nil "Select:Start=~a End=~a Track=0 TrackCount=2 Mode=Set"
                    (first selection-to-delete)
                    (second selection-to-delete)))
    (aud-do "Delete:"))
  "") ; Return a "no-op" empty string.

(catch 'err (process))
