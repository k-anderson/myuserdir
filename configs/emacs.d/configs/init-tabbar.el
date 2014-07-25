(require-package 'tabbar)

(tabbar-mode)
(global-set-key [(meta left)] 'tabbar-backward)
(global-set-key [(meta right)] 'tabbar-forward)

(provide 'init-tabbar)
