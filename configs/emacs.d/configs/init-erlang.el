(ignore-errors
  (require-package 'erlang))

(when (package-installed-p 'erlang)
  (require 'erlang-start))

(add-to-list 'common/trailing-whitespace-modes "erlang-mode")
(add-to-list 'common/untabify-modes "erlang-mode")

(provide 'init-erlang)
