(require 'compile)

(defun bury-compile-buffer-if-successful (buffer string)
  "Bury a compilation buffer if succeeded without warnings "
  (if (and
       (string-match "compilation" (buffer-name buffer))
       (string-match "finished" string)
       (not
        (with-current-buffer buffer
          (search-forward "warning" nil t))))
      (run-with-timer 1 nil
                      (lambda (buf)
                        (bury-buffer buf)
						(delete-window (get-buffer-window buf)))
                      buffer)))
(add-hook 'compilation-finish-functions 'bury-compile-buffer-if-successful)

(defun* get-closest-pathname (&optional (file "Makefile"))
  (let ((root (expand-file-name "/")))
	  (loop
		  for d = default-directory then (expand-file-name ".." d)
		  if (file-exists-p (expand-file-name file d))
		  return d
		  if (equal d root)
		  return nil)))

(global-set-key "\C-x\C-m" 'compile)
