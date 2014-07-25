(require-package 'visual-regexp)

(define-key global-map (kbd "M-&") 'vr/query-replace)
(define-key global-map (kbd "M-/") 'vr/replace)

(provide 'init-visual-regexp)
