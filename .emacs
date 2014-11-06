(setq user-home-dir "/Users/rberton/")
;;(setq boost-dir
(setq load-path (cons (concat user-home-dir "Lisp/yasnippet") load-path))
(setq load-path (cons (concat user-home-dir "Lisp/cedet") load-path))
(setq load-path (cons (concat user-home-dir "Lisp") load-path))
(setq load-path (cons (concat user-home-dir "Lisp/color-theme-6.6.0") load-path))
(setq load-path (cons (concat user-home-dir "shipping-lisp/emulation") load-path))
(require 'yasnippet)
(require 'bookmark-add)



(defun color-theme-clion ()
  "Mimic CLion defaults"
  (interactive)
  (let ((color-theme-is-cumulative t))
    (color-theme-midnight)
    (color-theme-install
     '(color-theme-clion
       ((foreground-color . "#B7C4C8")
	(background-color . "#393939")
	(background-mode . dark))
       (default ((t (nil))))
       (region ((t (:foreground "cyan" :background "dark cyan"))))
       (underline ((t (:foreground "yellow" :underline t))))
       (modeline ((t (:foreground "dark cyan" :background "wheat"))))
       (modeline-buffer-id ((t (:foreground "dark cyan" :background "wheat"))))
       (modeline-mousable ((t (:foreground "dark cyan" :background "wheat"))))
       (modeline-mousable-minor-mode ((t (:foreground "dark cyan" :background "wheat"))))
       (italic ((t (:foreground "dark red" :italic t))))
       (bold-italic ((t (:foreground "dark red" :bold t :italic t))))
       (font-lock-warning-face ((t (:foreground "Firebrick"))))
       (font-lock-keyword-face ((t (:foreground "#D78B40"))))
       (font-lock-constant-face ((t (:foreground "#9C9B30"))))
       (font-lock-comment-face ((t (:foreground "#929292"))))
       (font-lock-doc-face ((t (:foreground "#929292"))))
       (font-lock-string-face ((t (:foreground "#7C9769"))))
       (font-lock-builtin-face ((t (:foreground "#9C9B30"))))
       (font-lock-variable-name-face ((t (:foreground "#B7C4C8"))))
       (font-lock-function-name-face ((t (:foreground "#B7C4C8"))))
       (bold ((t (:bold))))))))

(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-clion)))

(setq yas/root-directory (concat user-home-dir "/.emacs.d/snippets"))
(yas/load-directory yas/root-directory)

