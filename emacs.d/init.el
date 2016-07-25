;;; init.el --- Dug's WIP init.el

;;; Commentary:

;;; Code:
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

;;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package company
  :ensure t
  :defer t)
(add-hook 'after-init-hook 'global-company-mode)

(use-package elixir-mode
  :ensure t)

(use-package alchemist
  :ensure t)

;;; Evil key mapping
(setq evil-want-C-u-scroll t
      evil-want-C-w-in-emacs-state t)
(use-package evil)
(evil-mode 1)

(use-package evil-leader
  :ensure t)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package helm
  :ensure t)
(require 'helm)
(require 'helm-config)

(use-package helm-projectile
  :ensure t)

(use-package js2-mode
  :ensure t)

(use-package magit
  :ensure t)
(global-set-key (kbd "C-x g") 'magit-status)

(use-package projectile
  :ensure t)

(use-package smex
  :ensure t)

(use-package which-key
  :ensure t)
(which-key-mode)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;;; Helm
;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))
(global-set-key (kbd "M-X") 'helm-M-x)
(setq helm-M-x-fuzzy-match t) ;;; Helm fuzzy matching
(global-set-key (kbd "C-x C-f") 'helm-find-files)

(define-key helm-map (kbd "<tab>")
  'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i")
  'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")
  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

(helm-mode 1)

(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

;;; Evil leader
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")
;;; Projectile
(evil-leader/set-key
  "f" 'projectile-find-file
  "d" 'projectile-find-dir)

;;; Interactively Do Things
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;;; Line numbers
(global-linum-mode 1)

;;; Setup `ibuffer`
(global-set-key (kbd "C-x C-b") 'ibuffer)

;;; Turn off the tool bar and menu bar
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;;; Turn off jshint
(setq-default flycheck-disabled-checkers '(javascript-jshint))

;;; Smex
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;;; Deal with trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq-default indent-tabs-mode nil)
(setq js-indent-level 2)

(provide 'init.el)
;;; init.el ends here
