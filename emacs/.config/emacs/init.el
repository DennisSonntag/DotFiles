;; Initialize package sources
(require 'package)			
(eval-when-compile (require 'use-package)) 
(require 'bind-key)			   

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                        ("org" . "https://orgmode.org/elpa/")
                        ("elpa" . "https://elpa.gnu.org/packages/")))

(setq package-enable-at-startup nil)
(package-initialize)
(unless package-archive-contents (package-refresh-contents))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(setq inhibit-startup-message t); Disable Startup screen
(scroll-bar-mode -1)            ; Disable visible scrollbar
(tool-bar-mode -1)              ; Disable the toolbar
(tooltip-mode -1)               ; Disable tooltips
(set-fringe-mode 0)             ; Disable Padding
(menu-bar-mode -1)              ; Disable the menu bar
(setq visible-bell nil)         ; Disable visible-bell

;; Transparent background
(add-to-list 'default-frame-alist '(alpha-background . 90))

;; Setup line numbers
(setq display-line-numbers-type 'relative)
(column-number-mode)
(global-display-line-numbers-mode t)
;; Disable Line numbers tor some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                eshell-mode-hook))
(add-hook mode (lambda () (display-line-numbers-mode 0))))

(defun efs/set-font-faces ()
    (message "Setting faces!")

    (set-face-attribute 'default nil :font "JetBrainsMono NF" :height 150)
    (set-face-attribute 'fixed-pitch nil :font "JetBrainsMono NF" :height 150)
    (set-face-attribute 'variable-pitch nil :font "Roboto" :height 150 :weight 'regular))

(if (daemonp)
    (add-hook 'after-make-frame-functions
            (lambda (frame)
                (setq doom-modeline-icon t)
                (with-selected-frame frame
                (efs/set-font-faces))))
    (efs/set-font-faces))

(setq scroll-margin 8
    scroll-conservatively 101
    scroll-up-aggressively 0.01
    scroll-down-aggressively 0.01
    scroll-preserve-screen-position t
    auto-window-vscroll nil)

(setq warning-minimum-level :emergency)
(setq byte-compile-warnings '(not docstrings) )
  ;; Make ESC quit prompts
  (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

  ;; Highlight cursorline
  (global-hl-line-mode 1)

  (auto-revert-mode 1)

  ;; Backup files
  ;; Write backups to ~/.emacs.d/backup/
  (setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying      t  ; Don't de-link hard links
      version-control        t  ; Use version numbers on backups
      delete-old-versions    t  ; Automatically delete excess backups:
      kept-new-versions      20 ; how many of the newest versions to keep
      kept-old-versions      5) ; and how many of the old

(use-package counsel
    :bind (("M-x" . counsel-M-x)
        ("C-x b" . counsel-ibuffer)
        ("C-x C-f" . counsel-find-file)
        :map minibuffer-local-map
        ("C-r" . 'counsel-minibuffer-history))
    :config
(setq ivy-initial-inputs-alist nil));; Don't start searches with ^

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
        :map ivy-minibuffer-map
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

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; M-X all-the-icons-install-fonts
(use-package all-the-icons)

; Install doom statusline (be sure to run `M-x nerd-icons-install-fonts`)
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap desbcribe-command] . helpful-command)
  ([remap describe-variable] . counsl-describe-variable)
  ([remap describe-key] . helpful-key))

;; Colorscheme
(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-tokyo-night t)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package general
      :ensure t
      :after evil
      :config
      (general-create-definer tyrant-def
        :states '(normal insert motion emacs)
        :keymaps 'override
        :prefix "SPC"
        :non-normal-prefix "M-SPC")
      (tyrant-def "" nil)

      (tyrant-def
        "sv" 'evil-window-vsplit
        "sh" 'evil-window-split
        "y" 'clipboard-kill-ring-save
        "p" 'clipboard-yank))
(setq x-select-enable-clipboard nil)
(setq x-select-enable-primary nil)

;; Vim keybinds
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)
  (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
  (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
  (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)

  (define-key evil-normal-state-map (kbd "C-q") 'evil-window-delete)

  (define-key evil-normal-state-map (kbd "-") 'dired-jump)


  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; Org Mode Configuration ------------------------------------------------------

  (defun efs/org-mode-setup ()
    (org-indent-mode)
    (variable-pitch-mode 1)
    (visual-line-mode 1))

  (defun efs/org-font-setup ()
    ;; Replace list hyphen with dot
    (font-lock-add-keywords 'org-mode
                            '(("^ *\\([-]\\) "
                               (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

    ;; Set faces for heading levels
    (dolist (face '((org-level-1 . 1.2)
                    (org-level-2 . 1.1)
                    (org-level-3 . 1.05)
                    (org-level-4 . 1.0)
                    (org-level-5 . 1.1)
                    (org-level-6 . 1.1)
                    (org-level-7 . 1.1)
                    (org-level-8 . 1.1)))
      (set-face-attribute (car face) nil :font "Roboto" :weight 'bold :height (cdr face)))

    ;; Ensure that anything that should be fixed-pitch in Org files appears that way
    (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

  (use-package org
    :hook (org-mode . efs/org-mode-setup)
    :config
    (setq org-ellipsis " ▾")
    (efs/org-font-setup))

  (use-package org-bullets
    :after org
    :hook (org-mode . org-bullets-mode)
    :custom
    (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

  (defun efs/org-mode-visual-fill ()
    (setq visual-fill-column-width 100
          visual-fill-column-center-text t)
    (visual-fill-column-mode 1))

  (use-package visual-fill-column
    :hook (org-mode . efs/org-mode-visual-fill))

  (org-babel-do-load-languages
    'org-babel-load-languages
    '((emacs-lisp . t)
      (python . t)))

;; Automatically tangle our Emacs.org config file when we save it
(defun efs/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.config/emacs/Emacs.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))

  (use-package rust-ts-mode
    :hook ((rust-ts-mode . eglot-ensure)
           (rust-ts-mode . corfu-mode))
    :config
    (add-to-list 'exec-path "/home/dennis/.cargo/bin")
    (setenv "PATH" (concat (getenv "PATH") ":/home/dennis/.cargo/bin")))

    (use-package corfu
      ;; Optional customizations
       :custom
       (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
       (corfu-auto t)                 ;; Enable auto completion
      ;; (corfu-separator ?\s)          ;; Orderless field separator
      ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
       (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
      ;; (corfu-preview-current nil)    ;; Disable current candidate preview
      ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
      ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
      ;; (corfu-scroll-margin 5)        ;; Use scroll margin

      ;; Enable Corfu only for certain modes.
      ;; :hook ((prog-mode . corfu-mode)
      ;;        (shell-mode . corfu-mode)
      ;;        (eshell-mode . corfu-mode))

      ;; Recommended: Enable Corfu globally.  This is recommended since Dabbrev can
      ;; be used globally (M-/).  See also the customization variable
      ;; `global-corfu-modes' to exclude certain modes.
      :init
      (global-corfu-mode))

    ;; A few more useful configurations...
    (use-package emacs
      :init
      ;; TAB cycle if there are only few candidates
      (setq completion-cycle-threshold 3)

      ;; Emacs 28: Hide commands in M-x which do not apply to the current mode.
      ;; Corfu commands are hidden, since they are not supposed to be used via M-x.
      ;; (setq read-extended-command-predicate
      ;;       #'command-completion-default-include-p)

      ;; Enable indentation+completion using the TAB key.
      ;; `completion-at-point' is often bound to M-TAB.
      (setq tab-always-indent 'complete))
  ;; Use Dabbrev with Corfu!

  (use-package dabbrev
    ;; Swap M-/ and C-M-/
    :bind (("M-/" . dabbrev-completion)
           ("C-M-/" . dabbrev-expand))
    ;; Other useful Dabbrev configurations.
    :custom
    (dabbrev-ignored-buffer-regexps '("\\.\\(?:pdf\\|jpe?g\\|png\\)\\'")))


  (setq-local corfu-auto-delay  0 ;; TOO SMALL - NOT RECOMMENDED
              corfu-auto-prefix 1 ;; TOO SMALL - NOT RECOMMENDED
              completion-styles '(basic))

;; Add extensions
(use-package cape
  ;; Bind dedicated completion commands
  ;; Alternative prefix keys: C-c p, M-p, M-+, ...
  :bind (("C-c p p" . completion-at-point) ;; capf
         ("C-c p t" . complete-tag)        ;; etags
         ("C-c p d" . cape-dabbrev)        ;; or dabbrev-completion
         ("C-c p h" . cape-history)
         ("C-c p f" . cape-file)
         ("C-c p k" . cape-keyword)
         ("C-c p s" . cape-elisp-symbol)
         ("C-c p e" . cape-elisp-block)
         ("C-c p a" . cape-abbrev)
         ("C-c p l" . cape-line)
         ("C-c p w" . cape-dict)
         ("C-c p :" . cape-emoji)
         ("C-c p \\" . cape-tex)
         ("C-c p _" . cape-tex)
         ("C-c p ^" . cape-tex)
         ("C-c p &" . cape-sgml)
         ("C-c p r" . cape-rfc1345))
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  ;;(add-to-list 'completion-at-point-functions #'cape-history)
  ;;(add-to-list 'completion-at-point-functions #'cape-keyword)
  ;;(add-to-list 'completion-at-point-functions #'cape-tex)
  ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
  ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
  ;;(add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;;(add-to-list 'completion-at-point-functions #'cape-dict)
  ;;(add-to-list 'completion-at-point-functions #'cape-elisp-symbol)
  ;;(add-to-list 'completion-at-point-functions #'cape-line)
)

(use-package evil-nerd-commenter
  :bind ("M-;" . evilnc-comment-or-uncomment-lines))
  ; (use-package evil-nerd-commenter) 
  ;; (use-package evil-nerd-commenter
  ;;   :init
  ;;   (evilnc-default-hotkeys)
  ;;   (setq evilnc-comment-operator "gcc"))

(use-package tree-sitter-langs)

(use-package tree-sitter
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

  (setq treesit-language-source-alist
     '((bash "https://github.com/tree-sitter/tree-sitter-bash")
       (cmake "https://github.com/uyha/tree-sitter-cmake")
       (css "https://github.com/tree-sitter/tree-sitter-css")
       (elisp "https://github.com/Wilfred/tree-sitter-elisp")
       (go "https://github.com/tree-sitter/tree-sitter-go")
       (html "https://github.com/tree-sitter/tree-sitter-html")
       (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
       (json "https://github.com/tree-sitter/tree-sitter-json")
       (make "https://github.com/alemuller/tree-sitter-make")
       (markdown "https://github.com/ikatyang/tree-sitter-markdown")
       (python "https://github.com/tree-sitter/tree-sitter-python")
       (toml "https://github.com/tree-sitter/tree-sitter-toml")
       (rust "https://github.com/tree-sitter/tree-sitter-rust")
       (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
       (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
       (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(use-package vterm
  :commands vterm
  :config
  (setq vterm-shell "fish")                       ;; Set this to customize the shell to launch
  (setq vterm-max-scrollback 10000))

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  ;; :bind (("C-x C-j" . dired-jump))
  ;:bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package dired-single)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-open
  :config
  ;; Doesn't work as expected!
  ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
  (setq dired-open-extensions '(("png" . "feh")
                                ("mkv" . "mpv"))))

;(use-package dired-hide-dotfiles
;  :hook (dired-mode . dired-hide-dotfiles-mode)
;  :config
;  (evil-collection-define-key 'normal 'dired-mode-map
;    "H" 'dired-hide-dotfiles-mode))

(setq exec-path (append exec-path '("/run/user/1000/fnm_multishells/67954_1702151293507/bin/npm")))
(setq exec-path (append exec-path '("/run/user/1000/fnm_multishells/67954_1702151293507/bin")))
(setq exec-path (append exec-path '("/home/dennis/.cargo/bin/rust-analyzer")))

(use-package electric-pair-mode
  :hook (prog-mode . electric-pair-mode))
