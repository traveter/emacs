(setq abbrev-file-name (user:emacs-cache-path "abbrev_defs"))
(setq save-abbrevs nil)
;; (setq w3m-command (user:emacs-path "bin/w3m-0.5.3-mingw32/w3m.exe"))
(setq auto-save-list-file-prefix (user:emacs-cache-path "auto-save-list/.saves-"))
;; create backup file in ~/.emacs.d/backup
(setq backup-directory-alist
      (cons (cons "\\.*$" (user:emacs-cache-path "backup"))
            backup-directory-alist))
(setq auto-save-file-name-transforms
      `((".*", (user:emacs-cache-path "backup")) t))
(setq-default tab-width 4)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; (setq fill-column 80)
;; (setq bookmark-file (user:emacs-cache-path "bmk"))
;; ;; ブックマークを変更したら即保存する
;; (setq bookmark-save-flag 1)
;; ;; 超整理法
;; (setq bookmark-sort-flag nil)
;; (defun bookmark-arrange-latest-top ()
;;   (let ((latest ( bookmark-get-bookmark bookmark)))
;;     (setq bookmark-alist (cons latest (delq latest bookmark-aliset))))
;;   (bookmark-save))
;; (add-hook 'bookmark-after-jump-hook 'bookmark-arrange-latest-top)

(my/init-load
;;  (req recentf
;;       (custom-set-variables '(recentf-save-file (user:emacs-cache-path "recentf")))
;;       (setq recentf-max-saved-items 2000
;;             recentf-exclude '(".recentf")
;;             recentf-auto-cleanup 10
;;             recentf-auto-save-timer (run-with-idle-timer 30 t 'recentf-save-list)
;;             recentf-save-file (user:emacs-path "cache/recentf")
;;             )
;;       (recentf-mode 1))
;;  (auto-insert-mode)
;;  (setq auto-insert-directory (user:emacs-path "autoinsert/"))
;;  (setq auto-insert-alist
;;        (append '(("\\.tex" . "default.tex")) auto-insert-alist))
;;  (add-hook 'find-file-hooks 'auto-insert)

;;  (defvar my-recentf-list-prev nil)
;;  (defadvice recentf-save-list
;;    (around no-message activate)
;;    "If `recentf-list' and previous recentf-list are equal,
;; do nothing. And suppress the output from `message' and
;; `write-file' to minibuffer."
;;    (unless (equal recentf-list my-recentf-list-prev)
;;      (flet ((message (format-string &rest args)
;;                      (eval `(format ,format-string ,@args)))
;;             (write-file (file &optional confirm)
;;                         (let ((str (buffer-string)))
;;                           (with-temp-file file
;;                             (insert str)))))
;;        ad-do-it
;;        (setq my-recentf-list-prev recentf-list))))

;;  (defadvice recentf-cleanup
;;    (around no-message activate)
;;    "suppress the output from `message' to minibuffer"
;;    (flet ((message (format-string &rest args)
;;                    (eval `(format ,format-string ,@args))))
;;      ad-do-it))
 )
