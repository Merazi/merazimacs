;; merazimacs.el
;; My regular Emacs configuration with batteries included.  For my
;; vanilla config go to: https://git.sr.ht/~meraz_1/vanilla-merazimacs

;; performance tweaks (from sanemacs)

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

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

;; Enable melpa (I missed this)
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)

;; This is only needed once, near the top of the file
(require 'use-package)

;; display color emojis using a special font
(set-fontset-font t '(#x1f000 . #x1faff)
		  (font-spec :family "Noto Color Emoji"))

;; quality of editing tweaks
(setq visible-bell 1
      frame-title-format '("GNU Emacs: %b")
      org-ellipsis "▼")
(electric-pair-mode 1)
(show-paren-mode 1)
(line-number-mode 1)
(column-number-mode 1)
(set-fringe-mode '(10 . 5))
(blink-cursor-mode 1)
(add-hook 'before-save-hook 'whitespace-cleanup)
(defalias 'yes-or-no-p 'y-or-n-p)
(delete-selection-mode 1)
(global-auto-revert-mode t)
(tool-bar-mode -1)
(menu-bar-mode -1)

;; lockfiles often create trouble
(setq create-lockfiles nil)

;; i want my temporary files (~) to be saved in a specific tmp directory
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

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
  "Show the full file name of the current buffer in the minibuffer."
  (interactive)
  (message (concat "File path: " (buffer-file-name))))

(defun mer/xdg-open ()
  "Open dired file with external program."
  (interactive)
  (setq file (dired-get-file-for-visit))
  (shell-command (concat "xdg-open " (shell-quote-argument file))))

;; some hotkeys
(global-set-key "\C-ce" 'eww)
(global-set-key "\C-cs" 'eshell)
(global-set-key "\C-xb" 'buffer-menu)
(global-set-key "\C-ck" 'delete-frame)
(global-set-key "\C-cc" 'mer/edit-config)
(global-set-key "\C-cq" 'mer/reload-config)
(global-set-key "\C-cf" 'mer/show-full-file-path)
(eval-after-load "dired"
  '(progn (define-key dired-mode-map (kbd "M-o") 'other-window)
	  (define-key dired-mode-map (kbd "\C-co") 'mer/xdg-open)))

;; easier window resizing
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

;; don't send emacs to the background by mistake
(global-unset-key (kbd "C-z"))

;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)
(setq scroll-step 1)

;; easier font size control
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

;; eww (the web browser)
(setq eww-download-directory "~/Downloads/"
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
(add-to-list 'org-latex-packages-alist
	     '("AUTO" "babel" t ("pdflatex")))

;; additional org-mode settings
(setq-default org-src-tab-acts-natively t)
(setq-default org-src-preserve-indentation t)
(setq-default org-edit-src-content-indentation 2)
(setq-default org-adapt-indentation nil)

;; some packages
;; (use-package vala-mode :ensure t)
(use-package vala-snippets :ensure t)
(use-package skewer-mode :ensure t)
(use-package doom-themes :ensure t
  :config
  (load-theme 'doom-xcode t))
(use-package simple-modeline :ensure t)
(use-package yasnippet-snippets :ensure t)
(use-package impatient-mode :ensure t)
(use-package counsel :ensure t)
(use-package org-present :ensure t)
(use-package web-mode :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode)))
(use-package org-static-blog :ensure t ;; This config is specific to my website
  :config
  (setq org-static-blog-publish-title "Merazi's Webpage")
  (setq org-static-blog-publish-url "https://meraz_1.srht.site/")
  (setq org-static-blog-publish-directory "~/Projects/meraz_1.srht.site/")
  (setq org-static-blog-posts-directory "~/Projects/meraz_1.srht.site/posts/")
  (setq org-static-blog-drafts-directory "~/Projects/meraz_1.srht.site/drafts/")
  (setq org-static-blog-enable-tags t)
  (setq org-static-blog-preview-ellipsis "More ▼")
  (setq org-static-blog-use-preview t)
  (setq org-static-blog-index-length 3)
  (setq org-static-blog-preview-link-p t)
  (setq org-export-with-section-numbers nil)

  ;; <head> section of every page </head>
  (setq org-static-blog-page-header
	"<meta name=\"author\" content=\"Merazi\">
	 <link href= \"static/style.css\" rel=\"stylesheet\" type=\"text/css\" />
	 <link rel=\"icon\" href=\"static/favicon.ico\">")

  ;; <body> section of every page </body>
  (setq org-static-blog-page-preamble
	"<div class=\"header\">
	 <a href=\"https://meraz_1.srht.site\">Home</a>
	 <a href=\"https://meraz_1.srht.site/archive.html\">Archive</a>
	 <a href=\"https://meraz_1.srht.site/bookmarks.html\">Bookmarks</a>
	 <a href=\"https://meraz_1.srht.site/rss.xml\">Feed</a>
	 </div>")

  ;; home page top elements
  (setq org-static-blog-index-front-matter
	"<h1>Welcome to my webpage 😊</h1>
	 <div class=\"merazi_pfp\"><img src=\"media/merazi.jpg\"></div>\n"))
