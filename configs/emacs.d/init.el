;; Sets user-emacs-directory to the current directory
(setq user-emacs-directory (file-name-directory (file-truename (or load-file-name buffer-file-name))))

;; Adds the configs folder to the load-path
(add-to-list 'load-path (expand-file-name "configs" user-emacs-directory))

;; Turn off mouse interface early in startup to avoid momentary display
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Inhibit startup messages
(setq-default inhibit-startup-message t)
(setq-default inhibit-startup-echo-area-message t)
(setq-default inhibit-startup-message t)
(setq-default inhibit-startup-screen t)

;; Set Indent Size
;; standard indent to 2 rather that 4
(setq-default standard-indent 2)

;; Turn Off Tab Character
(setq-default indent-tabs-mode nil)

;; Line-by-Line Scrolling
(setq-default scroll-step 1)

;; Prevent Backup File Creation
(setq-default make-backup-files nil)
(setq-default auto-save-default nil)

;; Enable Line and Column Numbering
(line-number-mode t)
(column-number-mode t)

;; Treat New Buffers as Text
(setq-default default-major-mode 'text-mode)

;; Make the last line end in a carriage retur
(setq-default require-final-newline t)

;; Allow just "y" instead of "yes" on exit
(fset 'yes-or-no-p 'y-or-n-p)

;; Disallow creation of new lines on  "arrow-down key" at end of the buffer
(setq-default next-line-add-newlines nil)

;; let's you delete with delete key
(delete-selection-mode t)

;; Highlight matching parentheses when the point is on them.
(show-paren-mode 1)

;; Delete the selected text just by hitting the backspace key
(delete-selection-mode 1)

;; Seed the random-number generator
(random t)

;; Fix whitespace on save, but only if the file was clean
(require 'whitespace)
(add-hook 'before-save-hook 'whitespace-cleanup)
;; (global-whitespace-cleanup-mode)

;; Use normal tabs in makefiles
(add-hook 'makefile-mode-hook 'indent-tabs-mode)

;; 
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

(require 'init-compat)

(require 'init-package)
(require 'init-tabbar)
(require 'init-themes)
(require 'init-auto-complete)
(require 'init-ido)
(require 'init-mmm)
(require 'init-visual-regexp)
(require 'init-flycheck)
(require 'init-git)
;; (require 'init-editing-utils)

(require 'init-erlang)
(require 'init-php)
(require 'init-css)
(require 'init-html)
;; (require 'init-javascript)
(require 'init-markdown)
(require 'init-python)
(require 'init-sql)
(require 'init-xml)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
