;;; init.el --- Dug's WIP init.el

;;; Commentary:

;;; Code:
(require 'package)
(setq package-archives '(("melpa" . "http://melpa.org/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))

(add-to-list 'package-archives
             '("org" . "http://orgmode.org/elpa/"))

(package-initialize)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; (menu-bar-mode -1)

;;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package exec-path-from-shell)

(use-package company
  :ensure t
  :defer t)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-dabbrev-downcase nil)

(use-package deadgrep
  :ensure t)

(use-package drag-stuff
  :ensure t)
(drag-stuff-global-mode 1)
(drag-stuff-define-keys)

(use-package elixir-mode
  :ensure t)

(require 'eglot)
(add-hook 'elixir-mode-hook 'eglot-ensure)
(add-to-list 'eglot-server-programs '(elixir-mode "~/oss/elixir-ls/language_server.sh"))

(use-package eradio
  :ensure t
  :init
  (setq eradio-player '("mpv" "--no-video" "--no-terminal"))
  (setq eradio-channels '(("soma fm - Groove Salad" . "https://somafm.com/groovesalad130.pls")
                          ("soma fm - Groove Salad Classic" . "https://somafm.com/gsclassic130.pls")
                          ("soma fm - Heavyweight Reggae" . "https://somafm.com/reggae130.pls")
                          ("soma fm - Underground 80s" . "https://somafm.com/u80s130.pls")
                          ("soma fm - Dubstep Beyond" . "https://somafm.com/dubstep130.pls"))))

;;; Evil key mapping
(setq evil-want-C-u-scroll t
      evil-want-C-w-in-emacs-state t
      evil-want-C-i-jump nil)
(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package evil-escape
  :ensure t)

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

(add-to-list 'display-buffer-alist
             `(,(rx bos "*Flycheck errors*" eos)
              (display-buffer-reuse-window
               display-buffer-in-side-window)
              (side            . bottom)
              (reusable-frames . visible)
              (window-height   . 0.33)))

(use-package flycheck-rust
  :ensure t
  :config (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))
(push 'rustic-clippy flycheck-checkers)
(setq rustic-flycheck-clippy-params "--message-format=json")

(use-package helm
  :ensure t)
(require 'helm)

(use-package helm-ag
  :ensure t)

(use-package helm-projectile
  :ensure t)

(use-package js2-mode
  :ensure t)

(use-package rjsx-mode
  :ensure t)

(use-package magit
  :ensure t)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc"))

(use-package projectile
  :ensure t)

(use-package rustic
  :hook
  (rust-mode . lsp-deferred)
  (rust-mode . company-mode)
  :custom
  (rustic-format-on-save t)
  (rustic-indent-method-chain t))
(setq rustic-lsp-client 'eglot)

(use-package smartparens
  :ensure t
  :config
  (smartparens-global-mode t))

(use-package smex
  :ensure t)

;; (use-package spell-fu
;;   :ensure t)
;; (add-hook 'org-mode-hook
;;   (lambda ()
;;     (setq spell-fu-faces-exclude '(org-meta-line org-link org-code))
;;     (spell-fu-mode)))

(add-hook 'markdown-mode-hook
  (lambda ()
    (spell-fu-mode)))

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-no-png-images t))
  )

(use-package treemacs-evil
  :after treemacs evil
  :ensure t)

(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)

(use-package treemacs-magit
  :after treemacs magit
  :ensure t)

(use-package web-mode
  :ensure t
  :mode
  (("\\.css\\'" . web-mode)
   ("\\.eex\\'" . web-mode)
   ("\\.hbs\\'" . web-mode)
   ("\\.html\\'" . web-mode)
   ("\\.js\\'" . web-mode)
   ("\\.json\\'" . web-mode)
   ("\\.jsx\\'" . web-mode)
   ("\\.scss\\'" . web-mode)
   ("\\.svelte\\'" . web-mode)
   ("\\.ts\\'" . web-mode)
   ("\\.tsx\\'" . web-mode))
  :commands web-mode
  :config
  (setq web-mode-content-types-alist
        '(("jsx" . "\\.js[x]?\\'")))
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (web-mode-script-padding 2)
  (web-mode-style-padding 2)
  )
;; (setq web-mode-html-tag-face nil :foreground "gray50")

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

;;; Org mode

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-switchb)
(setq org-log-done 'time)
(setq org-log-done 'note)
(setq org-startup-indented t)
(add-hook 'org-mode-hook #'toggle-word-wrap)

(setq evil-emacs-state-modes (delq 'ibuffer-mode evil-emacs-state-modes))
;;; Evil leader
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
  "<SPC>" 'save-buffer
  "a" 'deadgrep
  "b" 'helm-mini
  "c" 'evilnc-comment-or-uncomment-lines
  "d" 'dired
  "e" 'flycheck-list-errors
  "fd" 'helm-projectile-find-dir
  "ff" 'helm-projectile-find-file
  "g" 'magit-status
  "n" 'treemacs
  "p" 'helm-projectile-switch-project
  "s" 'split-window-horizontally
  "x" 'smex
  "v" 'split-window-vertically)
(global-set-key (kbd "C-SPC") 'evil-escape)

;;; Magit
(global-set-key (kbd "C-x g") 'magit-status)

;;; Setup `ibuffer`
(global-set-key (kbd "C-x C-b") 'ibuffer)

;;; Smex
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;;; Dired
(evil-define-key 'normal dired-mode-map "c" 'find-file)
(evil-define-key 'normal dired-mode-map "p" 'dired-up-directory)
;; (evil-define-key 'normal dired-mode-map "n" 'evil-search-next)
;; (evil-define-key 'normal dired-mode-map "N" 'evil-search-previous)

(add-hook 'dired-load-hook
          (lambda ()
            (require "dired-x")
            ;; Set dired-x global variables here.  For example:
            ;; (setq dired-guess-shell-gnutar "gtar")
            ;; (setq dired-x-hands-off-my-keys nil)
            ))
(setq dired-omit-mode t)

;;; JS setup
(setq-default indent-tabs-mode nil)
(setq js-indent-level 2)
;;; Turn off jshint
(setq-default flycheck-disabled-checkers '(javascript-jshint))
;;; Elixir setup
(add-hook 'elixir-mode-hook (lambda ()
                            (setq evil-shift-width 2)
                            (setq tab-width 2)))

;;; Markdown setup
(add-hook 'text-mode-hook 'auto-fill-mode)
(setq-default fill-column 80)

;;; Line numbers, column numbers
(global-linum-mode 1)
(column-number-mode 1)
(setq linum-format "%4d \u2502")

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
(add-hook 'dired-mode-hook 'auto-revert-mode)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))
(setq ring-bell-function 'ignore)

(setq-default word-wrap t)

;;;
(cond
 ((string-equal system-type "darwin") ; macOS
  (when (member "Source Code Pro" (font-family-list))
    (set-frame-font "Source Code Pro-14" t t)))
 ((string-equal system-type "gnu/linux") ; linux
  (when (member "DejaVu Sans Mono" (font-family-list))
    (set-frame-font "DejaVu Sans Mono" t t)))

 ((executable-find "aspell")
  (setq ispell-program-name "aspell")
  ;; Please note ispell-extra-args contains ACTUAL parameters passed to aspell
  (setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_US"))))

(defun elixir/find-mix-project (dir)
  "Try to locate a Elixir project root by 'mix.exs' above DIR."
  (let ((mix_root (locate-dominating-file dir "mix.exs")))
    (message "Found Elixir project root in '%s' starting from '%s'" mix_root dir)
    (if (stringp mix_root) `(transient . ,mix_root) nil)))

