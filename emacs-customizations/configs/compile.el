(require 'compile)

;;(defun notify-compilation-result(buffer msg)
;;  "Notify that the compilation is finished,
;;close the *compilation* buffer if the compilation is successful,
;;and set the focus back to Emacs frame"
;;  (if (string-match "^finished" msg)
;;    (progn
;;     (delete-windows-on buffer)
;;     (tooltip-show "\n Compilation Successful :-) \n "))
;;    (tooltip-show "\n Compilation Failed :-( \n "))
;;  (setq current-frame (car (car (cdr (current-frame-configuration)))))
;;  (select-frame-set-input-focus current-frame)
;;  )

;;(add-to-list 'compilation-finish-functions
;;       'notify-compilation-result)

;;(defun* get-closest-pathname (&optional (file "Makefile"))
;;  "Determine the pathname of the first instance of FILE starting from the current directory towards root.
;;This may not do the correct thing in presence of links. If it does not find FILE, then it shall return the name
;;of FILE in the current directory, suitable for creation"
;;  (let ((root (expand-file-name "/"))) ; the win32 builds should translate this correctly
;;    (expand-file-name file
;;	      (loop 
;;	  for d = default-directory then (expand-file-name ".." d)
;;	  if (file-exists-p (expand-file-name file d))
;;	  return d
;;	  if (equal d root)
;;	  return nil))))

(global-set-key "\C-x\C-m" 'compile)

(defun* get-closest-pathname (&optional (file "Makefile"))
;;  (let (root (file-name-directory(buffer-file-name)))
  (let ((root (expand-file-name "/")))
;;  	(expand-file-name file
	  (loop
		  for d = default-directory then (expand-file-name ".." d)
		  if (file-exists-p (expand-file-name file d))
		  return d
		  if (equal d root)
		  return nil))
)
(add-hook 'erlang-mode-hook (lambda () (set (make-local-variable 'compile-command) (format "cd %s; make" (get-closest-pathname)))))
;;(add-hook 'after-save-hook 'my-after-save-hook)
