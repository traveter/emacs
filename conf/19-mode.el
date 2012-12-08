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
(custom-set-variables '(nxhtml-auto-mode-alist))
(when (autoload-if-found 'smarty-html-mumamo-mode "nxhtml/autostart" nil t)
  (setq nxhtml-global-minor-mode t
	mumamo-chunk-coloring 'submode-colored
	nxhtml-skip-welcome t
	indent-region-mode t
	rng-nxml-auto-validate-flag nil
	)
  (eval-after-load "nxhtml/autostart"
    '(progn
       (setf nxhtml-setup-file-assoc (lambda()))
       (setq auto-mode-alist (append '(("\\.php[3-5]?$" . php-mode)) auto-mode-alist))
       (defun nxhtml-mode-toggle ()
	 (interactive)
	 (if (string-match "smarty" mode-name)
	   (progn
	     ;; (nxhtml-mumamo-mode)
	     (html-mumamo-mode)
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
     ((((class color) (min-colors 88) (background dark)) (;; :background "SteelBlue4"
								      ))))
   '(mumamo-background-chunk-submode1
     ((((class color) (min-colors 88) (background dark)) (:background "DarkOliveGreen"))))
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
(add-to-list 'ac-modes 'html-mode)1
;; (add-to-list 'ac-modes 'html-helper-mode)
;; (add-to-list 'ac-modes 'smarty-mode)
;; smarty-mode

(when (autoload-if-found 'smarty-mode "smarty-mode" nil t))
(modify-coding-system-alist 'file "\\.tpl\\'" 'utf-8)
(when (autoload-if-found 'zencoding-mode "zencoding-mode" nil t))
;; (defun user:web-mode ()
;;   (zencoding-mode t)
;;   (setq ac-sources '(
;; 		     ac-source-yasnippet
;; 		     ac-source-dictionary
;; 		     ac-source-words-in-buffer
;; 		     ac-source-words-in-same-mode-buffers
;; 		     )))

;; (add-hook 'nxhtml-mode-hook 'zencoding-mode)

;; (add-to-list 'ac-modes 'web-mode)
;; (add-hook 'html-helper-mode-hook 'user:web-mode)
;; (add-hook 'html-mode-hook 'user:web-mode)
;; (add-hook 'sgml-mode-hook 'user:web-mode)
;; (add-hook 'smarty-mode-hook 'user:web-mode)
;; (add-hook 'web-mode-hook 'user:web-mode)

(when (autoload 'web-mode "web-mode" nil t))
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
		;; ("\\.tpl$"				.	smarty-mode)
		;; ("\\.\\(html\\|tpl\\|php[3-5]?\\)$"	.	web-mode)
      		;; ("\\.html\\'"		.	nxhtml-mumamo-mode)
		("\\.tpl\\'"		.	smarty-html-mumamo-mode)
      		("\\.html\\'"		.	html-mode)
      		("\\.\\(js\\|json\\)$"	.	js2-mode)
		("\\.php[3-5]?$"	.	php-mode)
      		("\\.css$"		.	css-mode)
		) auto-mode-alist))

;; (add-hook 'html-mode (lambda ()
;; (defvar html-imenu-generic-expression
;;   '(
;;     ("TITLE" "<title>\\(.*\\)</title>" 1)
;;     ("DIV" "<div\\s-class=\"\\(.*\\)\"[^>]*>" 1)
;;     )
;;   "Imenu generic expression for HTML Mode.  See `imenu-generic-expression'."
;;   )
;; (imenu-add-to-menubar "Index")
;; 		       (setq imenu-generic-expression
;; 			     html-imenu-generic-expression)
;; 		       ))
;; (defun my-html-mode-setup-imenu ()
;;   (setq imenu-generic-expression
;;         '(
;; 	  ("TITLE" "<title>\\(.*\\)</title>" 1)
;; 	  ("DIV" "<div\\s-class=\"\\(.*\\)\"[^>]*>" 1)
;; 	))
;;   (setq imenu-case-fold-search nil)
;;   (setq imenu-auto-rescan t)
;;   (setq imenu-space-replacement " ")
;;   (imenu-add-menubar-index)
;;   )
;; (add-hook 'html-mode-hook 'my-html-mode-setup-imenu)
