;; Load Cedet
(load-file (concat emacs-dir "vendor/cedet-1.1/common/cedet.el"))

(semantic-load-enable-minimum-features)
(semantic-load-enable-code-helpers)
(semantic-load-enable-all-exuberent-ctags-support)
;;(semantic-load-enable-gaudy-code-helpers)
;;(semantic-load-enable-excessive-code-helpers)

(setq-mode-local erlang-mode semanticdb-find-default-throttle
                  '(project unloaded system recursive))

(require 'speedbar)
(speedbar 1)
