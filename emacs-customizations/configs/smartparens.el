(add-to-list 'load-path (concat emacs-dir "vendor/smartparens"))
(require 'smartparens)
(add-hook 'prog-mode-hook 'turn-on-smartparens-strict-mode)
(add-hook 'markdown-mode-hook 'turn-on-smartparens-strict-mode)
