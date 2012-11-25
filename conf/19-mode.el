;; html-helper-mode + font color
(when (autoload-if-found 'html-helper-mode "html-helper-mode" "Yay HTML" t)

(defun my/html-helper-any-list-start (tag)
  (mapconcat 'identity
	     (mapcar (lambda (x) (concat "<" x)) tag) "\\|"))
(defun my/html-helper-any-list-end (tag)
  (mapconcat 'identity
	     (mapcar (lambda (x) (concat "</" x ">")) tag) "\\|"))
 )

(add-hook 'html-helper-load-hook '(lambda () (require 'html-font)))

;; (defun php-imenu-create-index ()
;;   (let ((index))
;;     (goto-char (point-min))
;;     (while (re-search-forward "\\(id\\|class\\)=\"\\([^\"]+\\)\"" nil t)
;;       (push (cons (concat
;;                    (if (equal "id" (match-string 1)) "#" ".")
;;                    (match-string 2)) (match-beginning 1)) index))
;;     (nreverse index)))

;; (load "nxhtml/autostart")
(when (autoload-if-found 'smarty-html-mumamo-mode "nxhtml/autostart" nil t)
  (setq nxhtml-global-minor-mode t
	mumamo-chunk-coloring 'submode-colored
	nxhtml-skip-welcome t
	indent-region-mode t
	rng-nxml-auto-validate-flag nil
	)
  (eval-after-load "nxhtml/autostart"
    '(progn
       (defun nxhtml-mode-toggle ()
	 (interactive)
	 (if (string-match "smarty" mode-name)
	   (progn
	     (nxhtml-mumamo-mode)
	     (setq my/nxhtml-mode-flg nil))
	   (smarty-html-mumamo-mode)
	   (setq my/nxhtml-mode-flg t)
	   )
	 (message mode-name)
	 )
       (define-keys nxhtml-menu-mode-map ((kbd "<f12>") 'mumamo-no-chunk-coloring)
	 ((kbd "<C-f12>") 'nxhtml-mode-toggle))))
  (custom-set-faces
   '(mumamo-background-chunk-major
     ((((class color) (min-colors 88) (background dark)) (:background "SteelBlue4")))) ; ここ
   '(mumamo-background-chunk-submode1
     ((((class color) (min-colors 88) (background dark)) (:background "SpringGreen4")))) ; ここ
   ))

(add-to-list 'ac-modes 'js2-mode)
(lazyload (js2-mode) "js2-mode"
	  ;; インデントの関数の再設定
	  (require 'js)
	  (setq js-indent-level 4
		js-expr-indent-offset 4
		indent-tabs-mode nil)
	  (req js2-imenu-extras)
	  (js2-imenu-extras-setup)
	  (set (make-local-variable 'indent-line-function) 'js-indent-line))
(when (autoload-if-found 'javascript-mode "javascript" nil t)
  (setq javascript-indent-level 2)
  )
(add-to-list 'ac-modes 'javascript-mode)
;; css-mode の設定
(lazyload (css-mode) "css-mode"
     ;;タブ幅を4に
     (setq cssm-indent-level 4)
     ;;インデントをc-styleにする
     (setq cssm-indent-function #'cssm-c-style-indenter)
     )
(add-to-list 'ac-modes 'html-mode)
(add-to-list 'ac-modes 'html-helper-mode)
(add-to-list 'ac-modes 'smarty-mode)
;; smarty-mode
(when (autoload-if-found 'smarty-mode "smarty-mode" "Smarty Mode" t))

;(modify-coding-system-alist 'file "\\.tpl\\'" 'utf-8-unix)
(when (autoload-if-found 'zencoding-mode "zencoding-mode" nil t))
(defun user:web-mode ()
  (zencoding-mode t)
  (setq ac-sources '(
		     ac-source-yasnippet
		     ac-source-dictionary
		     ac-source-words-in-buffer
		     ac-source-words-in-same-mode-buffers
		     )))

;; (add-hook 'nxhtml-mode-hook 'zencoding-mode)
;; (add-hook 'html-helper-mode-hook 'user:web-mode)
(add-hook 'html-mode-hook 'user:web-mode)
;; (add-hook 'sgml-mode-hook 'user:web-mode)
(add-hook 'smarty-mode-hook 'user:web-mode)

;; (req web-mode)
;; (add-to-list 'ac-modes 'web-mode)
;; (add-hook 'web-mode-hook 'user:web-mode)

;; (req multi-web-mode
;;      (setq mweb-default-major-mode 'html-mode)
;;      ;; (setq mweb-default-major-mode 'html-helper-mode)
;;      (setq mweb-tags
;; 	   '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
;; 	     (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
;; 	     (html-mode " <<< HTML" "HTML")
;; 	     (smarty-mode "<!--{" "}-->")
;; 	     (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
;;      (setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5" "tpl"))
;;      (multi-web-global-mode 1)
;; )

(setq auto-mode-alist
      (append '(
		("\\.php[3-5]?$"			.	php-mode)
		;; ("\\.tpl$"				.	smarty-mode)
		;; ("\\.\\(html\\|tpl\\|php[3-5]?\\)$"	.	web-mode)
      		("\\.html\\'"		.	nxhtml-mumamo-mode)
      		("\\.tpl\\'"		.	smarty-html-mumamo-mode)
      		("\\.\\(js\\|json\\)$"	.	js2-mode)
      		("\\.css$"		.	css-mode)
		) auto-mode-alist))
