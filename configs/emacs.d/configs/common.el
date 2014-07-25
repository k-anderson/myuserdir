(font-lock-add-keywords nil '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))
(font-lock-add-keywords nil '(("\\<\\(DONE\\):" 1 font-lock-doc-face t)))

;; Evaluate body after package is loaded
(defmacro after-load (feature &rest body)                                                                                                                                                                                                                                                          
  "After FEATURE is loaded, evaluate BODY."
  (declare (indent defun))
  `(eval-after-load ,feature
     '(progn ,@body)))

;; Handier way to add modes to auto-mode-alist
(defun add-auto-mode (mode &rest patterns)
  "Add entries to `auto-mode-alist' to use `MODE' for all given file `PATTERNS'."
  (dolist (pattern patterns)
    (add-to-list 'auto-mode-alist (cons pattern mode))))

;; Remove trailing whitespace based on mode
(setq common/trailing-whitespace-modes '())
(defun common/trailing-whitespace-hook ()
  (when (member major-mode common/trailing-whitespace-modes)
    (delete-trailing-whitespace)))
(add-hook 'before-save-hook 'common/trailing-whitespace-hook)

;; Untabify based on mode
(setq common/untabify-modes '())
(defun common/untabify-hook ()
  (when (member major-mode common/untabify-modes)
    (untabify (point-min) (point-max))))
(add-hook 'before-save-hook 'common/untabify-hook)

(provide 'common)
