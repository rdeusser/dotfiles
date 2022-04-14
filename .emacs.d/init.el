(setq package-enable-at-startup nil)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(require 'use-package)

(setenv "GOPATH" (concat (getenv "HOME") "/go"))
(setenv "EDITOR" "emacsclient")
(setenv "CC" "/usr/local/opt/llvm/bin/clang -mlinker-version=450")

;; Disable kill-emacs because I always accidentally hit these keys.
(global-unset-key (kbd "C-x C-c"))

;; System - Ensure system packages are installed via homebrew
(use-package use-package-ensure-system-package
  :straight t
  :ensure t)

;; System - Automatically save place in files.
(use-package saveplace
  :straight t
  :ensure t
  :init
  (save-place-mode +1)
  (setq-default save-place t))

;; System - Get stuff from the shell
(use-package exec-path-from-shell
  :straight t
  :ensure t)

;; System - s.el Emacs string manipulation library.
(use-package s
  :straight t
  :ensure t)

;; System - Set tab sequence
(setq tab-stop-list (number-sequence 2 120 2))

;; System - Prevent Extraneous Tabs
(setq indent-tabs-mode nil)

;; System - Prevents some cases of Emacs flickering
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

;; System - Aliases
(defalias 'yes-or-no-p 'y-or-n-p) ;; y or n is enough

;; System - Initialize PATH on MacOS
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; System - Set backup directory
(defvar cache-dir (concat user-emacs-directory ".cache/"))
(setq backup-directory-alist `((".*" . ,(concat cache-dir "backup/"))))
(setq auto-save-list-file-prefix (concat cache-dir "autosave/"))
(setq auto-save-file-name-transforms `((".*" ,auto-save-list-file-prefix t)))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; System - Automatically revert buffers
(global-auto-revert-mode +1)

;; System - echo keystrokes faster than normal (default is 1)
(setq echo-keystrokes 0.1)

;; UI - Minimal
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)

;; UI - Column number mode
(column-number-mode +1)

;; UI - Set column to 80
(setq-default fill-column 80)

