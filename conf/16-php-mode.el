(add-to-list 'auto-mode-alist '("\\.php[345s]?\\'" . php-mode))

(add-hook 'php-mode-hook
	  '(lambda ()
	     (req fill-column-indicator
		  (local-set-key [f4] 'fci-mode)
		  (fci-mode)
		  )
	     (imenu-add-to-menubar "Imenu")
	     ))

;;php-mode
(when (autoload-if-found 'php-mode "php-mode" "Major mode for editing php code." t)
  (eval-after-load 'php-mode
    '(progn
       (setq php-mode-force-pear t)
       (c-set-offset 'case-label 4)
       (c-set-offset 'arglist-intro 4)
       (c-set-offset 'arglist-cont-nonempty 4)
       ;; C-c RET: php-browse-manual
       (setq php-manual-url "http://www.php.net/manual/ja/")
       ;; C-c C-f: php-search-documentation
       ;; (setq php-search-url "http://jp2.php.net/")
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
       ;; ;; flymake を使えない場合をチェック
       ;; (defadvice flymake-can-syntax-check-file
       ;; 	 (after my-flymake-can-syntax-check-file activate)
       ;; 	 (cond
       ;; 	  ((not ad-return-value))
       ;; 	  ;; tramp 経由であれば、無効
       ;; 	  ((and (fboundp 'tramp-list-remote-buffers)
       ;; 		(memq (current-buffer) (tramp-list-remote-buffers)))
       ;; 	   (setq ad-return-value nil))
       ;; 	  ;; 書き込み不可ならば、flymakeは無効
       ;; 	  ((not (file-writable-p buffer-file-name))
       ;; 	   (setq ad-return-value nil))
       ;; 	  ;; flymake で使われるコマンドが無ければ無効
       ;; 	  ((let ((cmd (nth 0 (prog1
       ;; 				 (funcall (flymake-get-init-function buffer-file-name))
       ;; 			       (funcall (flymake-get-cleanup-function buffer-file-name))))))
       ;; 	     (and cmd (not (executable-find cmd))))
       ;; 	   (setq ad-return-value nil))
       ;; 	  ))
       ;; (req php-eldoc)
       ;; (req flex-autopair
       ;; 	    (flex-autopair-mode 1)
       ;; 	    )

       ;; (load-library (user:emacs-path "elisp/cedet-1.1/common/cedet.el"))
       ;; (defconst cedet-version "1.0.9" "Current version of CEDET.")
       ;; (global-ede-mode 1)
       ;; (semantic-load-enable-code-helpers)
       ;; (setq stack-trace-on-error t)
       ;; (req ecb)
       (defun hoge ()
	 (interactive)
	 (let ((path (expand-file-name (user:emacs-path "doc/"))))
	   (message (concat path "classes/" (current-word) ".html"))
	   (browse-url (concat path "classes/" (current-word) ".html"))
	   ))
       (define-key php-mode-map (kbd "C-x o") 'hoge)
       ;; (req flymake
       (load "emacs-flymake-master/flymake")
       (setq flymake-run-in-place nil
	     ;; flymake-timer 0
	     flymake-number-of-errors-to-display 4
	     )
	    ;; (defun my-popup-flymake-display-error ()
	    ;;   (interactive)
	    ;;   (let* ((line-no            (flymake-current-line-no))
	    ;; 	     (line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info
	    ;; 							       line-no)))
	    ;; 	     (count              (length line-err-info-list)))
	    ;; 	(while (> count 0)
	    ;; 	  (when line-err-info-list
	    ;; 	    (let* ((file       (flymake-ler-file (nth (1- count)
	    ;; 						      line-err-info-list)))
	    ;; 		   (full-file (flymake-ler-full-file (nth (1- count)
	    ;; 							  line-err-info-list)))
	    ;; 		   (text      (flymake-ler-text (nth (1- count)
	    ;; 						     line-err-info-list)))
	    ;; 		   (line      (flymake-ler-line (nth (1- count)
	    ;; 						     line-err-info-list))))
	    ;; 	      (popup-tip (format "[%s] %s" line text))))
	    ;; 	  (setq count (1- count)))))
	    (eval-after-load "flymake"
	      '(progn
;; Show error message under current line
(require 'popup)
(defun flymake-display-err-menu-for-current-line ()
  (interactive)
  (let* ((line-no (flymake-current-line-no))
         (line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no))))
    (when line-err-info-list
      (let* ((count (length line-err-info-list))
             (menu-item-text nil))
        (while (> count 0)
          (setq menu-item-text (flymake-ler-text (nth (1- count) line-err-info-list)))
          (let* ((file (flymake-ler-file (nth (1- count) line-err-info-list)))
                 (line (flymake-ler-line (nth (1- count) line-err-info-list))))
            (if file
                (setq menu-item-text (concat menu-item-text " - " file "(" (format "%d" line) ")"))))
          (setq count (1- count))
          (if (> count 0) (setq menu-item-text (concat menu-item-text "\n")))
          )
        (popup-tip menu-item-text)))))

;; If you don't set :height, :bold face parameter of 'pop-tip-face,
;; then seting those default values
(if (eq 'unspecified (face-attribute 'popup-tip-face :height))
    (set-face-attribute 'popup-tip-face nil :height 1.0))
(if (eq 'unspecified (face-attribute 'popup-tip-face :weight))
    (set-face-attribute 'popup-tip-face nil :weight 'normal))

(defun my/display-error-message ()
  (interactive)
  (let ((orig-face (face-attr-construct 'popup-tip-face)))
    (set-face-attribute 'popup-tip-face nil
                        :height 1.5 :foreground "firebrick"
                        :background "LightGoldenrod1" :bold t)
    (unwind-protect
        (flymake-display-err-menu-for-current-line)
      (while orig-face
        (set-face-attribute 'popup-tip-face nil (car orig-face) (cadr orig-face))
        (setq orig-face (cddr orig-face))))))
(defadvice flymake-goto-prev-error (after flymake-goto-prev-error-display-message)
  (my/display-error-message))
(defadvice flymake-goto-next-error (after flymake-goto-next-error-display-message)
  (my/display-error-message))

(ad-activate 'flymake-goto-prev-error 'flymake-goto-prev-error-display-message)
(ad-activate 'flymake-goto-next-error 'flymake-goto-next-error-display-message)
		 (set-face-background 'flymake-errline "red")
		 (set-face-background 'flymake-warnline "blue")
		 ;; (defun my/flymake-syntax-check ()
		 ;;   (interactive)
		 ;;   (flymake-start-syntax-check)
		 ;;   (my-popup-flymake-display-error)
		 ;;   )
		 (define-keys php-mode-map ((kbd "M-p") 'flymake-goto-prev-error)
		   ((kbd "M-n") 'flymake-goto-next-error)
		   ;; ((kbd "C-c d") 'flymake-start-syntax-check))
		   ;; ((kbd "C-c d") 'my/flymake-syntax-check))
		   ((kbd "C-c d") 'flymake-start-syntax-check))
		 (add-hook 'php-mode-hook '(lambda () (flymake-mode)))
		 ));;)
       )))
