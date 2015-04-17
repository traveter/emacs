;; (load "uniq")

;; (req qwerty
;; (when (autoload-if-found 'dvorak "qwerty" nil t)
;;   (eval-after-load 'dvorak
;;     '(progn
;;        (defun dvorak ()
;;       "Dvorak keyboard layout:
;; -------------------------------------------------------------------------
;; | Esc| 1  | 2  | 3  | 4  | 5 | 6  | 7  | 8  | 9  | 0  | *  | ^  | \  |
;; -------------------------------------------------------------------------
;; | Tab | '  | ,  | .  | p  | y  | f  | g  | c | r  | l  | =  | [  |  |
;; -------------------------------------------------------------------|      |
;; | Ctrl | a  | o  | e | u  | i  | d  | h  | t  | n  | s  | - | ]  | <- |
;; -------------------------------------------------------------------------
;; | Shift  | ; | q  | j  | k  | x  | b  | m  | w  | v | z  | / | Shift |
;; ---------------------------------------------------------------------

;; "
;;       (interactive)
;;       (anti-qwerty "',.pyfgcrl=(aoeuidhtns;)-qjkxbmwvz\"<>PYFGCRL+{AOEUIDHTNS$}:QJKXBMWVZ?*_@[]/"
;;                    "qwertyuiop@[asdfghjkl;:]zxcvbnm,./QWERTYUIOP`{ASDFGHJKL+*}ZXCVBNM<>?_-=$()'"))
;;       )))

(use-package dvorak-mode
  :bind (("C-^" . dvorak-mode)))
(use-package nav
  :bind (("C-x c" . nav-toggle)))

;; (when (autoload-if-found 'eccube-mode "eccube-mode" nil t)
;;   (global-set-key (kbd "C-x n") 'eccube-mode))

;; (when (autoload-if-found 'wordpress-mode "wordpress-mode" nil t)
;;   (global-set-key (kbd "C-x i") 'wordpress-mode))

;; (when (autoload-if-found 'e2wm:start-management "e2wm" nil t)
;;   (global-set-key (kbd "M-+") 'e2wm:start-management))

;; (req key-combo
;;      (key-combo-load-default)
;;      (key-combo-define-hook 'php-mode-hook
;;                          'key-combo-pointer-load-default
;;                          key-combo-pointer-default)
;;      ;; (key-combo-define-global (kbd "C-F") '("$"))
;;      ;; (key-combo-define-global (kbd "C-T") '("$this->"))
;;      )

;; (use-package generic-x
;;   :mode "\\.\\(conf\\|[hH][oO][tT][sS]\\|[iI][nN][iI]\\||[bB][aA][tT]\\|[cC][mM][dD]\\)\\'"
;;   )

;; (my/idle-time-load 5
;;                    ;; tramp
;;                    (req tramp
;;                         (cond ((eq system-type 'windows-nt)
;;                                (setq tramp-default-method "plink"))
;;                               (t     (setq tramp-default-method "scp")))
;;                         ;; (setq tramp-default-method "ssh")
;;                         ;; (setq tramp-default-method "plink")
;;                         ;; (setq tramp-shell-prompt-pattern "^[$#] ")
;;                         ;; trampで開いたファイルはバックアップファイルを作成しない
;;                         (add-to-list 'backup-directory-alist (cons tramp-file-name-regexp nil))
;;                         ))

;; (setq idle-require-symbols '(lambda() ))
;; (req lcomp
;;      (lcomp-install)
;;      )

;; (req which-func
;;      ;; java-mode と javascript-mode でも which-func を使う
;;      (setq which-func-modes (append which-func-modes '(java-mode javascript-mode php-mode)))
;;      (which-func-mode t)
;;      )

(defun user:hoge (arg)
  (interactive "p")
  (let ((query-char (read-char "Query Char:"))
        (p)
        (char ?a)
        (li)
        (flg)
        (end)
        (o)
        (overlay))
    (setq flg (eq query-char ?\^M))
    (save-excursion
      (when flg
        (end-of-line)
        (setq end (point)))
      (beginning-of-line)
      (while (not (eolp))
        (when flg
          (re-search-forward "[][!%&*+,-./:<=>?^_()'\"][\s-]*[[:alnum:]$]" end 0)
          (backward-char 1))
        (when (or (and flg (not (eolp)))
                  (and (eq (following-char) query-char) ;; a-zA-Z 26*2 = 52
                       (< (length li) 52)))
          (setq p (point))
          (setq o (make-overlay p (1+ p)))
          (overlay-put o 'face '(:foreground "red"))
          (overlay-put o 'display (char-to-string char))
          (add-to-list 'overlay o)
          (add-to-list 'li (cons char p))
          (setq char (if (eq char ?z) ?A (1+ char))))
        (forward-char 1)))
    (unwind-protect
        (cond ((eq (length li) 0))
              ((eq (length li) 1)
               (goto-char (cdr (car li))))
              (t
               (setq char (read-char "Move Char:"))
               (when (or (and (>= char ?a)
                              (<= char ?z))
                         (and (>= char ?A)
                              (<= char ?Z)))
                 (setq char (assoc char li))
                 (when (consp char)
                   (goto-char (cdr char))))))
      (dolist (o overlay) (delete-overlay o)))
    ))

(defun user:word ()
  (interactive)
  (let ((p (point))
        (reg "[^[:alnum:]_$]"))
    (if (region-active-p)
        (progn
          (let ((b (region-beginning))
                (e (region-end))
                (char)
                (flg nil)
                (match-char-list '((?\( . ?\))
                                   (?\[ . ?\])
                                   (?' . ?')
                                   (?\" . ?\")))
                (match-char))
            (save-excursion
              (goto-char (1- b))
              (setq char (following-char))
              (goto-char e)
              (setq match-char (assq char match-char-list))
              (cond ((and (consp match-char)
                          (eq (following-char) (cdr match-char)))
                     (setq flg 1))
                    ((eq (following-char) ?\()
                     (re-search-forward ")")
                     (setq e (point))
                     (setq flg 2))
                    ((eq (following-char) ?\[)
                     (re-search-forward "]")
                     (setq e (point))
                     (setq flg 2))
                    (t
                     (goto-char b)
                     ;; (re-search-backward "[^[:alnum:]_>-]+")
                     (re-search-backward "[^[:alnum:]_$>-]")
                     (setq b (1+ (point)))
                     (setq flg 2)
                     )
                    ))
            ;; (activate-mark)
            (cond ((eq flg 1)
                   (push-mark (1- b))
                   (goto-char (1+ e)))
                  ((eq flg 2)
                   (push-mark b)
                   (goto-char e)))
            ))
      (re-search-backward reg)
      (push-mark (1+ (point)))
      (goto-char p)
      (re-search-forward reg)
      (goto-char (1- (point)))
      (activate-mark))
    ))

;; (global-set-key (kbd "C-;") 'user:hoge)
(global-set-key (kbd "M-1") 'user:word)
