;; erlang-mode configuration
(defun erlang-setup ()
  (if (and (file-exists-p "/usr/lib64/")
    (file-exists-p "/usr/lib64/erlang"))
      (setq erlang-basefolder "/usr/lib64/erlang")
    (if (and (file-exists-p "/usr/lib/")
      (file-exists-p "/usr/lib/erlang"))
 (setq erlang-basefolder "/usr/lib/erlang")))
  (if erlang-basefolder
      (progn
 (let ((lib-folder (concat erlang-basefolder "/lib")))
   (dolist (fldr (directory-files lib-folder))
     (if (and 
   (> (length fldr) 6)
   (string= (substring fldr 0 6) "tools-"))
   (setq erlang-tools-dir (concat lib-folder (concat "/" fldr)))))
   (setq load-path (cons (concat erlang-tools-dir "/emacs") load-path))
   (setq erlang-root-dir erlang-basefolder)
   (setq exec-path (cons (concat erlang-basefolder "/bin")  exec-path))
   (require 'erlang-start)
   (add-to-list 'auto-mode-alist '("\\.erl?$" . erlang-mode))
   (add-to-list 'auto-mode-alist '("\\.hrl?$" . erlang-mode))))))

(erlang-setup)

(defun erlang-machine-name ()
  (format "%s-emacs" user-login-name))

(setq inferior-erlang-machine-options '("-name" "emacs"))

;; --flymake
(defun flymake-erlang-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake/create-temp-file))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list (concat emacs-dir "flymake/erlang/flymake.sh") (list local-file buffer-file-name))))
(add-to-list 'flymake-allowed-file-name-masks '("\\.erl\\'" flymake-erlang-init flymake/cleanup))

(defun my-erlang-mode-hook ()
  ;; style customization
  (setq tab-width 2)
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 2)
  (local-set-key "\C-c:" 'uncomment-region)
  (local-set-key "\C-c%" 'comment-region)
  (local-set-key "\C-c\C-c" 'comment-region)

  ;; local keys
  (local-set-key [return] 'newline-and-indent)

  ;; helpers
  (flymake-mode 1)
)
(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)

;; --auto-complete
(add-to-list 'ac-modes 'erlang-mode)

;; --commons
;;(add-hook 'erlang-mode-common-hook 'commons/show-prog-keywords)
(add-to-list 'commons/trailing-whitespace-modes "erlang-mode")
(add-to-list 'commons/untabify-modes "erlang-mode")

;; This is needed for Distel setup
(let ((distel-dir (concat emacs-dir "vendor/distel/elisp")))
  (unless (member distel-dir load-path)
    ;; Add distel-dir to the end of load-path
    (setq load-path (append load-path (list distel-dir)))))

(require 'distel)
(distel-setup)

;; A number of the erlang-extended-mode key bindings are useful in the shell too
(defconst distel-shell-keys
  '(("\C-\M-i"   erl-complete)
    ("\M-?"      erl-complete)
    ("\M-."      erl-find-source-under-point)
    ("\M-,"      erl-find-source-unwind)
    ("\M-*"      erl-find-source-unwind)
    )
  "Additional keys to bind when in Erlang shell.")

(add-hook 'erlang-shell-mode-hook
          (lambda ()
            ;; add some Distel bindings to the Erlang shell
            (dolist (spec distel-shell-keys)
              (define-key erlang-shell-mode-map (car spec) (cadr spec)))))

;; --ensure semantic is ready
;;(load-library "semantic-erlang")

;; --compile
(add-hook 'erlang-mode-hook (lambda () (set (make-local-variable 'compile-command) (format "cd %s; make" (get-closest-pathname)))))
