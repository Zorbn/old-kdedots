;; My EMACS config
;; Remember to install all-the-icons! It is necessary for doom-modeline!

;; Minimal UI
(setq inhibit-startup-message t)
(setq frame-resize-pixelwise t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Theme
(set-face-attribute 'default nil :font "Hack-12")
(add-to-list 'default-frame-alist '(font . "Hack-12"))

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold nil
        doom-themes-enable-italic t)
  (load-theme 'doom-flatwhite t)

  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom")
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :custom ((doom-modeline-height 30))) ; For best appearance, height should exceed font height

;; Input
(setq mouse-wheel-progressive-speed nil)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; Use ESC to exit

;; Icons
(use-package all-the-icons
  :if (display-graphic-p))

;; Smooooooooooooooth
(setq scroll-step            1
      scroll-conservatively  10000)

;; Completion
(use-package swiper
  :bind (("C-s" . swiper)))

(use-package ivy
  :diminish
  :bind (:map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel   
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^

;; Dedicated backup directory
(setq backup-directory-alist
  `(("." . ,(concat user-emacs-directory "backups/"))))
(setq auto-save-file-name-transforms
  `((".*" "~/.emacs.d/saves/" t)))

;; Line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)

(dolist (mode '(org-mode-hook
   		term-mode-hook
        	eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Indentation
(setq-default electric-indent-inhibit t)

(setq-default indent-tabs-mode nil)

(global-set-key (kbd "C->") 'indent-rigidly-right-to-tab-stop)
(global-set-key (kbd "C-<") 'indent-rigidly-left-to-tab-stop)

;; Which Key
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;; Keep customize seperate and temporary
(setq custom-file (make-temp-file "emacs-custom.el"))

;; Language Server
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook ((lsp-mode . lsp-enable-which-key-integration))
  :commands lsp lsp-deferred)

(use-package lsp-ui :commands lsp-ui-mode)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package csharp-mode
  :mode "\\.cs\\'"
  :hook (csharp-mode . lsp-deferred))

;; LSP Completions
(use-package company
  :after lsp-mode
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

;; Performance
;; Necessary due to lsp servers using more resources than base emacs

(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))