(setq inhibit-startup-message t)
(setq shift-select-mode t)
(global-set-key "\C-x\C-b" 'bs-show)
(global-set-key (kbd "C-M-<left>")  'pop-global-mark)
(setq compilation-scroll-output 1)
(setq compilation-skip-threshold 2)
;;(fset 'c++-cout
;;   [?s ?t ?d ?: ?: ?c ?o ?u ?t ?  ?< ?< ?\S-  ?" ?" ?  ?< ?< ?  ?s ?t ?d ?: ?: ?e ?n ?d ?l ?\; left left left left left left left left left left left left left left left])
;;(global-set-key "\C-xc" 'c++-cout)
(global-set-key "\M-;" 'comment-or-uncomment-region)

(setq split-width-threshold 201)

(tool-bar-mode -1) ; turns off tool bar

;; Preserve the owner and group of the file you're editing (this is
;; especially important if you edit files as root):
(setq backup-by-copying-when-mismatch t)

(setq frame-title-format "%b - emacs")
(global-set-key "\C-xg" 'goto-line)
(global-set-key "\C-cs" 'eshell)
(setq eshell-scroll-show-maximum-output nil) ;; don't scroll the eshell window


;;;;;;;;;;;;;;; 
;; CEDET
(load-file "/Users/rberton/Lisp/cedet/lisp/cedet/cedet.el")
(setq load-path (cons (concat user-home-dir "Lisp/cedet/contrib") load-path))
(require 'eassist)
(global-ede-mode 1)
;;(semantic-load-enable-code-helpers)

;; semantic
;;(global-semantic-idle-completions-mode ni)
(global-semantic-decoration-mode t)
(global-semantic-highlight-func-mode t)
(global-semantic-show-unmatched-syntax-mode t)
(semantic-mode)

;; CC-mode
;;*(add-hook 'c-mode-hook '(lambda ()
;;*        (setq ac-sources (append '(ac-source-semantic) ac-sources))
;;*        (local-set-key (kbd "RET") 'newline-and-indent)
;;*        (linum-mode t)
;;*        (semantic-mode t)))

(defadvice async-shell-command (around hide-async-windows activate)
       (save-window-excursion
          ad-do-it))

(defun rsync-tree ()
  "rsync this project to the dev server"
  (interactive)
  (save-some-buffers 1)
  (setq rsync-command "rsync -e ssh -arvzl --exclude=**.git --progress ")
  (setq rsync-command
	(concat rsync-command rsync-local-folder))
  (setq rsync-command
	(concat rsync-command " dev:"))
  (setq rsync-command
	(concat rsync-command rsync-remote-folder))
  (async-shell-command rsync-command "*rsync*"))



;; Autocomplete
(setq comment-padding "*")
(add-to-list 'load-path "~/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

(defadvice bookmark-jump (after bookmark-jump activate)
  (let ((latest (bookmark-get-bookmark bookmark)))
    (setq bookmark-alist (delq latest bookmark-alist))
    (add-to-list 'bookmark-alist latest)))

;;*(defadvice semantic-ia-fast-jump (before semantic-ia-fast-jump activate)
;;*  (bookmark-set "marks"))

(defun smart-jump()
  (interactive)
  (or
   (semantic-ia-fast-jump (point))
   (semantic-complete-jump (point))))

(defun my-cedet-hook ()
  (local-set-key "\M-m" 'eassist-list-methods)
  (local-set-key "\M-o" 'eassist-switch-h-cpp)
  (local-set-key "\M-g" 'smart-jump)
  (local-set-key (kbd "<A-M-left>") '(bookmark-jump "marks"))
  (color-theme-clion)
  (semantic-complete-analyze-inline)
)

(define-key osx-key-mode-map (kbd "A-s") 'rsync-tree)

;;(add-hook 'semantic-init-hooks 'senator-minor-mode)
(setq compilation-read-command t )
(defun my-compile (prefix)
  "do the right thing"
  (interactive "P")
  (save-some-buffers 1)
  (compile compile-command)
)

;; Create a Project.ede equivalent for ede-simple-project
;; by telling Emacs to load Project.el files
(defun check-for-Project-el ()
  (if (file-exists-p "Project.el")
    (load-file "Project.el")
  )
)
(add-hook 'find-file-hook 'check-for-Project-el)

(defun choose-project (dirname)
  "pick the client folder in which to compile"
  (interactive "MDirectory name: ")
  (setq my-project-dirname dirname)
  
  (setq compile-command (concat (concat "ssh dev -t 'PATH=$PATH:/opt/python27/bin; cd " my-project-dirname) " && make -j'"))
  (ede-cpp-root-project "appnexus" :file (concat my-project-dirname "/Makefile.am")
     :include-path '( "." "common" "client" "packrat_client" "impbus" "bidder" "packrat" )
     :system-include-path '( "/usr/include" "/usr/local/include" "/usr/local/adnxs/include" )) 
)

(global-set-key  (kbd "C-M-p") 'choose-project)
  
(c-add-style "appnexus"
	     '(""
	       (c-basic-offset . 8)	; Guessed value
	       (c-offsets-alist
		(block-close . 0)	; Guessed value
		(class-close . 0)	; Guessed value
		(class-open . 0)	; Guessed value
		(defun-block-intro . +)	; Guessed value
		(defun-close . 0)	; Guessed value
		(defun-open . 0)	; Guessed value
		(inclass . +)		; Guessed value
		(statement . 0)		    ; Guessed value
		(statement-block-intro . +) ; Guessed value
		(topmost-intro . 0)	    ; Guessed value
		(topmost-intro-cont . 0) ; Guessed value
		(access-label . -)
		(annotation-top-cont . 0)
		(annotation-var-cont . +)
		(arglist-close . c-lineup-close-paren)
		(arglist-cont c-lineup-gcc-asm-reg 0)
		(arglist-cont-nonempty . c-lineup-arglist)
		(arglist-intro . +)
		(block-open . 0)
		(brace-entry-open . 0)
		(brace-list-close . 0)
		(brace-list-entry . 0)
		(brace-list-intro . +)
		(brace-list-open . 0)
		(c . c-lineup-C-comments)
		(case-label . 0)
		(catch-clause . 0)
		(comment-intro . c-lineup-comment)
		(composition-close . 0)
		(composition-open . 0)
		(cpp-define-intro c-lineup-cpp-define +)
		(cpp-macro . -1000)
		(cpp-macro-cont . +)
		(do-while-closure . 0)
		(else-clause . 0)
		(extern-lang-close . 0)
		(extern-lang-open . 0)
		(friend . 0)
		(func-decl-cont . +)
		(incomposition . +)
		(inexpr-class . +)
		(inexpr-statement . +)
		(inextern-lang . +)
		(inher-cont . c-lineup-multi-inher)
		(inher-intro . +)
		(inlambda . c-lineup-inexpr-block)
		(inline-close . 0)
		(inline-open . +)
		(inmodule . +)
		(innamespace . +)
		(knr-argdecl . 0)
		(knr-argdecl-intro . +)
		(label . 2)
		(lambda-intro-cont . +)
		(member-init-cont . c-lineup-multi-inher)
		(member-init-intro . +)
		(module-close . 0)
		(module-open . 0)
		(namespace-close . 0)
		(namespace-open . 0)
		(objc-method-args-cont . c-lineup-ObjC-method-args)
		(objc-method-call-cont c-lineup-ObjC-method-call-colons c-lineup-ObjC-method-call +)
		(objc-method-intro .
				   [0])
		(statement-case-intro . +)
		(statement-case-open . 0)
		(statement-cont . +)
		(stream-op . c-lineup-streamop)
		(string . -1000)
		(substatement . +)
		(substatement-label . 2)
		(substatement-open . +)
		(template-args-cont c-lineup-template-args +))))



(defun my-c-mode ()
  "C mode with adjusted defaults."
  (c-set-style "appnexus")
)


;; add all the c hooks
(add-hook 'c-mode-common-hook 'my-c-mode)
(add-hook 'c-mode-common-hook 'my-cedet-hook)

(setq compilation-scroll-output "first-error")		
(setq compilation-skip-threshold 2)
(setq compilation-read-command nil)
(setq compilation-auto-jump-to-first-error 1)
(require 'mwheel)
(mouse-wheel-mode t) 

(setq-default c-basic-offset 4
                  tab-width 4
                  indent-tabs-mode t)


;;;;;;;;;;;;;;;;;
;; anything

(add-to-list 'load-path "~/Lisp/emacs-async")
(add-to-list 'load-path "~/Lisp/helm")
(require 'helm-config)

(global-set-key "\C-O" 'helm-for-files)

(defvar helm-frame nil)

;;*(defun helm-initialize-frame ()
;;*  (unless (and helm-frame (frame-live-p anything-frame))
;;*    (setq anything-frame (make-frame '((name . "*Anything*") 
;;*				       (width . 80) 
;;*				       (height . 40)))))
;;*  (select-frame anything-frame)

;;*  (set-window-buffer (frame-selected-window anything-frame) 
;;*		     (get-buffer-create anything-buffer)))

;;*(defun anything-hide-frame ()
;;*  (when (and anything-frame (frame-live-p anything-frame))
;;*    (iconify-frame anything-frame)))

;;*(add-hook 'anything-after-initialize-hook 
;;*	  'anything-initialize-frame)

;;*(add-hook 'anything-cleanup-hook 
;;*	  'anything-hide-frame)


(load-library "cua-base")
(cua-mode t)
(show-paren-mode t)
(setq transient-mark-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Smart Tab

(setq-default indent-tabs-mode t)
(setq-default tab-width 8) 
(defvaralias 'c-basic-offset 'tab-width)

(require 'cl)
(defvar smart-tab-using-hippie-expand t
  "turn this on if you want to use hippie-expand completion.")

(defun smart-indent ()
  "Indents region if mark is active, or current line otherwise."
  (interactive)
  (if mark-active
    (indent-region (region-beginning)
                   (region-end))
    (indent-for-tab-command)))

(defun smart-tab (arg)
 "Do the right thing about tabs"
 (interactive "*P")
 (cond
  ((minibufferp)     
   (minibuffer-complete))
  ; try yas first
  ((yas/expand) t)
  ; if we are at the left most column
  ((equal (current-column)  0)
    (smart-indent))
  ; if there is a white space behind us, indent
  ((save-excursion
    (forward-char -1)
    (looking-at " "))
    (smart-indent))
  ; if we have an active mark (region), indent
  (mark-active
    (smart-indent))
  ((auto-complete) t)
  ; if no completion, use dabbrev
  ;; ((save-excursion
  ;;    (forward-char -1)
  ;;    (looking-at "[a-zA-Z0-9]"))
  ;; (dabbrev-expand nil))
  (t
   (smart-indent))))

(require 'completion) ;; for minibuffer-window-selected-p

(global-set-key [tab] 'smart-tab)
(global-set-key (kbd "TAB") 'smart-tab)
(setq yas/trigger-key nil)
(setq yas/fallback-behavior nil)

(defun smart-beginning-of-line ()
  "Move point to first non-whitespace character or beginning-of-line.
Move point to the first non-whitespace character on this line.
If point was already at that position, move point to beginning of line.. also maintain mark if shift is down"
  (interactive)
  (let ((oldpos (point)))
    (back-to-indentation)
    (and (= oldpos (point))
	 (beginning-of-line))))

(defun smart-beginning-of-line-mark ()
  "Move point to first non-whitespace character or beginning-of-line.
Move point to the first non-whitespace character on this line.
If point was already at that position, move point to beginning of line.. also maintain mark if shift is down"
  (interactive)
  (push-mark)
  (activate-mark)
  (smart-beginning-of-line))

(defun snippet-expand (snipname)
  "ask for the name of the snippet and call yasnippet with it"
  (interactive "MSnippet name: ")
  (yas/insert-snippet snipname))
  

(define-key global-map (kbd "M-y") 'snippet-expand)
(define-key global-map (kbd "S-<home>") 'smart-beginning-of-line-mark)
(global-set-key [home] 'smart-beginning-of-line)

(autoload 'senator-try-expand-semantic "senator")

(setq hippie-expand-try-functions-list
      '(
        senator-try-expand-semantic
        try-expand-dabbrev
        try-expand-dabbrev-visible
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-expand-list
        try-expand-list-all-buffers
        try-expand-line
        try-expand-line-all-buffers
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-whole-kill
        )
)
(line-number-mode 1)
(column-number-mode 1)
(setq scroll-step 1)

(setq delete-key-deletes-forward t)
(setq-default case-fold-search nil)
(setq progress-feedback-use-echo-area 1)

(defun yes-or-no-p (prompt) "just y/n, thanks" (y-or-n-p prompt) )

(global-set-key [f8] 'my-compile)
;;(global-set-key [f5] 'run-cc-debug)
(global-set-key [f7] 'next-error)
(global-set-key [f11] 'previous-error)
(global-set-key (kbd "M-m") 'eassist-list-methods)

;; time/mail notification
(display-time)


;; Always end a file with a newline
(setq require-final-newline t)

;; do proper interface setup
(unless (fboundp 'console-on-window-system-p)
  (defun console-on-window-system-p ()
    (if window-system t nil)))

(defun my-window-system-setup ()

  ;; wheel mouse

  (set-scroll-bar-mode 'right) 

  (font-lock-add-keywords 'c++-mode '(
				      ;; Currently support for []|&!.+=-/%*,()<>{}
				      ("\\(\\[\\|\\]\\|[|!\\.\\+\\=\\&]\\|-\\|\\/\\|\\%\\|\\*\\|,\\|(\\|)\\|>\\ |<\\|{\\|}\\)" 1 font-lock-operator-face )  ; End of c++ statement 
				      ("\\(;\\)" 1 font-lock-end-statement ) )) 

  (make-face 'font-lock-operator-face)
  (make-face 'font-lock-end-statement)
  (setq font-lock-operator-face 'font-lock-operator-face)
  (setq font-lock-end-statement 'font-lock-end-statement)


  ;; new frame things
  (defconst new-frame-alist
    (let ((frame (selected-frame)))
      `(
	(font . ,"smoothansi"))))
  (defun initialize-new-frame (new-frame) 
    (modify-frame-parameters new-frame new-frame-alist))
  (add-hook 'after-make-frame-functions 'initialize-new-frame)
  )

(defun my-console-setup ()

  (defun track-mouse(whatever)) 
  (require 'mouse)
  (xterm-mouse-mode 1)
  (require 'mwheel)
  (mouse-wheel-mode) 

   (setq emacs-lisp-mode-hook
          (function
            (lambda nil
	      (local-set-key (kbd "TAB") 'my-tab)
             )
	   )
    )

   (setq fundamental-mode-hook
          (function
            (lambda nil
	      (local-set-key (kbd "TAB") 'my-tab)
             )
	   )
    )

   (setq c-mode-hook
          (function
            (lambda nil
	      (local-set-key (kbd "TAB") 'my-tab)
             )
	   )
    )

  (custom-set-faces
   '(font-lock-builtin-face ((((type tty) (class color)) (:foreground "cyan"))))
   '(font-lock-function-name-face ((((type tty) (class color)) (:foreground "cyan"))))
   '(font-lock-builtin-face ((((type tty) (class color)) (:foreground "cyan"))))
   '(mode-line ((t (:background "black" :foreground "white"))))
   )
)

(if (console-on-window-system-p)
    (my-window-system-setup)  ;; else
  (my-console-setup)
)

(put 'upcase-region 'disabled nil)
(define-key osx-key-mode-map [home] 'smart-beginning-of-line)
(define-key osx-key-mode-map [end] 'end-of-line)
