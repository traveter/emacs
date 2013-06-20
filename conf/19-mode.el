;; html-helper-mode + font color
(when (autoload-if-found 'html-helper-mode "html-helper-mode" "Yay HTML" t)
  (eval-after-load 'html-helper-mode
    '(progn
       (setq html-helper-verbose nil)
       )))
(when (autoload-if-found 'zencoding-mode "zencoding-mode" nil t)
  (add-hook 'html-helper-mode-hook '(lambda () (zencoding-mode t)))
  )
;; (defun php-imenu-create-index ()
;;   (let ((index))
;;     (goto-char (point-min))
;;     (while (re-search-forward "\\(id\\|class\\)=\"\\([^\"]+\\)\"" nil t)
;;       (push (cons (concat
;;                    (if (equal "id" (match-string 1)) "#" ".")
;;                    (match-string 2)) (match-beginning 1)) index))
;;     (nreverse index)))

(when (autoload-if-found 'coffee-mode "coffee-mode" "Major mode for editing CoffeeScript." t)
  (add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
  (add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))
  )

(when (autoload-if-found 'js2-mode "js2-mode" nil t)
  (eval-after-load 'js2-mode
    '(progn
	  ;; インデントの関数の再設定
	  (require 'js)
	  (setq js-indent-level 4
		js-expr-indent-offset 4
		indent-tabs-mode nil)
	  (req js2-imenu-extras)
	  (js2-imenu-extras-setup)
	  (set (make-local-variable 'indent-line-function) 'js-indent-line)
	  )))

;; css-mode の設定
(when (autoload-if-found 'css-mode "css-mode" nil t)
  ;;タブ幅を4に
  (setq cssm-indent-level 4)
  ;;インデントをc-styleにする
  (setq cssm-indent-function #'cssm-c-style-indenter)
  )

(when (autoload-if-found 'haskell-mode "haskell-mode-autoloads" nil t)
  (eval-after-load 'haskell-mode
    '(progn
       (req ghc
	    (add-hook 'haskell-mode-hook (lambda () (ghc-init) (flymake-mode)))
	    )))
  (add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
  )
;; less-css-mode の設定
(when (autoload-if-found 'less-css-mode "less-css-mode" nil t)
  (eval-after-load 'less-css-mode
    '(progn
       (if (string= (window-system) "w32")
	   (progn
	     (setq less-css-lessc-command "dotless.Compiler.exe")
	     (defun less-css-compile ()
	       "Compiles the current buffer to css using `less-css-lessc-command'."
	       (interactive)
	       (message "Compiling less to css")
	       (compile
		(mapconcat 'identity
			   (append (list (shell-quote-argument less-css-lessc-command))
				   less-css-lessc-options
				   (list (shell-quote-argument buffer-file-name)
					 " "
					 (shell-quote-argument (less-css--output-path))))
			   " ")))
	     )))))
;; (req multi-web-mode
;;      (setq mweb-default-major-mode 'web-mode)
;;      ;; (setq mweb-default-major-mode 'html-helper-mode)
;;      (setq mweb-tags
;; 	   '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
;; 	     ;; (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
;; 	     (html-mode " <<< HTML" "HTML")
;; 	     (smarty-mode "<!--{" "}-->")
;; 	     ;; (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")
;; 	     ))
;;      (setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5" "tpl"))
;;      (multi-web-global-mode 1)
;; )

(setq auto-mode-alist
      (append '(
		;; ("\\.\\(html\\|tpl\\|php[3-5]?\\)$"	.	web-mode)
      		;; ("\\.html\\'"		.	nxhtml-mumamo-mode)
      		("\\.html\\'"		.	html-mode)
      		("\\.\\(js\\|json\\)$"	.	js2-mode)
      		("\\.css$"		.	css-mode)
      		("\\.less$"		.	less-css-mode)
		) auto-mode-alist))
