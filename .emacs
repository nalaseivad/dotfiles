;; -*- mode: emacs-lisp -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Notes
;;
;; Comments conventions
;; * http://www.gnu.org/software/emacs/manual/html_node/elisp/Comment-Tips.html
;; * This will be respected by the alignment rules of the mode
;;   * Double semi-colon is used for a left aligned comment
;;   * Single semi-colon is used for a comment that will be aligned with code
;;
;; Setting variables
;; * Use setq or setq-default.  What's the difference?  Some variables in Emacs
;;   are buffer-local, meaning that each buffer is allowed to have a separate
;;   value which overrides the global default.  If a variable is buffer-local
;;   then setq set its local value in the current buffer and setq-default sets
;;   the global default value.  If a variable is not buffer-local then setq and
;;   setq-default do the same thing, they set the global (and only) value for
;;   that variable.
;;; * Example:  (setq-default variable-name <value>)
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; >> Platform specific

;;
;; If running on a FactSet node ... then load common config
;;
(if (file-exists-p "/home/fonix/prd_progs/tools/conf/emacs/fds-common.el")
    ((add-to-list 'load-path "/home/fonix/prd_progs/tools/conf/emacs/")
     (load "fds-common")))

;; << Platform specific
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; >> Configuration

;; Turn off the annoying bell
(setq-default ring-bell-function 'ignore)

;; Turn off the menu bar and tool bar.
;; For each: +ve integer arg => turn on, -ve integer arg => turn off.
(menu-bar-mode -1)
(tool-bar-mode -1)

;; No more startup screen
(setq-default inhibit-startup-message t)

;; Turn on column numbers
(column-number-mode t)

;; This only seems to work in X mode Emacs lauched from PuTTY.  If I lauch a
;; character mode Emacs then the cursor color does not change.
(set-cursor-color "red")

;; Turn on search highlighting
(setq-default search-highlight t)

;; Text mode by default please
'(default-major-mode "text-mode")

;; Set the row width for wrapping.
;; The command to wrap lines in a block is M-q.
(setq-default fill-column 80)

;; Tabs are spaces, period
(setq-default indent-tabs-mode nil)

;; Turn on syntax colouring by default
(global-font-lock-mode t)

;; Turn on selection highlighting
(setq-default transient-mark-mode t)

;; Always put a final \n on the last row in a file
(setq-default require-final-newline t)

;; Diable adding extra blank rows when I move past the current end of the buffer
(setq-default next-line-add-newlines nil)

;; Scroll bar on the right please
(set-scroll-bar-mode 'right)

;; Get rid of that illegible dark blue in the mini-buffer when running with a
;; black background, which I like to do.  This may only be a problem in character
;; mode emacs (I don't remember) but I'll just set it anyway.
(set-face-foreground 'minibuffer-prompt "cyan")

;; Make scrolling off the visible edges of a buffer less jarring
(set-variable 'scroll-conservatively 5)

;; Display time in the status bar and use 24 hour format
(display-time)
(setq-default display-time-24hr-format t)

;; Put all backup files in (~/.emacs.d/backups)
(defvar --backup-directory (concat user-emacs-directory "backups"))
(if (not (file-exists-p --backup-directory))
    (make-directory --backup-directory t))
(setq-default backup-directory-alist `(("." . ,--backup-directory)))

;; Backup and auto-save options
(setq-default
 make-backup-files t               ; Backup a file the first time it is saved
 backup-by-copying t               ; Don't clobber symlinks
 version-control t                 ; Use version numbers for backup files
 delete-old-versions t             ; Delete excess backup files silently
 delete-by-moving-to-trash t
 kept-old-versions 6               ; The oldest version to keep when a new
                                   ;   numbered backup is made (default: 2)
 kept-new-versions 9               ; The newest version to keep when a new
                                   ;   numbered backup is made (default: 2)
 auto-save-default t               ; Auto-save every buffer that visits a file
 auto-save-timeout 20              ; # seconds idle time before auto-save
 auto-save-interval 200)           ; # keystrokes between auto-saves


;; Use CPerl-mode for Perl files
(add-to-list 'auto-mode-alist '("\\.\\([pP][Llm]\\|al\\)\\'" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl" . cperl-mode))

;; << Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; >> Key bindings

;;
;; Notes:
;; * PuTTY doesn't send control characters for CTRL-<home> or CTRL-<end> so
;;   there's no way to make those key combinations work in character mode Emacs
;;   launched from a PuTTY terminal.  Character mode Emacs will work if launched
;;   from an xterm though and X mode Emacs launched from PuTTY will work too.
;; * Also, PuTTY mis-maps the <end> key to <select>
;;

;; Make both CTRL-f and CTRL-s use regex search
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-f") 'isearch-forward-regexp)

;; Make CTRL-<home>/<end> work like in Windows.
;; X mode Emacs or character mode Emacs launched from xterm only.
(global-set-key (kbd "C-<home>") 'beginning-of-buffer)
(global-set-key (kbd "C-<end>") 'end-of-buffer)     ;; Works in X, not in PuTTY
(global-set-key (kbd "C-<select>") 'end-of-buffer)  ;; For PuTTY

;; Make <home>/<end> work like in Windows
(global-set-key (kbd "<home>") 'beginning-of-line)
(global-set-key (kbd "<end>") 'end-of-line)         ;; Works in X, not in PuTTY
(global-set-key (kbd "<select>") 'end-of-line)      ;; For PuTTY

;; Make CTRL-<left>/<right> work like in Windows
(global-set-key (kbd "C-<left>") 'backward-word)
(global-set-key (kbd "C-<right>") 'forward-word)

(global-set-key (kbd "C-<up>") 'backward-paragraph)
(global-set-key (kbd "C-<down>") 'forward-paragraph)

(global-set-key (kbd "C-<backspace>") 'backward-kill-word)
(global-set-key (kbd "C-<delete>") 'kill-word)

;;(global-set-key (kbd "C-v") 'yank)

;;
;; CUA-Mode (http://www.emacswiki.org/emacs/CuaMode)
;; CUA - Common User Access
;;
;; This makes CTRL-c, CTRL-x and CTRL-v work for copy, cut and paste just like
;; in Windows apps.  It also enables SHIFT + arrow keys to select a region
;; along with a new rectange select where you define an anchor with CTRL-<ret>
;; and then move from there to select a rectangular region.
;;
;; It also binds CTRL-z to undo which is actually a little annoying since I've
;; become so used to using that to suspend the currently running app (often
;; character mode Emacs) and get back to shell prompt.
;;
;; Note that because CTRL-c is used as a prefix for many other Emacs commands,
;; it only behaves as the copy command when a region is active.
;;
(cua-mode t)
(setq cua-auto-tabify-rectangles nil)  ; Don't tabify after rectangle commands
(setq cua-keep-region-after-copy nil)  ; Disable the active region after copy

;; Bind M-e (ESC-e) to the function to eval the current buffer (as LISP).
;; Useful for re-loading the .emacs file.
(global-set-key (kbd "M-e") 'eval-buffer)

;; Enable electric buffer list
(global-set-key "\C-x\C-b" 'electric-buffer-list)

;; Common goto line mapping
(global-set-key "\C-xg" 'goto-line)

;; I need a new keybinding for suspending Emacs and going back to the bash prompt
;; since, with CUA-Mode C-z is now mapped to undo.
(global-set-key "\C-x\C-z" 'suspend-frame)

;; << Key bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; >> Customization of modes

;;
;; Colors
;;
;; To see all the colors that Emacs supports then run this command:
;;   M-x list-colors-display
;; This will then open up a buffer (called *Colors*) showing all the options
;;

;;
;; Color settings that apply across all modes
;;
(custom-set-faces
  '(font-lock-comment-face  ((t (:foreground "green"))))
  '(font-lock-keyword-face  ((t (:foreground "magenta1"))))
  '(font-lock-string-face  ((t (:foreground "brown"))))
  '(font-lock-constant-face  ((t (:foreground "red"))))
  '(font-lock-function-name-face  ((t (:foreground "red"))))
  '(font-lock-variable-name-face  ((t (:foreground "white"))))
  '(font-lock-builtin-face  ((t (:foreground "yellow"))))
  '(font-lock-type-face  ((t (:foreground "yellow"))))
  '(font-lock-warning-face  ((t (:foreground "red"))))
)


;;
;; CPerl-mode (<emacs_install_dir>/lisp/progmodes/cperl-mode.el)
;;
(setq-default cperl-continued-brace-offset -2)
(custom-set-faces
  '(cperl-array-face ((t (:foreground "SlateBlue1"))))
  '(cperl-hash-face  ((t (:foreground "OrangeRed1"))))
  '(cperl-invalid-face  ((t (:background "OrangeRed1"))))
)



;; << Customization of modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;
; Customization of c-mode
;
; Indent 2 spaces
(setq c-basic-indent 2)
; Disable indent for { on newline under if(), while(), ...
(defun my-c-mode-common-hook ()
  (c-set-offset 'substatement-open 0)
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;
; Customization of Perl-mode
;
;(setq perl-indent-level 2)
;(setq perl-tab-to-comment nil)

;
; Customization of Text-mode
;
;(setq-default indent-tabs-mode nil)
;(setq-default tab-width 2)
;(setq indent-line-function 'insert-tab)

;(custom-set-faces
;  ;; custom-set-faces was added by Custom.
;  ;; If you edit it by hand, you could mess it up, so be careful.
;  ;; Your init file should contain only one such instance.
;  ;; If there is more than one, they won't work right.
; '(cperl-array-face ((t (:foreground "yellow"))))
; '(cperl-hash-face ((t (:foreground "Red"))))
; '(font-lock-function-name-face ((((class color) (min-colors 88) (background light)) (:foreground "brightblue"))))
; '(highlight ((((class color) (min-colors 88) (background light)) (:background "cyan")))))

;(custom-set-variables
;  ;; custom-set-variables was added by Custom.
;  ;; If you edit it by hand, you could mess it up, so be careful.
;  ;; Your init file should contain only one such instance.
;  ;; If there is more than one, they won't work right.
; '(tab-stop-list (quote (2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 64 66 68 70 72 74 76 78 80 82 84 86 88 90 92 94 96 98 100 102 104 106 108 110 112 114 116 118 120))))



(message "Finished running .emacs")
