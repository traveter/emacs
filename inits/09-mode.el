;; html-helper-mode + font color
(autoload 'html-helper-mode "html-helper-mode" "Yay HTML" t)
(add-hook 'html-helper-load-hook '(lambda () (require 'html-font)))


;;php-mode
(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
(add-hook 'php-mode-hook '(lambda () (imenu-add-to-menubar "Imenu")))
(eval-after-load 'php-mode
  '(progn
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
     (require 'anything-config)
     (define-key ctl-x-map (kbd "b") 'anything)
     (define-key anything-map (kbd "C-M-n") 'anything-next-source)
     (define-key anything-map (kbd "C-M-p") 'anything-previous-source)
     (global-set-key [(C M \;)] 'anything)
     (require 'php-completion)
     (php-completion-mode t)
     (define-key php-mode-map (kbd "C-o") 'phpcmp-complete)
     (require 'flymake-php)
     (add-hook 'html-mumamo-mode-hook 'flymake-php-load)
     ;; キーバインド (flymake)
     (global-set-key "\M-p" 'flymake-goto-prev-error)
     (global-set-key "\M-n" 'flymake-goto-next-error)
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
      (append '(("¥¥.html$"		.	html-mumamo-mode)
		;; ("¥¥.shtml$"		.	nxhtml-mumamo-mode)
		("\\.php[3-5]?$"	.	nxhtml-mumamo-mode)
		;; ("\\.php[3-5]?$"	.	php-mode)
		("\\.\\(js\\|json\\)$"	.	js2-mode)
		("\\.css$"		.	css-mode)
		("\\.tpl\\'"		.	smarty-nxhtml-mumamo-mode)
		) auto-mode-alist))