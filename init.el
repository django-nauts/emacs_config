;; melpa
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(package-initialize)

;; Alias for fast M-x
(defalias 'yes-or-no-p 'y-or-n-p)
(defalias 'mariadb 'sql-mariadb)
(defalias 'postgres 'sql-postgres)
(defalias 'colors 'list-colors-display)
(defalias 'mongodb 'inf-mongo)
(defalias 'install 'list-packages)
(defalias 'themes 'customize-themes)

;; disable menu bar
(menu-bar-mode -1)

;; disable tool bar
(tool-bar-mode -1)

;; disable scroll bar
(scroll-bar-mode -1)

;; disable auto-save-list
(setq auto-save-list-file-prefix nil)

;; disable ~ files
(setq make-backup-files nil)

;; disable .# files
(setq create-lockfiles nil)

;; stop creating those #auto-save# files
(setq auto-save-default nil)

;; disable arrow keys
(global-unset-key (kbd "<left>"))
(global-unset-key (kbd "<right>"))
(global-unset-key (kbd "<up>"))
(global-unset-key (kbd "<down>"))
(global-unset-key (kbd "<C-left>"))
(global-unset-key (kbd "<C-right>"))
(global-unset-key (kbd "<C-up>"))
(global-unset-key (kbd "<C-down>"))
(global-unset-key (kbd "<M-left>"))
(global-unset-key (kbd "<M-right>"))
(global-unset-key (kbd "<M-up>"))
(global-unset-key (kbd "<M-down>"))

;; change font face and font size
(set-frame-font "Hack 13" nil t)

;; line spacing
(setq-default line-spacing 0.2)

;; stop cursor blink
(blink-cursor-mode 0)

