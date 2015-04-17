;; Emacs起動時にEshellを起動
;(add-hook 'after-init-hook (lambda() (eshell) ))

(defun eshell/clear ()
 "Clear the current buffer, leaving one prompt at the top."
 (interactive)
 (let ((inhibit-read-only t))
   (erase-buffer)))

(defun eshell/find-all-files (&rest args)
  "Open all non-directory files matching $1 on Eshell."
  (if (not (null args))
      ;; We have to expand the file names or else naming a directory in an
      ;; argument causes later arguments to be looked for in that directory,
      ;; not the starting directory
      (mapc
       #'(lambda (f)  (unless (file-directory-p f) (find-file f)))
       (mapcar #'expand-file-name (eshell-flatten-list args)))))

(defun pcomplete/sudo ()
  "Completion rules for the `sudo' command."
  (let ((pcomplete-help "complete after sudo"))
    (pcomplete-here (pcomplete-here (eshell-complete-commands-list)))))

;; eshell
(setq eshell-directory-name (user:emacs-cache-path "eshell/"))
(global-set-key (kbd "C-c e") 'eshell)
(custom-set-variables
 '(eshell-visual-commands (quote ("vi" "top" "screen" "less" "lynx"
                                  "ssh" "rlogin" "telnet"))))

(defun uniq-region (beg end)
  "Remove duplicate lines, a` la Unix uniq.
   If tempted, you can just do <<C-x h C-u M-| uniq RET>> on Unix."
  (interactive "r")
  (let ((ref-line nil))
      (uniq beg end
           (lambda (line) (string= line ref-line))
           (lambda (line) (setq ref-line line)))))

(defun uniq-remove-dup-lines (beg end)
  "Remove all duplicate lines wherever found in a file, rather than
   just contiguous lines."
  (interactive "r")
  (let ((lines '()))
    (uniq beg end
         (lambda (line) (assoc line lines))
         (lambda (line) (add-to-list 'lines (cons line t))))))

(defun uniq (beg end test-line add-line)
  (save-restriction
    (save-excursion
      (narrow-to-region beg end)
      (goto-char (point-min))
      (while (not (eobp))
    (if (funcall test-line (thing-at-point 'line))
        (kill-line 1)
      (progn
        (funcall add-line (thing-at-point 'line))
        (forward-line))))
      (widen))))

(defun my:eshell-mode-hook ()
  (setq history-delete-duplicates t)
  ;; 補完時に大文字小文字を区別しない
  (setq eshell-cmpl-ignore-case t)
  ;; 確認なしでヒストリ保存
  (setq eshell-ask-to-save-history (quote always))
  ;; 補完時にサイクルする
  (setq eshell-cmpl-cycle-completions t)
  ;;補完候補がこの数値以下だとサイクルせずに候補表示
  (setq eshell-cmpl-cycle-cutoff-length 5)
  (setq eshell-hist-ignoredups t)
  (req pcomplete
       ;; (ac-define-source pcomplete
       ;;   '((candidates . pcomplete-completions)))
       ;;           (setq ac-sources
       ;;                 '(
       ;;                   ac-source-pcomplete
       ;;                   ac-source-filename
       ;;                   ac-source-files-in-current-dir
       ;;                   ac-source-words-in-buffer
       ;;                   ac-source-dictionary))
       ;; (defun nm-eshell-pcomplete ()
       ;;   (interactive)
       ;;   (let ((ac-sources '(ac-source-pcomplete
       ;;                            ac-source-files-in-current-dir
       ;;                            ;; ac-source-filename
       ;;                            )))
       ;;          (auto-complete)))

       ;;           (defun nm-eshell-auto-complete ()
       ;;             (interactive)
       ;;             (let ((ac-sources '(ac-source-functions
       ;;                                 ac-source-variables
       ;;                                 ac-source-features
       ;;                                 ac-source-symbols
       ;;                                 ac-source-words-in-same-mode-buffers)))
       ;;               (auto-complete)))
       )
  (setq eshell-command-aliases-list
        (append '(
                 ("f" "find-file $1")
                 ("e*" "echo ${concat \"*\" $1}")
                 ("far" "find-all-files **/*$1*")
                 ("javac" "javac -J-Dfile.encoding=UTF-8 $*")
                 ("java" "java -Dfile.encoding=UTF-8 $*")
                 ("sh*" "shell-command-to-string \"$1\""))
                eshell-command-aliases-list))

  (bind-keys :map eshell-mode-map
    ("TAB" . pcomplete-list)
    ("T" nil)
    ("M-p" . helm-eshell-history)
    ("C-o" . helm-esh-pcomplete)
    ("C-a" . eshell-bol)
    ("C-p" . eshell-previous-matching-input-from-input)
    ("C-n" . eshell-next-matching-input-from-input))
  ;; (define-keys eshell-mode-map
  ;;   ;; ((kbd "TAB") . nm-eshell-pcomplete)
  ;;   ;; ((kbd "C-i") . nm-eshell-auto-complete))
  ;;   ("TAB" . pcomplete-list)
  ;;   ("T" nil)
  ;;   ((kbd "M-p") . helm-eshell-history)
  ;;   ((kbd "C-o") . helm-esh-pcomplete)
  ;;   ((kbd "C-a") . eshell-bol)
  ;;   ((kbd "C-p") . eshell-previous-matching-input-from-input)
  ;;   ((kbd "C-n") . eshell-next-matching-input-from-input))
                                        ; プロンプトの変更
  (setq eshell-prompt-function
        (lambda nil
          (concat
                                        ; (eshell/pwd)
           (if (= (user-uid) 0) " # " " $ ")))
        )
  )

(add-hook 'eshell-mode-hook 'my:eshell-mode-hook)

;; (eval-after-load 'em-hist
;;   '(progn
;;      (defun eshell-put-history (input &optional ring at-beginning)
;;        "Put a new input line into the history ring."
;;        (unless ring (setq ring eshell-history-ring))
;;        (unless (ring-member ring input)
;;          (if at-beginning
;;              (ring-insert-at-beginning ring input)
;;            (ring-insert ring input))))

;;      (defun eshell-write-history (&optional filename append)
;;        "Writes the buffer's `eshell-history-ring' to a history file.
;; The name of the file is given by the variable
;; `eshell-history-file-name'.  The original contents of the file are
;; lost if `eshell-history-ring' is not empty.  If
;; `eshell-history-file-name' is nil this function does nothing.

;; Useful within process sentinels.

;; See also `eshell-read-history'."
;;        (let ((file (or filename eshell-history-file-name)))
;;          (cond
;;           ((or (null file)
;;                (equal file "")
;;                (null eshell-history-ring)
;;                (ring-empty-p eshell-history-ring))
;;            nil)
;;           ((not (file-writable-p file))
;;            (message "Cannot write history file %s" file))
;;           (t
;;            (let* ((ring eshell-history-ring)
;;                   (index (ring-length ring)))
;;              ;; Write it all out into a buffer first.  Much faster, but
;;              ;; messier, than writing it one line at a time.
;;              (with-temp-buffer
;;                (while (> index 0)
;;                  (setq index (1- index))
;;                  (let ((start (point)))
;;                    (insert (ring-ref ring index) ?\n)
;;                    (subst-char-in-region start (1- (point)) ?\n ?\177)))
;;                (sort-lines nil (point-min) (point-max))
;;                (eshell-with-private-file-modes
;;                 (write-region (point-min) (point-max) file append
;;                               'no-message))))))))
;;      ))

;; より下に記述した物が PATH の先頭に追加されます
(dolist (dir (list
              "/sbin"
              "/usr/sbin"
              "/bin"
              "/usr/bin"
              "/usr/local/bin"
              (expand-file-name "~/bin")
			  (expand-file-name "~/.emacs.d/bin/cmigemo-default-win64")
              (expand-file-name "~/.emacs.d/bin/shellbin")
              (expand-file-name "~/.emacs.d/bin")
              ))
 ;; PATH と exec-path に同じ物を追加します
 (when (and (file-exists-p dir) (not (member dir exec-path)))
   (setenv "PATH" (concat dir ";" (getenv "PATH")))
   (setq exec-path (append (list dir) exec-path))))

;; zshの履歴検索予定
;; (defun popup-zsh_history ()
;;   "popup zsh_history"
;;   (interactive "*")
;;   (let ((aa 'nil)
;;      (history 'nil)
;;      (begin "\\(\\$ \\)")
;;      (end "\\([^ ]+\$\\)")
;;      (command-get-zsh_history "cat ~/.zsh_history | grep '")
;;      (path (buffer-substring
;;             (line-beginning-position)
;;             (line-end-position)
;;             ))
;;      (menu (make))
;;      )
;;     (setq path (replace-regexp-in-string begin "" path))
;;     (setq path (replace-regexp-in-string end "" path))
;;     (setq path (replace-regexp-in-string "  +" "" path))
;;     (setq result (shell-command-to-string
;;                (concat command-get-zsh_history path "'")))
;;     (setq history (split-string result "\n"))
;;     (popup-menu* history)
;;     (dolist (elem history)
;;       (cond ((not (string-match (concat "" path) elem)))
;;          (t  (add-to-list 'aa elem))
;;          ))
;; ;    (popup-menu* aa)
;;     ))
;(global-set-key (kbd "C-M-p") 'popup-zsh_history)
