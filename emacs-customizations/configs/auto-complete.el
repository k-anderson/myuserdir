(add-to-list 'load-path (concat emacs-dir "vendor/auto-complete"))
(require 'auto-complete)

(add-to-list 'ac-dictionary-directories (concat emacs-dir "vendor/auto-complete/dict"))

(require 'auto-complete-config)
(ac-config-default)

(setq-default ac-sources '(
;;        ac-source-yasnippet
          ac-source-semantic
;;        ac-source-imenu
          ac-source-abbrev
;;        ac-source-words-in-buffer
          ac-source-words-in-same-mode-buffers
;;        ac-source-files-in-current-dir
          ac-source-dictionary
          ac-source-filename)
)
