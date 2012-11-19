(defvar php-imenu-generic-expression
  '(
    ("Private Methods"
     "^\\s-*\\(?:\\(?:abstract\\|final\\)\\s-+\\)?private\\s-+\\(?:static\\s-+\\)?function\\s-+\\(\\(?:\\sw\\|\\s_\\)+\\)\\s-*(" 1)
    ("Protected Methods"
     "^\\s-*\\(?:\\(?:abstract\\|final\\)\\s-+\\)?protected\\s-+\\(?:static\\s-+\\)?function\\s-+\\(\\(?:\\sw\\|\\s_\\)+\\)\\s-*(" 1)
    ("Public Methods"
     "^\\s-*\\(?:\\(?:abstract\\|final\\)\\s-+\\)?public\\s-+\\(?:static\\s-+\\)?function\\s-+\\(\\(?:\\sw\\|\\s_\\)+\\)\\s-*(" 1)
    ("Classes"
     "^\\s-*class\\s-+\\(\\(?:\\sw\\|\\s_\\)+\\)\\s-*" 1)

    ;("$value" "^\\s-*\\($+\\)\\([^(): ]+\\)" 2)
    ("Class variable" "^\\s-*$this->\\([^(): ]+\\)" 1)

    ("All Functions"
     "^\\s-*\\(?:\\(?:abstract\\|final\\|private\\|protected\\|public\\|static\\)\\s-+\\)*function\\s-+\\(\\(?:\\sw\\|\\s_\\)+\\)\\s-*(" 1)
    )
  "Imenu generic expression for PHP Mode.  See `imenu-generic-expression'."
  )
(add-hook 'php-mode-user-hook 'semantic-default-java-setup)
(add-hook 'php-mode-hook
	  '(lambda ()
	     (imenu-add-to-menubar "Imenu")
	     ;; (setq imenu-create-index-function 'semantic-create-imenu-index)
	     ;; (setq imenu-generic-expression php-imenu-generic-expression)
	     ;; (setq imenu-generic-expression
	     ;; 	   '(
	     ;; 	     ("class" "\\(class +\\)\\([^(): ]+\\)" 2)
	     ;; 	     ("function" "^[\t]*\\(function +\\)\\([^(): ]+\\)" 2)
	     ;; 	     ("$value" "^[\t]*\\($+\\)\\([^(): ]+\\)" 2)
	     ;; 	     ))

	     (setq tab-width 4
		   c-basic-offset 4
		   indent-tabs-mode t
		   php-mode-force-pear)
	     (c-set-offset 'case-label' 4)
	     (c-set-offset 'arglist-intro' 4)
	     (c-set-offset 'arglist-cont-nonempty' 4)
	     (c-set-offset 'arglist-close' 0)
	     ))
;;php-mode
(when (autoload-if-found 'php-mode "php-mode" "Major mode for editing php code." t)
  (eval-after-load 'php-mode
    '(progn
       ;; C-c RET: php-browse-manual
       (setq php-manual-url "http://www.php.net/manual/ja/")
       ;; C-c C-f: php-search-documentation
       (setq php-search-url "http://jp2.php.net/")
       ;; ;; 補完のためのマニュアルのパス
       ;; (setq php-manual-path "~/PHP/php-chunked-xhtml/")
       ;; (setq tags-file-name "~/PHP/phpeags/")
       ;; M-TAB が有効にならないので以下の設定を追加
       (define-keys php-mode-map ((kbd "C-M-i") 'php-complete-function)
	 ((kbd "C-M-a") 'php-beginning-of-defun)
	 ((kbd "C-M-e")'php-end-of-defun))
       ;; (req anything-config
       ;; 	  (define-key ctl-x-map (kbd "b") 'anything)
       ;; 	  (define-key anything-map (kbd "C-M-n") 'anything-next-source)
       ;; 	  (define-key anything-map (kbd "C-M-p") 'anything-previous-source)
       ;; 	  )
       ;; (req php-completion
       ;; 	  (php-completion-mode t)
       ;; 	  (define-key php-mode-map (kbd "C-o") 'phpcmp-complete)
       ;; 	  (make-variable-buffer-local 'ac-source)
       ;; 	  (add-to-list 'ac-source 'ac-source-php-completion)
       ;; 	  (auto-complete-mode t)
       ;; 	  )
       (req flymake-php
	    ;; (setq flymake-run-in-place nil)
	    (set-face-background 'flymake-errline "red")
	    (set-face-background 'flymake-warnline "blue")
	    ;; キーバインド (flymake)
	    (global-set-key (kbd "M-p") 'flymake-goto-prev-error)
	    (global-set-key (kbd "M-n") 'flymake-goto-next-error)
	    (global-set-key (kbd "C-c d") 'flymake-start-syntax-check)
	    (add-hook 'php-mode-user-hook 'flymake-php-load)
	    )
       )))

;; flymake を使えない場合をチェック
(defadvice flymake-can-syntax-check-file
  (after my-flymake-can-syntax-check-file activate)
  (cond
   ((not ad-return-value))
   ;; tramp 経由であれば、無効
   ((and (fboundp 'tramp-list-remote-buffers)
         (memq (current-buffer) (tramp-list-remote-buffers)))
    (setq ad-return-value nil))
   ;; 書き込み不可ならば、flymakeは無効
   ((not (file-writable-p buffer-file-name))
    (setq ad-return-value nil))
   ;; flymake で使われるコマンドが無ければ無効
   ((let ((cmd (nth 0 (prog1
                          (funcall (flymake-get-init-function buffer-file-name))
                        (funcall (flymake-get-cleanup-function buffer-file-name))))))
      (and cmd (not (executable-find cmd))))
    (setq ad-return-value nil))
   ))

(req popup
     ;; flymake 現在行のエラーをpopup.elのツールチップで表示する
     (defun flymake-display-err-menu-for-current-line ()
       (interactive)
       (let* ((line-no             (flymake-current-line-no))
	      (line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no))))
	 (when line-err-info-list
	   (let* ((count           (length line-err-info-list))
		  (menu-item-text  nil))
	     (while (> count 0)
	       (setq menu-item-text (flymake-ler-text (nth (1- count) line-err-info-list)))
	       (let* ((file       (flymake-ler-file (nth (1- count) line-err-info-list)))
		      (line       (flymake-ler-line (nth (1- count) line-err-info-list))))
		 (if file
		     (setq menu-item-text (concat menu-item-text " - " file "(" (format "%d" line) ")"))))
	       (setq count (1- count))
	       (if (> count 0) (setq menu-item-text (concat menu-item-text "\n")))
	       )
	     (popup-tip menu-item-text)))))
)
