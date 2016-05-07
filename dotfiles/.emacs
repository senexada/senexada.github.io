;; Turn off auto-save files
(setq make-backup-files nil)

;; Prompt before closing
(setq confirm-kill-emacs 'yes-or-no-p)

;; Ask when saving without a final newline
(setq require-final-newline 'ask)

;; Make the minibuffer line brighter
(set-face-foreground 'minibuffer-prompt "green")

;; Try making the "alt" interpret as meta
(setq mac-option-key-is-meta t)

;; Display column number in the status bar
(column-number-mode 1)

;; Make a split window with 80 chars on the leftmost pane
;;(split-window-right 82)  ;; This works in emacs 24 but not 23!
(split-window-horizontally 82)

;; This shows line number on the right, which I don't like for now:
;; (global-linum-mode 1)

;; Make meta-g a shortcut for goto-line
(global-set-key [(meta g)] 'goto-line)

;; I think this sets up our hrt style (4 char tabs, etc)
(defconst cs161-c-style
  '((c-tab-always-indent           . t)
    (c-comment-only-line-offset    . 0)
    (c-indent-comments-syntactically-p . t)
    (c-hanging-braces-alist        . ((class-open after)
				      (inline-open nil)
				      (inline-close after)
				      (substatement-open after)
				      (brace-list-open)))
    (c-hanging-colons-alist        . ((member-init-intro before)
				      (inher-intro)
				      (case-label after)
				      (label after)
				      (access-label after)))
    (c-cleanup-list                . (scope-operator
				      empty-defun-braces
				      defun-close-semi))
    (c-offsets-alist               . ((arglist-close . c-lineup-arglist)
				      (access-label      . /)
				      (block-open        . -4)
				      (case-label        . +)
				      (inline-open       . ++)
				      (knr-argdecl-intro . -)
				      (label             . *)
				      (substatement-open . 0)
				      ))
    (c-echo-syntactic-information-p . t)
    )
  "CS161 C Programming Style")

;; Customizations for all of c-mode, c++-mode, and objc-mode
(defun cs161-c-mode-common-hook ()
  ;; add my personal style and set it for the current buffer
  (c-add-style "cs161" cs161-c-style t)
  ;; offset customizations not in my-c-style
  (c-set-offset 'member-init-intro '++)
  ;; other customizations
  (setq tab-width 4
	;; this will make sure spaces are used instead of tabs
	indent-tabs-mode nil)
  ;; we like auto-newline and hungry-delete
  ;;(c-toggle-hungry-state 1)
  ;; keybindings for C, C++, and Objective-C.  We can put these in
  ;; c-mode-map because c++-mode-map and objc-mode-map inherit it
  (define-key c-mode-map "\C-m" 'newline-and-indent)
  (local-set-key "\C-o" 'ff-get-other-file)
  (font-lock-mode)
  )

(add-hook 'c-mode-common-hook 'cs161-c-mode-common-hook)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; IDO gives fancier auto-complete stuff in the minibuffer
;;(setq ido-enable-flex-matching t)
;;(ido-mode 1)
;; I didn't like the below settings
;;(setq ido-everywhere t)
;;(setq ido-use-filename-at-point 'guess)

;; I wrote this function based on this webpage:
;; http://puntoblogspot.blogspot.com/2013/10/yet-another-find-file-in-project-in.html

(defun jeff-find-dir (from to fun &optional if-nil)
  "Returns a dir between FROM and TO for which FUN returns non-nil"
  (when (not (file-exists-p from))
    (return))
  (if (or (equal (expand-file-name from) (expand-file-name to))
	  (equal from "/"))
      (or if-nil to)
    (if (funcall fun from) from
      (jeff-find-dir (expand-file-name (concat from "/../"))
		     to fun if-nil))))

(defun jeff-find-svn-root ()
  "Find svn root directory from the current directory"
  (interactive)
  (jeff-find-dir default-directory "~/"
		       (lambda (x) (or (file-exists-p (concat x ".svn"))
				       (file-exists-p (concat x ".git"))))))

(defun find-file-in-repo ()
  (interactive)
  (let* ((svn-root (jeff-find-svn-root))
	 (ido-enable-regexp nil)
	 (repo-files (split-string (with-temp-buffer
				     (cd svn-root)
				     (shell-command "find atl/src btrade/src itrade/src startrade/src startrade/autotest core/src -name '*.cc' -or -name '*.h' -or -name '*.py' -or -name '*.conf'" t)
				     (buffer-string)))))
;;    (debug)
    (find-file (concat svn-root "/"
		       (ido-completing-read "file: " repo-files t t)))))

(global-set-key (kbd "C-x C-o") 'find-file-in-repo)

