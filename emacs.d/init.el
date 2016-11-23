;;; init.el --- Dug's WIP init.el

;;; Commentary:

;;; Code:
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))

(package-initialize)

;;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package color-theme-sanityinc-tomorrow
  :ensure t)

(use-package company
  :ensure t
  :defer t)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-dabbrev-downcase nil)

(use-package drag-stuff
  :ensure t)
(drag-stuff-global-mode 1)
(drag-stuff-define-keys)

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

(use-package evil-matchit
  :ensure t)
(global-evil-matchit-mode 1)

(use-package evil-nerd-commenter
  :ensure t)
(evilnc-default-hotkeys)

(use-package evil-surround
  :ensure t)
(global-evil-surround-mode 1)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package helm
  :ensure t)
(require 'helm)
(require 'helm-config)

(use-package helm-ag
  :ensure t)

(use-package helm-projectile
  :ensure t)

(use-package js2-mode
  :ensure t)

(use-package magit
  :ensure t)

(use-package neotree
  :ensure t)

(use-package projectile
  :ensure t)

(use-package smex
  :ensure t)

(use-package web-mode
  :ensure t)
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.hbs?\\'" . web-mode))
(setq web-mode-markup-indent-offset 2)

(use-package which-key
  :ensure t)
(which-key-mode)

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

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
(global-set-key (kbd "C-x b") 'helm-mini)

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
      helm-ff-file-name-history-use-recentf t
      helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match t)

(helm-mode 1)

(projectile-global-mode)
(setq projectile-switch-project-action 'projectile-dired)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

(setq evil-emacs-state-modes (delq 'ibuffer-mode evil-emacs-state-modes))
;;; Evil leader
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
  "<SPC>" 'save-buffer
  "a" 'helm-ag-project-root
  "b" 'helm-mini
  "c" 'evilnc-comment-or-uncomment-lines
  "d" 'dired
  "fd" 'projectile-find-dir
  "ff" 'projectile-find-file
  "g" 'magit-status
  "nn" 'neotree-toggle'
  "nf" 'neotree-find'
  "p" 'helm-projectile-switch-project
  "s" 'split-window-horizontally
  "v" 'split-window-vertically)

;;; Neotree
(evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
(evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
(setq neo-theme (if window-system 'ascii 'arrow))

;;; Magit
(global-set-key (kbd "C-x g") 'magit-status)

;;; Setup `ibuffer`
(global-set-key (kbd "C-x C-b") 'ibuffer)

;;; Smex
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;;; Dired
(define-key dired-mode-map "c" 'find-file)
(evil-define-key 'normal dired-mode-map "n" 'evil-search-next)
(evil-define-key 'normal dired-mode-map "N" 'evil-search-previous)
(evil-define-key 'normal dired-mode-map "p" 'dired-up-directory)

(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")
            ;; Set dired-x global variables here.  For example:
            ;; (setq dired-guess-shell-gnutar "gtar")
            ;; (setq dired-x-hands-off-my-keys nil)
            ))
(add-hook 'dired-mode-hook
          (lambda ()
            ;; Set dired-x buffer-local variables here.  For example:
              (dired-omit-mode 1)
            ))

;;; JS setup
(setq-default indent-tabs-mode nil)
(setq js-indent-level 2)
;;; Turn off jshint
(setq-default flycheck-disabled-checkers '(javascript-jshint))
;;; Elixir setup
(add-hook 'elixir-mode-hook (lambda ()
                            (setq evil-shift-width 2)
                            (setq tab-width 2)))

;;; Line numbers, column numbers
(global-linum-mode 1)
(column-number-mode 1)

(setq show-paren-delay 0)
(show-paren-mode 1)

;;; Deal with trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;; Turn off the GUI's tool bar
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(setq-default frame-title-format "%f")

;;; Undo windows
(winner-mode 1)

;;; SMELL YA LATER LOCKFILES
(setq create-lockfiles nil)

;;; Auto reload all files from disk
(global-auto-revert-mode t)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;;;
(cond
 ((executable-find "aspell")
  (setq ispell-program-name "aspell")
  ;; Please note ispell-extra-args contains ACTUAL parameters passed to aspell
  (setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_US"))))

 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#c5c8c6" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#b294bb" "#8abeb7" "#373b41"))
 '(custom-enabled-themes (quote (sanityinc-tomorrow-day)))
 '(custom-safe-themes
   (quote
    ("bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" default)))
 '(fci-rule-color "#373b41")
 '(package-selected-packages
   (quote
    (evil-nerd-commenter neotree which-key web-mode use-package spaceline smex magit js2-mode helm-projectile helm-ag flycheck exec-path-from-shell evil-surround evil-matchit evil-leader alchemist)))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#cc6666")
     (40 . "#de935f")
     (60 . "#f0c674")
     (80 . "#b5bd68")
     (100 . "#8abeb7")
     (120 . "#81a2be")
     (140 . "#b294bb")
     (160 . "#cc6666")
     (180 . "#de935f")
     (200 . "#f0c674")
     (220 . "#b5bd68")
     (240 . "#8abeb7")
     (260 . "#81a2be")
     (280 . "#b294bb")
     (300 . "#cc6666")
     (320 . "#de935f")
     (340 . "#f0c674")
     (360 . "#b5bd68"))))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
)
