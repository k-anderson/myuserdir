(add-to-list 'load-path (concat emacs-dir "vendor/smartchr"))
(require 'smartchr)

(global-set-key (kbd "=") (smartchr '(" = " " == " " === ")))
