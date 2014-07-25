(require-package 'compile)

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

(require-package 'cl) ; If you don't have it already

(defun* get-closest-pathname (&optional (file "Makefile"))
  "Determine the pathname of the first instance of FILE starting from the current directory towards root.
This may not do the correct thing in presence of links. If it does not find FILE, then it shall return the name
of FILE in the current directory, suitable for creation"
  (let ((root (expand-file-name "/"))) ; the win32 builds should translate this correctly
    (expand-file-name file
	      (loop 
	  for d = default-directory then (expand-file-name ".." d)
	  if (file-exists-p (expand-file-name file d))
	  return d
	  if (equal d root)
	  return nil))))

(global-set-key "\C-x\C-m" 'compile)

(add-hook 'c-mode-hook (lambda () (set (make-local-variable 'compile-command) (format "cd `dirname %s`;make" (get-closest-pathname)))))
(add-hook 'erlang-mode-hook (lambda () (set (make-local-variable 'compile-command) (format "cd `dirname %s`;make" (get-closest-pathname)))))

(provide 'init-compile)
