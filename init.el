;; VanillaMerazimacs.el
;; Hello everybody! This is my init file but with a twist:
;; I'm trying to be as default as possible when using Emacs.
;; So I made some rules for myself:
;; 1. I can only use packages from GNU Elpa, Melpa is banned.
;;    (Just because it is not added by default, Melpa is cool)
;; 2. I won't use any pre-made themes, if I want a theme I will
;;    create it in this same file.
;; 3. No literate programming configuration is allowed, I'll use
;;    the Emacs language directly, and all the comments will be made
;;    using Emacs' dialect of lisp (using semi colons, like I'm doing
;;    right now).
;; 4. I shall not trespass the 80 columns imaginary line.
;; 5. I do not want to remove GUI elements like the top menu.
;; 6. I can use elisp functions made by myself.

;; add some contrast to the selected text background color
(set-face-attribute 'region nil :background "#aaa")

;; display color emojis
(set-fontset-font t '(#x1f000 . #x1faff)
		  (font-spec :family "Noto Color Emoji"))

;; auto complete pairs () []
(electric-pair-mode 1)

;; show pairs () []
(show-paren-mode 1)

;; buffer name = window name
(setq frame-title-format '("%b"))

;; i don't like blinking cursors
(blink-cursor-mode -1)

;; use y-n instead of yes-no in prompts
(fset 'yes-or-no-p 'y-or-n-p)

;; clean whitespace after saving
(add-hook 'before-save-hook 'whitespace-cleanup)

;; delete selected text
(delete-selection-mode 1)

;; enable ido mode, i'm a bit lazy when typing capital letters
(ido-mode 1)

;; lockfiles often create trouble
(setq create-lockfiles nil)

;; i want my temporary files (~) to be saved in a specific tmp directory
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; keep the custom code out of my init file
(setq custom-file (make-temp-file "emacs-custom"))

;; Some user defined functions
(defun mer/reload-config ()
  "This function will reload my configuration file."
  (interactive)
  (load-file (concat user-emacs-directory "init.el")))

;; Key bindings
(global-set-key "\C-xb" 'ibuffer)
(global-set-key "\C-ce" 'eww)
(global-set-key "\C-cs" 'eshell)
(global-set-key "\C-ck" 'kill-emacs)
(global-set-key "\C-cr" 'mer/reload-config)
