;; erlang-mode configuration
;; change this directory  to your Erlang root dir.
(setq erlang-root-dir "/usr/lib/erlang")
(setq erlang-tools-dir (car (file-expand-wildcards (concat erlang-root-dir "/lib/tools-*"))))

(defun erlang-machine-name ()
  (format "%s-emacs" user-login-name))

(when (file-directory-p erlang-root-dir)
  (when (file-directory-p (concat erlang-tools-dir "/emacs"))

    (setq load-path (cons (concat erlang-tools-dir "/emacs") load-path))
    (setq exec-path (cons (concat erlang-root-dir "/bin") exec-path))
    (require 'erlang-start)

    ;; when starting an Erlang shell in Emacs, the node name
    ;; by default should be "emacs"
    (setq inferior-erlang-machine-options '("-name" "emacs"))

    (add-to-list 'auto-mode-alist '("\\.erl?$" . erlang-mode))
    (add-to-list 'auto-mode-alist '("\\.hrl?$" . erlang-mode))
    )
  )

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
(add-to-list 'commons/trailing-whitespace-modes 'erlang-mode)
(add-to-list 'commons/untabify-modes 'erlang-mode)

;; This is needed for Distel setup
(let ((distel-dir (concat emacs-dir "vendor/distel/elisp")))
  (unless (member distel-dir load-path)
    ;; Add distel-dir to the end of load-path
    (setq load-path (append load-path (list distel-dir)))))

(require 'distel)
(distel-setup)
(require 'auto-complete-distel)

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
(load-library "semantic-erlang")

;; --compile
(add-hook 'erlang-mode-hook (lambda () (set (make-local-variable 'compile-command) (format "cd %s; make" (get-closest-pathname)))))                                                                         
