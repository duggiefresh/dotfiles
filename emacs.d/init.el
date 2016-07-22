(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(require 'evil)
(evil-mode 1)

;; Interactively Do Things
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; Automagically indent
(define-key global-map (kbd "RET") 'newline-and-indent)

;; Line numbers
(global-linum-mode 1)

;; Theme
(load-theme 'zenburn t)
