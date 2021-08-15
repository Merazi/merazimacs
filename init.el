;; VanillaMerazimacs.el
;; Hello everybody! This is my init file but with a twist:
;; I'm trying to be as default as possible when using Emacs.
;; So I made some rules for myself:
;;
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

;; performance tweaks (from sanemacs)
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(add-hook 'after-init-hook #'(lambda ()
			       ;; restore after startup
			       (setq gc-cons-threshold 800000)))

;; increases garbage collection during startup
;; copied from: https://pastebin.com/mrPsnUas
(setq startup/gc-cons-threshold gc-cons-threshold)
(setq gc-cons-threshold most-positive-fixnum)
(defun startup/reset-gc ()
  (setq gc-cons-threshold startup/gc-cons-threshold))
(add-hook 'emacs-startup-hook 'startup/reset-gc)

;; since I'm not downloading a lot of packages i'll turn package.el off
(setq package-enable-at-startup nil)

;; this is my “color scheme”
(set-face-attribute 'region nil :background "#bcf")

;; display color emojis
(set-fontset-font t '(#x1f000 . #x1faff)
		  (font-spec :family "Noto Color Emoji"))

;; silence please
(setq visible-bell 1)

;; auto complete pairs () []
(electric-pair-mode 1)

;; show pairs () []
(show-paren-mode 1)

;; show line numbers and column numbers in the modeline
(line-number-mode 1)
(column-number-mode 1)

;; set the fringe value
(set-fringe-mode '(10 . 5))

;; buffer name = window name
(setq frame-title-format '("%b"))

;; i like blinking cursors
(blink-cursor-mode 1)

;; clean whitespace after saving
(add-hook 'before-save-hook 'whitespace-cleanup)

;; use y or n instead of yes or no
(defalias 'yes-or-no-p 'y-or-n-p)

;; delete selected text
(delete-selection-mode 1)

;; lockfiles often create trouble
(setq create-lockfiles nil)

;; i want my temporary files (~) to be saved in a specific tmp directory
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; auto update the buffer if the file has changed on disk
(global-auto-revert-mode t)

;; keep the custom code out of my init file
(setq custom-file (make-temp-file "emacs-custom"))

;; some user defined functions
(defun mer/reload-config ()
  "This function will reload my configuration file."
  (interactive)
  (load-file user-init-file))

(defun mer/edit-config ()
  "Easy access to my emacs config."
  (interactive)
  (find-file user-init-file))

(defun mer/show-full-file-path ()
  "This function allows me to see the path of the buffer I'm editing"
  (interactive)
  (message buffer-file-name))

(defun mer/xdg-open ()
  "Open dired file with external program."
  (interactive)
  (setq file (dired-get-file-for-visit))
  (shell-command (concat "xdg-open " (shell-quote-argument file))))

;; some hotkeys
(global-set-key "\C-ce" 'eww)
(global-set-key "\C-cs" 'eshell)
(global-set-key "\C-xb" 'buffer-menu)
(global-set-key "\C-ck" 'kill-emacs)
(global-set-key "\C-co" 'mer/xdg-open)
(global-set-key "\C-cc" 'mer/edit-config)
(global-set-key "\C-cq" 'mer/reload-config)
(global-set-key "\C-cf" 'mer/show-full-file-path)

;; eww (the web browser)
(setq eww-download-directory "/home/merazi/Downloads/"
      eww-desktop-remove-duplicates t
      eww-history-limit 20
      eww-search-prefix "https://lite.duckduckgo.com/lite/?q=")

;; set the default guile command
(setq gud-guiler-command-name "guile --no-auto-compile")

;; dired
(setq dired-hide-details-hide-symlink-targets t
      dired-listing-switches "-lhFa --color=auto")

;; org-export to latex
(require 'ox-latex)
(setq org-latex-toc-command "\\tableofcontents \\clearpage")

;; Org-mode fold character
(setq org-ellipsis "▼")

;; my simple modeline configuration
 (set-face-attribute 'mode-line nil
		    :background "#eee"
		    :foreground "#444"
		    :overline nil
		    :underline nil)
 (set-face-attribute 'mode-line-inactive nil
		    :background "#fff"
		    :foreground "#aaa"
		    :overline nil
		    :underline nil)
