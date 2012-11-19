;; (require 'linum)
;; (global-linum-mode t)
;; (setq linum-format "%4d")
;; (defun linum-toggle()
;;   (interactive)
;;   (linum-mode)
;;   )
;;(global-set-key [f7] 'linum-toggle)
(global-set-key [f7] 'linum-mode)
;; (defadvice linum-on(around my-linum-w3m-on() activate)
;;   (unless ;; (or (eq major-mode 'w3m-mode)
;;       (string-match "^[\s\*]$*" (buffer-name))
;;     ad-do-it))

(setq abbrev-file-name (user:emacs-cache-path "abbrev_defs"))

;; create backup file in ~/.emacs.d/backup
(setq backup-directory-alist
      (cons (cons "\\.*$" (user:emacs-cache-path "backup"))
            backup-directory-alist))
;; create auto-save file in ~/.emacs.d/backup
(setq auto-save-file-name-transforms
      `((".*", (user:emacs-cache-path "backup")) t))
(setq bookmark-file (user:emacs-cache-path "bmk"))
;; ブックマークを変更したら即保存する
(setq bookmark-save-flag 1)
;; 超整理法
(progn
  (setq bookmark-sort-flag nil)
  (defun bookmark-arrange-latest-top ()
    (let ((latest ( bookmark-get-bookmark bookmark)))
      (setq bookmark-alist (cons latest (delq latest bookmark-aliset))))
    (bookmark-save))
  (add-hook 'bookmark-after-jump-hook 'bookmark-arrange-latest-top))

;; (when (require 'recentf nil t)
;;   (setq recentf-max-saved-items 2000
;; 	recentf-exclude '(".recentf")
;; 	recentf-auto-cleanup 10
;; 	recentf-auto-save-timer (run-with-idle-timer 30 t 'recentf-save-list)
;; 	recentf-save-file (concat user:emacs-directory "cache/recentf")
;; 	)
;;   (recentf-mode 1))
(defvar my-recentf-list-prev nil)

(defadvice recentf-save-list
  (around no-message activate)
  "If `recentf-list' and previous recentf-list are equal,
do nothing. And suppress the output from `message' and
`write-file' to minibuffer."
  (unless (equal recentf-list my-recentf-list-prev)
    (flet ((message (format-string &rest args)
		    (eval `(format ,format-string ,@args)))
	   (write-file (file &optional confirm)
		       (let ((str (buffer-string)))
			 (with-temp-file file
			   (insert str)))))
      ad-do-it
      (setq my-recentf-list-prev recentf-list))))

(defadvice recentf-cleanup
  (around no-message activate)
  "suppress the output from `message' to minibuffer"
  (flet ((message (format-string &rest args)
		  (eval `(format ,format-string ,@args))))
    ad-do-it))

(custom-set-variables '(recentf-save-file (user:emacs-cache-path "recentf")))
(setq ;; recentf-save-file (concat user:emacs-directory "cache/recentf")
      recentf-max-saved-items 2000
      recentf-exclude '(".recentf")
      recentf-auto-save-timer (run-with-idle-timer 30 t 'recentf-save-list)
      recentf-auto-cleanup 10)
(recentf-mode 1)
