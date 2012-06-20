;; html-helper-mode + font color
(autoload 'html-helper-mode "html-helper-mode" "Yay HTML" t)
(add-hook 'html-helper-load-hook '(lambda () (require 'html-font)))

;; php-mode
(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
(add-hook 'php-mode-hook '(lambda ()
			    (imenu-add-to-menubar "Imenu")
			    (setq tab-width 4)
			    (setq c-basic-offset 4)
			    (setq indent-tabs-mode t)
			    (setq php-mode-force-pear)
			    ))
(when (autoload-if-found 'anything "anything-config" nil t)
  (define-key ctl-x-map (kbd "b") 'anything)
  (eval-after-load "anything-config"
    '(progn
       (define-key anything-map (kbd "C-M-n") 'anything-next-source)
       (define-key anything-map (kbd "C-M-p") 'anything-previous-source)
       )))

(eval-after-load 'php-mode
  '(progn
     (when (autoload-if-found 'phpcmp-complete "php-completion" nil t)
       (define-key php-mode-map (kbd "C-o") 'phpcmp-complete)
       (eval-after-load "php-completion"
	 '(progn
	    (php-completion-mode t)
	    (make-variable-buffer-local 'ac-source)
	    (add-to-list 'ac-source 'ac-source-php-completion)
	    (auto-complete-mode t)
	    )))
     ;; C-c RET: php-browse-manual
     (setq php-manual-url "http://www.php.net/manual/ja/")
     ;; C-c C-f: php-search-documentation
     (setq php-search-url "http://jp2.php.net/")
     ;; 補完のためのマニュアルのパス
     (setq php-manual-path "~/PHP/php-chunked-xhtml/")
     (setq tags-file-name "~/PHP/phpeags/")
     ;; M-TAB が有効にならないので以下の設定を追加
     (define-key php-mode-map (kbd "C-M-i") 'php-complete-function)
     ;; その他
     (define-key php-mode-map (kbd "C-M-a") 'php-beginning-of-defun)
     (define-key php-mode-map (kbd "C-M-e")'php-end-of-defun)
     ;; (require 'anything-config)
     ;; (define-key ctl-x-map (kbd "b") 'anything)
     ;; (define-key anything-map (kbd "C-M-n") 'anything-next-source)
     ;; (define-key anything-map (kbd "C-M-p") 'anything-previous-source)
     ;; (require 'php-completion)
     ;; (php-completion-mode t)
     ;; (define-key php-mode-map (kbd "C-o") 'phpcmp-complete)
     ;; (make-variable-buffer-local 'ac-source)
     ;; (add-to-list 'ac-source 'ac-source-php-completion)
     ;; (auto-complete-mode t)
     (require 'flymake-php)
     (add-hook 'html-mumamo-mode-hook 'flymake-php-load)
     ;; キーバインド (flymake)
     (global-set-key (kbd "M-p") 'flymake-goto-prev-error)
     (global-set-key (kbd "M-n") 'flymake-goto-next-error)
     (global-set-key "\C-cd" 'flymake-start-syntax-check)
     ))

(load "nxhtml/autostart")
(setq nxhtml-global-minor-mode t
      mumamo-chunk-coloring 'submode-colored
      nxhtml-skip-welcome t
      indent-region-mode t
      rng-nxml-auto-validate-flag nil
      )
(custom-set-faces
 '(mumamo-background-chunk-major
   ((((class color) (min-colors 88) (background dark)) (:background "SteelBlue4")))) ; ここ
 '(mumamo-background-chunk-submode1
   ((((class color) (min-colors 88) (background dark)) (:background "SpringGreen4")))) ; ここ
 )

(autoload 'js2-mode "js2" nil t)
;; css-mode の設定
(autoload 'css-mode "css-mode")
(setq cssm-indent-function #'cssm-c-style-indenter)
;; smarty-mode
(autoload 'smarty-mode "smarty-mode" "Smarty Mode" t)
;(modify-coding-system-alist 'file "\\.tpl\\'" 'utf-8-unix)

(add-hook 'nxhtml-mode-hook 'zencoding-mode)
(add-hook 'html-mode-hook 'zencoding-mode)
(add-hook 'smarty-mode-hook 'zencoding-mode)

(setq auto-mode-alist
      (append '(("¥¥.html$"		.	nxhtml-mumamo-mode)
		;; ("¥¥.shtml$"		.	nxhtml-mumamo-mode)
		;; ("\\.php[3-5]?$"	.	html-mumamo-mode)
		("\\.php[3-5]?$"	.	php-mode)
		("\\.\\(js\\|json\\)$"	.	js2-mode)
		("\\.css$"		.	css-mode)
		("\\.tpl\\'"		.	smarty-html-mumamo-mode)
		) auto-mode-alist))