(add-hook 'project-find-functions 'elixir/find-mix-project nil nil)

 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
(load-theme 'solarized-light t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#ffffff" "#c82829" "#718c00" "#eab700" "#4271ae" "#8959a8" "#3e999f" "#4d4d4c"))
 '(beacon-color "#c82829")
 '(compilation-message-face 'default)
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-enabled-themes '(sanityinc-tomorrow-night))
 '(custom-safe-themes
   '("4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "7f1d414afda803f3244c6fb4c2c64bea44dac040ed3731ec9d75275b9e831fe5" "37768a79b479684b0756dec7c0fc7652082910c37d8863c35b702db3f16000f8" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347" "0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f" default))
 '(fci-rule-color "#d6d6d6")
 '(flycheck-color-mode-line-face-to-color 'mode-line-buffer-id)
 '(frame-background-mode 'light)
 '(helm-completion-style 'emacs)
 '(helm-minibuffer-history-key "M-p")
 '(highlight-changes-colors '("#d33682" "#6c71c4"))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#002b36" 0.25)
    '("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2")))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
   '(("#073642" . 0)
     ("#546E00" . 20)
     ("#00736F" . 30)
     ("#00629D" . 50)
     ("#7B6000" . 60)
     ("#8B2C02" . 70)
     ("#93115C" . 85)
     ("#073642" . 100)))
 '(hl-bg-colors
   '("#7B6000" "#8B2C02" "#990A1B" "#93115C" "#3F4D91" "#00629D" "#00736F" "#546E00"))
 '(hl-fg-colors
   '("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36"))
 '(hl-paren-colors '("#2aa198" "#b58900" "#268bd2" "#6c71c4" "#859900"))
 '(lsp-ui-doc-border "#93a1a1")
 '(nrepl-message-colors
   '("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D" "#2aa198" "#d33682" "#6c71c4"))
 '(package-selected-packages
   '(treemacs eradio evil-magit nord-theme rustic zzz-to-char lsp-elixir evil-collection which-key web-mode use-package solarized-theme smex rjsx-mode markdown-mode magit helm-projectile helm-ag flycheck exec-path-from-shell evil-surround evil-nerd-commenter evil-matchit evil-leader evil-escape drag-stuff color-theme-sanityinc-tomorrow alchemist))
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(rustic-ansi-faces
   ["black" "red3" "green3" "yellow3" "DodgerBlue" "magenta3" "cyan3" "white"])
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   '((20 . "#c82829")
     (40 . "#f5871f")
     (60 . "#eab700")
     (80 . "#718c00")
     (100 . "#3e999f")
     (120 . "#4271ae")
     (140 . "#8959a8")
     (160 . "#c82829")
     (180 . "#f5871f")
     (200 . "#eab700")
     (220 . "#718c00")
     (240 . "#3e999f")
     (260 . "#4271ae")
     (280 . "#8959a8")
     (300 . "#c82829")
     (320 . "#f5871f")
     (340 . "#eab700")
     (360 . "#718c00")))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   '(unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83"))
 '(window-divider-mode nil)
 '(xterm-color-names
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#eee8d5"])
 '(xterm-color-names-bright
   ["#002b36" "#cb4b16" "#586e75" "#657b83" "#839496" "#6c71c4" "#93a1a1" "#fdf6e3"]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-comment-tag ((t (:foreground "systemBlueColor"))))
 '(custom-variable-obsolete ((t (:foreground "systemBlueColor"))))
 '(epa-string ((t (:foreground "systemBlueColor"))))
 '(message-header-xheader ((t (:foreground "systemBlueColor"))))
 '(org-drawer ((t (:foreground "systemBlueColor"))))
 '(rustic-popup-key ((t (:foreground "RoyalBlue1"))))
 '(transient-blue ((t (:inherit transient-key :foreground "dodger blue")))))
