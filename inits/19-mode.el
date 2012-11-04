;; html-helper-mode + font color
(when (autoload-if-found 'html-helper-mode "html-helper-mode" "Yay HTML" t))
(add-hook 'html-helper-load-hook '(lambda () (require 'html-font)))

;; (defun php-imenu-create-index ()
;;   (let ((index))
;;     (goto-char (point-min))
;;     (while (re-search-forward "\\(id\\|class\\)=\"\\([^\"]+\\)\"" nil t)
;;       (push (cons (concat
;;                    (if (equal "id" (match-string 1)) "#" ".")
;;                    (match-string 2)) (match-beginning 1)) index))
;;     (nreverse index)))


(load "nxhtml/autostart")
(setq nxhtml-global-minor-mode t
      mumamo-chunk-coloring 'submode-colored
      nxhtml-skip-welcome t
      indent-region-mode t
      rng-nxml-auto-validate-flag nil
      )
(global-set-key [f12] 'mumamo-no-chunk-coloring)
(custom-set-faces
 '(mumamo-background-chunk-major
   ((((class color) (min-colors 88) (background dark)) (:background "SteelBlue4")))) ; ここ
 '(mumamo-background-chunk-submode1
   ((((class color) (min-colors 88) (background dark)) (:background "SpringGreen4")))) ; ここ
 )

(lazyload (js2-mode) "js2"
	  ;; インデントの関数の再設定
	  (require 'js)
	  (setq js-indent-level 4
		js-expr-indent-offset 4
		indent-tabs-mode nil)
	  (set (make-local-variable 'indent-line-function) 'js-indent-line))
;; css-mode の設定
(lazyload (css-mode) "css-mode"
     ;;タブ幅を4に
     (setq cssm-indent-level 4)
     ;;インデントをc-styleにする
     (setq cssm-indent-function #'cssm-c-style-indenter)
     )
;; smarty-mode
(when (autoload-if-found 'smarty-mode "smarty-mode" "Smarty Mode" t))
;(modify-coding-system-alist 'file "\\.tpl\\'" 'utf-8-unix)

(add-hook 'nxhtml-mode-hook 'zencoding-mode)
(add-hook 'html-mode-hook 'zencoding-mode)
(add-hook 'smarty-mode-hook 'zencoding-mode)

(setq auto-mode-alist
      (append '(("¥¥.html$"		.	nxhtml-mumamo-mode)
		;; ("¥¥.shtml$"		.	nxhtml-mumamo-mode)
		("\\.php[3-5]?$"	.	nxhtml-mumamo-mode)
		;; ("\\.php[3-5]?$"	.	php-mode)
		("\\.\\(js\\|json\\)$"	.	js2-mode)
		("\\.css$"		.	css-mode)
		("\\.tpl\\'"		.	smarty-html-mumamo-mode)
		) auto-mode-alist))