;; change cursor type
(setq-default cursor-type 'bar)

;; show line numbers
(global-display-line-numbers-mode)

;; padding line numbers
(setq linum-format " %4d ")

;; UTF-8 as default file encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; open init.el quickly
(global-set-key (kbd "<f12>") (lambda () (interactive) (find-file "~/.emacs.d/init.el")))

;; resize windows
(global-set-key (kbd "<s-up>") 'shrink-window)
(global-set-key (kbd "<s-down>") 'enlarge-window)
(global-set-key (kbd "<s-left>") 'shrink-window-horizontally)
(global-set-key (kbd "<s-right>") 'enlarge-window-horizontally)

;; auto-close brackets
(electric-pair-mode 1)
;; make electric-pair-mode work on more brackets
(setq electric-pair-pairs
      '(
        (?\" . ?\")
        (?\{ . ?\})))

;; disable mouse
(dolist (k '([mouse-1] [down-mouse-1] [drag-mouse-1] [double-mouse-1] [triple-mouse-1]
             [mouse-2] [down-mouse-2] [drag-mouse-2] [double-mouse-2] [triple-mouse-2]
             [mouse-3] [down-mouse-3] [drag-mouse-3] [double-mouse-3] [triple-mouse-3]
             [mouse-4] [down-mouse-4] [drag-mouse-4] [double-mouse-4] [triple-mouse-4]
             [mouse-5] [down-mouse-5] [drag-mouse-5] [double-mouse-5] [triple-mouse-5]))
  (global-unset-key k))

;; duplicate lines
(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank)
)
(global-set-key (kbd "C-d") 'duplicate-line)

;; display column numbers
(setq column-number-mode t)

;; highlight current line
(global-hl-line-mode 1)
(set-face-background 'highlight "#eee")
(set-face-foreground 'highlight nil)

;; turn on highlight matching brackets
(show-paren-mode 1)
;; highlight brackets
(setq show-paren-style 'parenthesis)
;; highlight entire expression
(setq show-paren-style 'expression)
;; highlight brackets if visible, else entire expression
(setq show-paren-style 'mixed)
;; change brackets highlight color
(require 'paren)
;;(set-face-background 'show-paren-match (face-background 'default))
(set-face-foreground 'show-paren-match "purple")
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)

;; fill-column-indicator
(add-to-list 'load-path "~/.emacs.d/lisp/fill-column-indicator/")
(require 'fill-column-indicator)
(setq fci-rule-column 79)
(setq fci-rule-width 2)
(setq fci-rule-color "red")
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)
(define-globalized-minor-mode global-fci-mode fci-mode
  (lambda ()
    (if (and
         (not (string-match "^\*.*\*$" (buffer-name)))
         (not (eq major-mode 'dired-mode)))
        (fci-mode 1))))
(global-fci-mode 1)

;; Advance Tab
;; Create a variable for our preferred tab width
(setq custom-tab-width 4)

;; Two callable functions for enabling/disabling tabs in Emacs
(defun disable-tabs () (setq indent-tabs-mode nil))
(defun enable-tabs  ()
  (local-set-key (kbd "TAB") 'tab-to-tab-stop)
  (setq indent-tabs-mode t)
  (setq tab-width custom-tab-width))

;; Hooks to Enable Tabs
(add-hook 'prog-mode-hook 'enable-tabs)
;; Hooks to Disable Tabs
(add-hook 'lisp-mode-hook 'disable-tabs)
(add-hook 'emacs-lisp-mode-hook 'disable-tabs)

;; Making electric-indent behave sanely
(setq-default electric-indent-inhibit t)

;; Make the backspace properly erase the tab instead of
;; removing 1 space at a time.
(setq backward-delete-char-untabify-method 'hungry)

;; disable whitespace-mode color
(setq whitespace-style (quote (face tabs newline space-mark tab-mark newline-mark)))

;; move lines up and down
(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (setq col (current-column))
  (beginning-of-line) (setq start (point))
  (end-of-line) (forward-char) (setq end (point))
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char col)))

(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

;; change selected text
(set-face-attribute 'region nil :background "#ccc")

;; display time
(display-time)

;; auto-refresh all buffers
(global-auto-revert-mode t)

;; disable bold text
(set-face-bold-p 'bold nil)

;; disable underline text
 (mapc
  (lambda (face)
    (set-face-attribute face nil :weight 'normal :underline nil))
  (face-list))

;; splash screen
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

;; change splash screen text
      (insert " " )

;; toggle comment/uncommentn
(defun toggle-comment-dwim ()
  "Like `comment-dwim', but toggle comment if cursor is not at end of line."

  (interactive)
  (if (region-active-p)
      (comment-dwim nil)
    (let (($lbp (line-beginning-position))
          ($lep (line-end-position)))
      (if (eq $lbp $lep)
          (progn
            (comment-dwim nil))
        (if (eq (point) $lep)
            (progn
              (comment-dwim nil))
          (progn
            (comment-or-uncomment-region $lbp $lep)
            (forward-line )))))))
(global-set-key (kbd "C-c c") 'toggle-comment-dwim)

;; CC mode for C, C++
    (setq c-default-style "linux"
          c-basic-offset 4)

;; Python
;; python3 as default
(setq python-shell-interpreter "python3.9")
;; run python code: (C-c)
(global-set-key (kbd "<f8>") 'run-python)
;; disable showing warning message in python-mode
(setq python-indent-guess-indent-offset nil)  
(setq python-indent-guess-indent-offset-verbose nil)
;; python tab size
(setq python-indent-offset 4)

;; Ruby
;; ruby tab size
(setq ruby-indent-level 2)

;; Go
(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save)
            (setq tab-width 2)
            (setq indent-tabs-mode 1)))

;; php-mode
(add-hook 'php-mode-hook 'my-php-mode-hook)
(defun my-php-mode-hook ()
  (setq indent-tabs-mode t)
  (let ((my-tab-width 4))
    (setq tab-width my-tab-width)
    (setq c-basic-indent my-tab-width)
    (set (make-local-variable 'tab-stop-list)
         (number-sequence my-tab-width 200 my-tab-width))))

;; CSS
;; css tab size
(setq css-indent-offset 2)

;; JavaScript
;; javascript tab size
(setq js-indent-level 2)

;; emmet-mode (press C-j)
(add-to-list 'load-path "~/.emacs.d/lisp/emmet-mode/")
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
(setq emmet-move-cursor-between-quotes t) ;; default nil
(setq emmet-self-closing-tag-style "") ;; default "/"

;; SQL
;; Automatically upcase SQL keywords
  (defun upcase-sql-keywords ()
    (interactive)
    (save-excursion
      (dolist (keywords sql-mode-postgres-font-lock-keywords)
        (goto-char (point-min))
        (while (re-search-forward (car keywords) nil t)
          (goto-char (+ 1 (match-beginning 0)))
          (when (eql font-lock-keyword-face (face-at-point))
            (backward-char)
            (upcase-word 1)
            (forward-char))))))
(global-set-key (kbd "C-.") 'upcase-sql-keywords)

;; MySQL
;; run mysql code: open a .sql file then press M-x sql-mysql then press (C-c C-b) to run sql
;; Enter mysql command line: open your shell then: mysql -u USERNAME -p
;; postgresql (sql-postgres - login with postgres user)
;;  sqlite = M-x sql-sqlite  then open .sqlite file and done!
(defun point-in-comment ()
  (let ((syn (syntax-ppss)))
    (and (nth 8 syn)
         (not (nth 3 syn)))))
(defun my-capitalize-all-mysql-keywords ()
  (interactive)
  (require 'sql)
  (save-excursion
    (dolist (keywords sql-mode-mysql-font-lock-keywords) 
      (goto-char (point-min))
      (while (re-search-forward (car keywords) nil t)
        (unless (point-in-comment)
          (goto-char (match-beginning 0))
          (upcase-word 1))))))
(global-set-key (kbd "C-,") 'my-capitalize-all-mysql-keywords)

;; postgres
(setq sql-postgres-login-params
      '((user :default "postgres")
        (database)
        (server :default "localhost")))

;;  no line truncate
(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (toggle-truncate-lines t)))

;; mongodb (run mongodb or inf-mongo then you're ready to go!)
(add-to-list 'load-path "~/.emacs.d/lisp/inf-mongo/")
(require 'inf-mongo)

;; org-mode
(setq org-startup-folded nil)
;; org mode persian font-size problem
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hl-line ((t (:height 1.0))))
 '(minimap-active-region-background ((t (:extend t :background "dim gray"))))
 '(minimap-font-face ((t (:height 30 :family "Hack"))))
 '(org-level-1 ((t (:inherit header-line :height 1.0))))
 '(org-level-2 ((t (:inherit header-line :height 1.0))))
 '(org-level-3 ((t (:inherit header-line :height 1.0)))))

;; multiple cursors
(add-to-list 'load-path "~/.emacs.d/lisp/multiple-cursors/")
(require 'multiple-cursors)
(global-set-key (kbd "C-c e") 'mc/edit-lines)

;; tab-bar
(global-set-key (kbd "C-x w") 'tab-close)
(global-set-key (kbd "C-x t") 'tab-new)
(global-set-key (kbd "C-<right>") 'tab-next)
(global-set-key (kbd "C-<left>") 'tab-previous)

;; easy upper/lower case characters
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; default theme
  (require 'doom-themes)
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; Load the theme (doom-one, doom-molokai, etc); keep in mind that each
  ;; theme may have their own settings.
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme
  (doom-themes-neotree-config)  ; all-the-icons fonts must be installed!
  ;; Corrects (and improves) org-mode's native fontification.
  ;; (doom-themes-org-config)

;; Delete all lines
(defun kill-to-end-of-buffer()
  (interactive)
  (progn
    (forward-line -999999)
    (delete-region (point) (point-max))))
(global-set-key "\C-\M-k" 'kill-to-end-of-buffer)

;; change all/some query to your text
(global-set-key (kbd "C-q") 'query-replace)

;; everytime bookmark is changed, automatically save it
(setq bookmark-save-flag 1)

;; windmove
(global-set-key (kbd "<left>")  'windmove-left)
(global-set-key (kbd "<right>") 'windmove-right)
(global-set-key (kbd "<up>")    'windmove-up)
(global-set-key (kbd "<down>")  'windmove-down)
(defun ignore-error-wrapper (fn)
  "Funtion return new function that ignore errors.
   The function wraps a function with `ignore-errors' macro."
  (lexical-let ((fn fn))
    (lambda ()
      (interactive)
      (ignore-errors
        (funcall fn)))))

;; undo-tree
(add-to-list 'load-path "~/.emacs.d/lisp/undo-tree/")
(require 'undo-tree)
(defun undo-tree-visualizer-update-linum (&rest args)
    (linum-update undo-tree-visualizer-parent-buffer))
(advice-add 'undo-tree-visualize-undo :after #'undo-tree-visualizer-update-linum)
(advice-add 'undo-tree-visualize-redo :after #'undo-tree-visualizer-update-linum)
(advice-add 'undo-tree-visualize-undo-to-x :after #'undo-tree-visualizer-update-linum)
(advice-add 'undo-tree-visualize-redo-to-x :after #'undo-tree-visualizer-update-linum)
(advice-add 'undo-tree-visualizer-mouse-set :after #'undo-tree-visualizer-update-linum)
(advice-add 'undo-tree-visualizer-set :after #'undo-tree-visualizer-update-linum)
(global-set-key (kbd "C-c u") 'undo-tree-visualize)

;; avy (quick jump to your word)
(add-to-list 'load-path "~/.emacs.d/lisp/avy/")
(require 'avy)
(global-set-key (kbd "C-;") 'avy-goto-char)
(global-set-key (kbd "C-'") 'avy-goto-char-2)
(avy-setup-default)
;; (global-set-key (kbd "M-g f") 'avy-goto-line)
;; (global-set-key (kbd "M-g w") 'avy-goto-word-1)
;; (global-set-key (kbd "M-g e") 'avy-goto-word-0)
;; (global-set-key (kbd "C-c C-j") 'avy-resume)

;; clear shell
(global-set-key (kbd "C-c l") 'comint-clear-buffer)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#1B2229" "#ff6c6b" "#98be65" "#ECBE7B" "#51afef" "#c678dd" "#46D9FF" "#DFDFDF"])
 '(custom-safe-themes
   '("d1b4990bd599f5e2186c3f75769a2c5334063e9e541e37514942c27975700370" "356e5cbe0874b444263f3e1f9fffd4ae4c82c1b07fe085ba26e2a6d332db34dd" "6b2636879127bf6124ce541b1b2824800afc49c6ccd65439d6eb987dbf200c36" "1c082c9b84449e54af757bcae23617d11f563fc9f33a832a8a2813c4d7dfb652" "b54826e5d9978d59f9e0a169bbd4739dd927eead3ef65f56786621b53c031a7c" "fe666e5ac37c2dfcf80074e88b9252c71a22b6f5d2f566df9a7aa4f9bea55ef8" "3a3de615f80a0e8706208f0a71bbcc7cc3816988f971b6d237223b6731f91605" "f0dc4ddca147f3c7b1c7397141b888562a48d9888f1595d69572db73be99a024" "d2e9c7e31e574bf38f4b0fb927aaff20c1e5f92f72001102758005e53d77b8c9" "a3fa4abaf08cc169b61dea8f6df1bbe4123ec1d2afeb01c17e11fdc31fc66379" default))
 '(fci-rule-color "#5B6268")
 '(jdee-db-active-breakpoint-face-colors (cons "#1B2229" "#51afef"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#1B2229" "#98be65"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#1B2229" "#3f444a"))
 '(minimap-minimum-width 10)
 '(minimap-mode t)
 '(package-selected-packages
   '(all-the-icons-dired all-the-icons-ibuffer all-the-icons minimap doom-themes helm web-mode php-mode go-mode rust-mode enh-ruby-mode inf-ruby))
 '(vc-annotate-background "#282c34")
 '(vc-annotate-color-map
   (list
    (cons 20 "#98be65")
    (cons 40 "#b4be6c")
    (cons 60 "#d0be73")
    (cons 80 "#ECBE7B")
    (cons 100 "#e6ab6a")
    (cons 120 "#e09859")
    (cons 140 "#da8548")
    (cons 160 "#d38079")
    (cons 180 "#cc7cab")
    (cons 200 "#c678dd")
    (cons 220 "#d974b7")
    (cons 240 "#ec7091")
    (cons 260 "#ff6c6b")
    (cons 280 "#cf6162")
    (cons 300 "#9f585a")
    (cons 320 "#6f4e52")
    (cons 340 "#5B6268")
    (cons 360 "#5B6268")))
 '(vc-annotate-very-old-color nil))

;; helm
(require 'helm-config)
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-c f") 'helm-find-files)
(define-key helm-map (kbd "TAB") #'helm-execute-persistent-action)
(define-key helm-map (kbd "<tab>") #'helm-execute-persistent-action)
(define-key helm-map (kbd "C-z") #'helm-select-action)
(set-face-attribute 'helm-selection nil 
                    :background "gray"
                    :foreground "black")

;; force emacs to exit
(global-set-key (kbd "C-x x") 'kill-emacs)

;; theme switcher
(global-set-key (kbd "C-<f1>") 'disable-theme)
(global-set-key (kbd "C-<f2>")
                (lambda () (interactive)
                  (load-theme 'doom-one t)))
(global-set-key (kbd "C-<f3>")
                (lambda () (interactive)
                  (load-theme 'doom-molokai t)))
(global-set-key (kbd "C-<f4>")
                (lambda () (interactive)
                  (load-theme 'doom-tomorrow-night t)))

;; Abbrev Mode
(load "~/.emacs.d/lisp/my-abbrev.el")
;; use @@ in my-abbrev means where cursor shows
 (defadvice expand-abbrev (after my-expand-abbrev activate)
   ;; if there was an expansion
   (if ad-return-value
       ;; start idle timer to ensure insertion of abbrev activator
       ;; character (e.g. space) is finished
       (run-with-idle-timer 0 nil
                            (lambda ()
                              ;; if there is the string "@@" in the
                              ;; expansion then move cursor there and
                              ;; delete the string
                              (let ((cursor "@@"))
                                (if (search-backward cursor last-abbrev-location t)
                                    (delete-char (length cursor))))))))
(global-set-key (kbd "C-h") 'expand-abbrev) ;; use C-h to avoid adding space (use space to add space!)

;; save cursor location
(save-place-mode 1)

;; minimap
(minimap-mode 1)
(setq minimap-window-location 'right)
;; keep the width of our frames at 80 columns
(defun minimap-toggle ()
  "Toggle minimap for current buffer."
  (interactive)
  (if (not (boundp 'minimap-bufname))
      (setf minimap-bufname nil))
  (if (null minimap-bufname)
      (progn (minimap-create)
	     (set-frame-width (selected-frame) 100))
    (progn (minimap-kill)
	   (set-frame-width (selected-frame) 80))))

;; highlight-indent-guides
(add-to-list 'load-path "~/.emacs.d/lisp/highlight-indent-guides/")
(require 'highlight-indent-guides)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
;; change face (you can set     fill   column    character    bitmap)
(setq highlight-indent-guides-method 'character)
(setq highlight-indent-guides-auto-enabled nil)
(set-face-background 'highlight-indent-guides-odd-face "darkgray")
(set-face-background 'highlight-indent-guides-even-face "dimgray")
(set-face-foreground 'highlight-indent-guides-character-face "dimgray")

;; find-file-in-project
(setq ffip-project-root "~/projects/")

;; disable italic, bold and underline texts (for example in  h  tags in HTML and etc)
(set-face-bold-p 'bold nil)
(set-face-italic-p 'italic nil)
;; (set-face-underline-p 'underline nil)

;; delete a line starting with specific text
(global-set-key (kbd "C-c q") 'flush-lines)

;; Make a new directory
(global-set-key (kbd "C-c d") 'make-directory)

;; tab-bar movement
(global-set-key (kbd "C-s-<right>") 'tab-move)
(global-set-key (kbd "C-s-<left>") 'tab-move-to)

;; change root files
;; open your file with regular access (C-x C-f) then (C-c r)
(defun my-edit-file-as-root ()
  "Find file as root"
  (interactive)
  (let*
    ((sudo (/= (call-process "sudo" nil nil "-n true") 0))
      (file-name
        (if (tramp-tramp-file-p buffer-file-name)
          (with-parsed-tramp-file-name buffer-file-name parsed
            (tramp-make-tramp-file-name
              (if sudo "sudo" "su")
              "root"
              parsed-host
              parsed-localname
              (let ((tramp-postfix-host-format "|")
                     (tramp-prefix-format))
                (tramp-make-tramp-file-name
                  parsed-method
                  parsed-user
                  parsed-host
                  ""
                  parsed-hop))))
          (concat (if sudo
                    "/sudo::"
                    "/su::")
            buffer-file-name))))
    (find-alternate-file file-name)))
(global-set-key (kbd "C-c r") 'my-edit-file-as-root)


;; lorem ipsum generator
(add-to-list 'load-path "~/.emacs.d/lisp/lorem-ipsum/")
(require 'lorem-ipsum)
;; (lorem-ipsum-use-default-bindings)
(global-set-key (kbd "C-c p") 'lorem-ipsum-insert-paragraphs)

;; never use tabs
(setq-default indent-tabs-mode nil)

;; web-mode
(add-to-list 'auto-mode-alist '("\\.php?\\'" . web-mode))

;; inf-ruby
(add-to-list 'load-path "~/.emacs.d/lisp/inf-ruby/")
(require 'inf-ruby)
(autoload 'inf-ruby-minor-mode "inf-ruby" "Run an inferior Ruby process" t)
(add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)
(add-hook 'compilation-filter-hook 'inf-ruby-auto-enter)
;; first press f9 then select whole text with C-x C-h the C-c C-r to run ruby code
;; (global-set-key (kbd "<f9>") 'inf-ruby)

;; persian keyboard support
;; (global-set-key (kbd "") ')
(global-set-key (kbd "C-ح") 'previous-line)
(global-set-key (kbd "C-د") 'next-line)
(global-set-key (kbd "C-ذ") 'backward-char)
(global-set-key (kbd "C-ب") 'forward-char)
(global-set-key (kbd "C-ط C-س") 'save-buffer)
(global-set-key (kbd "C-ق") 'isearch-backward)
(global-set-key (kbd "C-س") 'isearch-forward)
(global-set-key (kbd "C-ز C-ف") 'org-todo)
(global-set-key (kbd "C-غ") 'yank)
(global-set-key (kbd "C-ط ع") 'undo)
(global-set-key (kbd "C-خ") 'open-line)