;; UI - Set auto-fill mode on in all major modes
;; (setq-default auto-fill-function 'do-auto-fill)

;; UI - Paste over region
(delete-selection-mode +1)

;; UI - Font
(set-face-attribute 'default nil
                    :family "Source Code Pro"
                    :height 100
                    :weight 'normal
                    :width 'normal)


(use-package gruber-darker-theme
  :straight t
  :ensure t
  :config
  (load-theme 'gruber-darker t))

;; (use-package kaolin-themes
;;   :straight t
;;   :ensure t
;;   :config
;;   (setq kaolin-themes-bold t)
;;   (setq kaolin-themes-italic t)
;;   (setq kaolin-themes-underline t)
;;   (load-theme 'kaolin-aurora t)
;;   (set-background-color "#07090A"))

;; UI - Theme
;; (use-package doom-themes
;;   :straight t
;;   :ensure t
;;   :config
;;   (load-theme 'doom-outrun-electric t)
;;   ;; (setq doom-gruvbox-dark-variant "hard")
;;   (setq doom-themes-enable-bold t)
;;   (setq doom-themes-enable-italic t)

;;   ;; Enable flashing mode-line on errors
;;   (doom-themes-visual-bell-config)

;;   ;; Corrects (and improves) org-mode's native fontification.
;;   (doom-themes-org-config))

;; UI - Show matching parens
(show-paren-mode +1)

;; UI - Fancy titlebar for MacOS
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
(setq ns-use-proxy-icon  nil)
(setq frame-title-format nil)

;; UI - Line numbers
(global-display-line-numbers-mode -1)

;; UI - Show ANSI colors
(use-package ansi-color
  :straight t
  :ensure t
  :config
  (defun display-ansi-colors ()
    (ansi-color-apply-on-region (point-min) (point-max)))

  (add-hook 'text-mode-hook 'display-ansi-colors))

;; UI - Undo tree
(use-package undo-tree
  :straight t
  :ensure t
  :config
  (global-undo-tree-mode +1)
  :custom
  (undo-tree-auto-save-history t)
  (undo-tree-visualizer-diff nil)
  (undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))))

(use-package centaur-tabs
  :straight t
  :ensure t
  :config
  (centaur-tabs-mode -1)
  (global-set-key (kbd "C-<prior>") 'centaur-tabs-backward)
  (global-set-key (kbd "C-<next>") 'centaur-tabs-forward))

;; UI - Improves the suggestions in counsel-M-x.
(use-package smex
  :straight t
  :ensure t)

;; UI - Ivy
(use-package ivy
  :straight t
  :ensure t
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  (enable-recursive-minibuffers t)
  ;; set ivy height relative to frame height
  (ivy-height-alist
   '((t
      lambda (_caller)
      (/ (frame-height) 2))))
  :config
  (global-set-key "\C-s" 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c g") 'counsel-git)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (global-set-key (kbd "C-c k") 'counsel-ag)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
  (ivy-mode +1))

(use-package ivy-rich
  :straight t
  :ensure t
  :after ivy)

;; UI - Swiper
(use-package swiper
  :straight t
  :ensure t)

;; UI - Counsel
(use-package counsel
  :straight t
  :ensure t
  :config
  (counsel-mode +1))

(use-package ws-butler
  :straight t
  :ensure t
  :config
  (ws-butler-global-mode +1))

;; Projectile
(use-package projectile
  :straight t
  :ensure t
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package counsel-projectile
  :straight t
  :ensure t
  :config
  (counsel-projectile-mode +1))

;; Terminal
(use-package vterm
  :straight t
  :ensure t)

;; LSP
(use-package lsp-mode
  :straight t
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (go-mode . lsp-deferred)
  :config
  (setq lsp-go-use-gofumpt t)
  (setq lsp-enable-semantic-highlighting t)
  (defalias 'fill 'lsp-execute-code-action))

;; LSP - UI
(use-package lsp-ui
  :straight t
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-psoition 'at-point))

;; Company mode is a standard completion package that works well with lsp-mode.
(use-package company
  :straight t
  :ensure t
  :config
  ;; Optionally enable completion-as-you-type behavior.
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1)
  (setq company-lsp-cache-candidates 'auto)
  (setq company-lsp-async t)
  (setq company-lsp-enable-snippet t)
  (setq company-lsp-enable-recompletion t))

;; Electric pair - automatically insert matching delimiters.
(electric-pair-mode +1)

;; Git
(use-package magit
  :straight t
  :ensure t
  :ensure-system-package git)

;; Multiple cursors (multiedit)
(use-package multiple-cursors
  :straight t
  :ensure t)

;; Uses a single command to format a variety of languages.
(use-package format-all
  :straight t
  :ensure t
  :config
  (defalias 'fmt 'format-all-buffer))

;; Fish
(use-package fish-mode
  :straight t
  :ensure t
  :ensure-system-package fish)

;; Go
(use-package go-mode
  :straight t
  :ensure t
  :ensure-system-package go
  :config
  (add-to-list 'auto-mode-alist '("\\.golden\\'" . text-mode))
  (setq gofmt-command "gofumpt")
  ;; Set up before-save hooks to format buffer and add/delete imports.
  ;; Make sure you don't have other gofmt/goimports hooks enabled.
  (defun lsp-go-install-save-hooks ()
    (add-hook 'before-save-hook #'lsp-format-buffer t t)
    (add-hook 'before-save-hook #'lsp-organize-imports t t))
  (add-hook 'go-mode-hook #'lsp-go-install-save-hooks))

;; Go - add tags to structs
(use-package go-add-tags
  :straight t
  :ensure t
  :config
  (setq go-add-tags-style 'lower-camel-case)
  (define-key go-mode-map (kbd "C-c t") #'go-add-tags))

;; Web
(use-package web-mode
  :straight t
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.liquid\\'" . web-mode))

  (setq web-mode-enable-css-colorization t)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-enable-current-column-highlight t)

  (defun set-indent-web-mode-hook ()
    "Hooks for Web mode."
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-css-indent-offset 2)
    (setq web-mode-code-indent-offset 2))

  (add-hook 'web-mode-hook  'set-indent-web-mode-hook))

;; Markdown
(use-package markdown-mode
  :straight t
  :ensure t)

;; YAML
(use-package yaml-mode
  :straight t
  :ensure t)

;; JSON
(use-package json-mode
  :straight t
  :ensure t
  :ensure-system-package
  ((jq)
   (sponge . moreutils))
  :config
  (defun jqfmt ()
    "Format the current file with jq and reload the buffer"
    (interactive)
    (shell-command
     (format "jq '.' %s | sponge %s"
             (shell-quote-argument (buffer-file-name))
	     (shell-quote-argument (buffer-file-name))))
    (revert-buffer t t t)))

;; Typescript
(use-package typescript-mode
  :straight t
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode)))

;; Dockerfile
(use-package dockerfile-mode
  :straight t
  :ensure t)

;; Jsonnet
(use-package jsonnet-mode
  :straight t
  :ensure t)

;; C# / .NET core
(use-package csharp-mode
  :straight t
  :ensure t
  :config
  (defun my-csharp-mode-setup ()
    ;; (omnisharp-mode)
    (company-mode)
    (flycheck-mode)
    (c-set-style "k&r")

    (setq indent-tabs-mode nil)
    (setq c-syntactic-indentation t)
    (setq c-basic-offset 4)
    (setq truncate-lines t)
    (setq tab-width 4)
    (setq evil-shift-width 4)

    (electric-pair-local-mode +1)

    (local-set-key (kbd "C-c r r") 'omnisharp-run-code-action-refactoring)
    (local-set-key (kbd "C-c C-c") 'recompile))

  (add-hook 'csharp-mode-hook 'my-csharp-mode-setup t)
  (add-hook 'csharp-mode-hook #'flycheck-mode))

;; C# / .NET core
(use-package omnisharp
  :straight t
  :ensure t)

;; Protocol Buffers/gRPC
(use-package protobuf-mode
  :straight t
  :ensure t)

;; Rust
(use-package rust-mode
  :straight t
  :ensure t)

;; EditorConfig
(use-package editorconfig
  :straight t
  :ensure t
  :config
  (editorconfig-mode +1))

;; Terraform
(use-package terraform-mode
  :straight t
  :ensure t)

;; Swift
(use-package swift-mode
  :straight t
  :ensure t)

;; PowerShell
(use-package powershell
  :straight t
  :ensure t)

;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(ansi-color-names-vector
;;    ["#14191e" "#e55c7a" "#31E183" "#f5c791" "#4ca6e8" "#9d81ba" "#49bdb0" "#e6e6e8"])
;;  '(custom-safe-themes
;;    '("0c6a36393d5782839b88e4bf932f20155cb4321242ce75dc587b4f564cb63d90" "23c0dc923626f1186edf9ed406dad5358477434d635ea90012e93863531a97b3" default))
;;  '(global-display-fill-column-indicator-mode nil)
;;  '(package-selected-packages
;;    '(ws-butler smex ivy-posframe rust-mode use-package use-package-ensure-system-package exec-path-from-shell s doom-themes undo-tree centaur-tabs ivy ivy-rich swiper counsel projectile counsel-projectile vterm lsp-mode lsp-ui company smartparens magit multiple-cursors format-all fish-mode go-mode dart-mode web-mode markdown-mode yaml-mode json-mode typescript-mode dockerfile-mode jsonnet-mode csharp-mode protobuf-mode editorconfig))
;;  '(pos-tip-background-color "#191F26")
;;  '(pos-tip-foreground-color "#d4d4d6"))
;; (put 'upcase-region 'disabled nil)
;; (put 'downcase-region 'disabled nil)
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(fringe ((t (:background "#0A0C0D" :foreground "#e6e6e8"))))
;;  '(line-number ((t (:background "#0A0C0D" :foreground "#454459" :strike-through nil :underline nil :slant normal :weight normal)))))
