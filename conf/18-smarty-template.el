;; (setq auto-mode-alist
;;       (append '(("\\.\\(html\\|tpl\\)\\'" . web-mode)
;;                 ) auto-mode-alist))
;;       ;; (append '(("\\.tpl\\'" . smarty-html-mumamo-mode)) auto-mode-alist))

(use-package web-mode
  :mode "\\.\\(html\\|tpl\\)\\'"
  :config
  (setq web-mode-ac-sources-alist)
  (add-to-list 'ac-modes 'web-mode)
  (use-package angular-snippets)
  (use-package auto-complete
	:config
	(use-package ac-emmet
	  :config
	  (ac-emmet-html-setup)
	  (setq web-mode-ac-sources-alist
			;; '(("php" . (ac-source-yasnippet ac-source-php-auto-yasnippets))
			'(("php" . (ac-source-yasnippet))
			  ("html" . (ac-source-emmet-html-aliases ac-source-emmet-html-snippets))
			  ("css" . (ac-source-css-property ac-source-emmet-css-snippets))))
	  (use-package yasnippet
		:config
		(add-hook 'web-mode-before-auto-complete-hooks
				  '(lambda ()
					 (let ((web-mode-cur-language
							(web-mode-language-at-pos)))
					   (if (string= web-mode-cur-language "php")
						   (yas-activate-extra-mode 'php-mode)
						 (yas-deactivate-extra-mode 'php-mode))
					   (if (string= web-mode-cur-language "css")
						   (setq emmet-use-css-transform t)
						 (setq emmet-use-css-transform nil))))))
	  ))
  (when (featurep 'auto-complete))

  (setq web-mode-enable-block-faces t
		web-mode-markup-indent-offset 4
		web-mode-css-indent-offset 4
		web-mode-code-indent-offset 4)
  (define-key web-mode-map (kbd "C-;") nil)
  )
(use-package angularjs-mode
;;   :config
;;   (use-package auto-complete
;; 	:config
;; 	(add-to-list 'ac-modes 'angularjs-mode)))
)
(modify-coding-system-alist 'file "\\.tpl\\'" 'utf-8)
;; (when (autoload-if-found 'smarty-mode "smarty-mode" nil t)
;;   (modify-coding-system-alist 'file "\\.tpl\\'" 'utf-8))

;; (custom-set-variables '(nxhtml-auto-mode-alist))
;; (when (autoload-if-found 'smarty-html-mumamo-mode "nxhtml/autostart" nil t)
;;   (setq nxhtml-global-minor-mode t
;;      mumamo-chunk-coloring 'submode-colored
;;      nxhtml-skip-welcome t
;;      indent-region-mode t
;;      rng-nxml-auto-validate-flag nil
;;      )
;;   (eval-after-load "nxhtml/autostart"
;;     '(progn
;; (req guide-key
;;      (guide-key-mode 1)
;;      (add-hook 'html-helper-mode-hook
;;             '(lambda ()
;;                (guide-key/add-local-guide-key-sequence "C-c")
;;                (guide-key/add-local-guide-key-sequence "C-c C-a")
;;                (guide-key/add-local-guide-key-sequence "C-c C-l")
;;                (guide-key/add-local-guide-key-sequence "C-c M-h")
;;                (guide-key/add-local-guide-key-sequence "C-c M-l")
;;                (guide-key/add-local-guide-key-sequence "C-c C-p")
;;                (guide-key/add-local-guide-key-sequence "C-c C-t")
;;                (guide-key/add-local-guide-key-sequence "C-c C-h")
;;                (guide-key/add-local-guide-key-sequence "C-c C-f")
;;                (guide-key/add-local-guide-key-sequence "C-c C-s")
;;                (setq guide-key/add-local-highlight-command-regexp "html-helper-")
;;                ))
;;      (add-hook 'smarty-mode-hook
;;             '(lambda ()
;;                (guide-key/add-local-guide-key-sequence "C-c C-t")
;;                (guide-key/add-local-guide-key-sequence "C-c C-t C-b")
;;                (guide-key/add-local-guide-key-sequence "C-c C-t C-c")
;;                (guide-key/add-local-guide-key-sequence "C-c C-t C-v")
;;                (guide-key/add-local-highlight-command-regexp "smarty-")
;;                ))
;;      )

;; ;; Keep this separate for easier debugging.
;; (defun mumamo-do-fontify (start end verbose chunk-syntax-min chunk-syntax-max chunk-major)
;;   "Fontify region between START and END.
;; If VERBOSE is non-nil then print status messages during
;; fontification.

;; CHUNK-SYNTAX-MIN, CHUNK-SYNTAX-MAX and CHUNK-MAJOR are the
;; chunk's min point, max point and major mode.

;; During fontification narrow the buffer to the chunk to make
;; syntactic fontification work.  If chunks starts or end with \"
;; then the first respective last char then exclude those chars from
;; from the narrowed part, since otherwise the syntactic
;; fontification can't find out where strings start and stop.

;; Note that this function is run under
;; `mumamo-with-major-mode-fontification'.

;; This function takes care of `font-lock-dont-widen' and
;; `font-lock-extend-region-functions'.  Normally
;; `font-lock-default-fontify-region' does this, but that function
;; is not called when mumamo is used!

;; PS: `font-lock-fontify-syntactically-region' is the main function
;; that does syntactic fontification."
;;   ;;(msgtrc "mumamo-do-fontify enter: font-lock-keywords-only def=%s" (default-value 'font-lock-keywords-only))
;;   ;;(msgtrc "mumamo-do-fontify <<<<<<< %s %s %s %s %s %s" start end verbose chunk-syntax-min chunk-syntax-max chunk-major)
;;   ;;(msgtrc "font-lock-keywords=%S" font-lock-keywords)
;;   ;;(mumamo-assert-fontified-t start end)
;;   (mumamo-condition-case err
;;       (let* ((font-lock-dont-widen t)
;;              (font-lock-extend-region-functions
;;               ;; nil
;;               font-lock-extend-region-functions
;;               )
;;              ;; Extend like in `font-lock-default-fontify-region':
;;              (funs font-lock-extend-region-functions)
;;              (font-lock-beg (max chunk-syntax-min start))
;;              (font-lock-end (min chunk-syntax-max end))
;;              (n1-while 0))
;;         (while (and (mumamo-while 500 'n1-while "funs")
;;                     funs)
;;           (setq funs (if (or (not (funcall (car funs)))
;;                              (eq funs font-lock-extend-region-functions))
;;                          (cdr funs)
;;                        ;; If there's been a change, we should go through
;;                        ;; the list again since this new position may
;;                        ;; warrant a different answer from one of the fun
;;                        ;; we've already seen.
;;                        font-lock-extend-region-functions)))
;;         ;; But we must restrict to the chunk here:
;;         (let ((new-start (max chunk-syntax-min font-lock-beg))
;;               (new-end (min chunk-syntax-max font-lock-end)))
;;           ;;(msgtrc "do-fontify %s %s, chunk-syntax-min,max=%s,%s, new: %s %s" start end chunk-syntax-min chunk-syntax-max new-start new-end)
;;           ;; A new condition-case just to catch errors easier:
;;           (when (< new-start new-end)
;;             (mumamo-condition-case err
;;                 (save-restriction
;;                   ;;(when (and (>= 625 (point-min)) (<= 625 (point-max))) (msgtrc "multi at 625=%s" (get-text-property 625 'font-lock-multiline)))
;;                   ;;(msgtrc "(narrow-to-region %s %s)" chunk-syntax-min chunk-syntax-max)
;;                   (when (< chunk-syntax-min chunk-syntax-max)
;;                     (narrow-to-region chunk-syntax-min chunk-syntax-max)
;;                     ;; Now call font-lock-fontify-region again but now
;;                     ;; with the chunk font lock parameters:
;;                     (setq font-lock-syntactically-fontified (1- new-start))
;;                     (mumamo-msgfntfy "ENTER font-lock-fontify-region %s %s %s" new-start new-end verbose)
;;                     ;;(msgtrc "mumamo-do-fontify: font-lock-keywords-only =%s in buffer %s, def=%s" font-lock-keywords-only (current-buffer) (default-value 'font-lock-keywords-only))
;;                     (let (font-lock-extend-region-functions)
;;                       (font-lock-fontify-region new-start new-end verbose))
;;                     (mumamo-msgfntfy "END font-lock-fontify-region %s %s %s" new-start new-end verbose)
;;                     )
;;                   )
;;               (error
;;                ;; (mumamo-display-error 'mumamo-do-fontify-2
;;                ;;                       "mumamo-do-fontify m=%s, s/e=%s/%s syn-min/max=%s/%s: %s"
;;                ;;                       chunk-major
;;                ;;                       start end
;;                ;;                       chunk-syntax-min chunk-syntax-max
;;                ;;                       (error-message-string err))
;;             )))))
;;     (error
;;      ;; (mumamo-display-error 'mumamo-do-fontify
;;      ;;                       "mumamo-do-fontify m=%s, s=%s, e=%s: %s"
;;      ;;                       chunk-major start end (error-message-string err))
;;      )
;;     )
;;   ;; (mumamo-msgfntfy "mumamo-do-fontify exit >>>>>>> %s %s %s %s %s %s" start end verbose chunk-syntax-min chunk-syntax-max chunk-major)
;;   ;;(msgtrc "mumamo-do-fontify exit: font-lock-keywords-only def=%s" (default-value 'font-lock-keywords-only))
;;   )
;; (defconst mumamo-script-tag-start-regex
;;   (rx "<script"
;;       space
;;       (0+ (not (any ">")))
;;       "type"
;;       (0+ space)
;;       "="
;;       (0+ space)
;;       ;;(or "text" "application")
;;       ;;"/"
;;       ;;(or "javascript" "ecmascript")
;;       (or "'text/javascript'" "\"text/javascript\"")
;;       ;; (0+ (not (any ">")))
;;       (? (not (any "-")))
;;       ">"
;;       ;; FIX-ME: Commented out because of bug in Emacs
;;       ;;
;;       ;;(optional (0+ space) "<![CDATA[" )
;;       ))
;; ;; (defun mumamo-search-fw-exc-start-script (pos max)
;; ;;   "Helper for `mumamo-chunk-inlined-script'.
;; ;; POS is where to start search and MAX is where to stop."
;; ;;   (goto-char (1+ pos))
;; ;;   (skip-chars-backward "^<")
;; ;;   ;; Handle <![CDATA[
;; ;;   (when (and
;; ;;          (eq ?< (char-before))
;; ;;          (eq ?! (char-after))
;; ;;          (not (bobp)))
;; ;;     (backward-char)
;; ;;     (skip-chars-backward "^<"))
;; ;;   (unless (bobp)
;; ;;     (backward-char 1))
;; ;;   (let ((exc-start (search-forward "<script" max t))
;; ;;         exc-mode)
;; ;;     (when exc-start
;; ;;       (goto-char (- exc-start 7))
;; ;;       (when (looking-at mumamo-script-smarty-tag-start-regex)
;; ;;         (goto-char (match-end 0))
;; ;;         (list (point) 'javascript-mode '(nxml-mode))
;; ;;         ))))
;; ;; (defun mumamo-chunk-script (pos max)
;; ;;   (mumamo-possible-chunk-forward pos max
;; ;;                            'mumamo-search-fw-exc-start-script
;; ;;                            'mumamo-search-fw-exc-end-inlined-script))

;; ;; util/mumamo-func.el
;; (define-mumamo-multi-major-mode smarty-html-mumamo-mode
;;   "Turn on multiple major modes for Smarty with main mode `html-mode'.
;; This also covers inlined style and javascript."
;;  ("Smarty HTML Family" html-helper-mode
;;    (;; mumamo-chunk-xml-pi
;;     mumamo-chunk-style=
;;     mumamo-chunk-onjs=
;;     mumamo-chunk-hrefjs=
;;     mumamo-chunk-inlined-style
;;     mumamo-chunk-inlined-script
;;     mumamo-chunk-smarty-literal
;;     mumamo-chunk-smarty-t
;;     mumamo-chunk-smarty-comment
;;     mumamo-chunk-smarty
;;     ;; mumamo-chunk-script
;;     )))

;; (font-lock-add-keywords nil '(
;;                            ("<!--" 0 'font-lock-comment-face t)
;;                            ("-->" 0 'font-lock-comment-face t)
;;                            ))

;; (font-lock-fontify-buffer)
;;        (setf nxhtml-setup-file-assoc (lambda()))
;;        (setq auto-mode-alist (append '(("\\.php[3-5]?$" . php-mode)) auto-mode-alist))
;;        (defun nxhtml-mode-toggle ()
;;               (interactive)
;;               (if (string-match "smarty" mode-name)
;;                 (progn
;;                   ;; (nxhtml-mumamo-mode)
;;                   (html-mumamo-mode)
;;                   (setq my/nxhtml-mode-flg nil))
;;                 (smarty-html-mumamo-mode)
;;                 (setq my/nxhtml-mode-flg t)
;;                 )
;;               (message mode-name)
;;               )
;;        (define-keys nxhtml-menu-mode-map ((kbd "<f12>") 'mumamo-no-chunk-coloring)
;;       ((kbd "<C-f12>") 'nxhtml-mode-toggle)
;;       )))
;;   (custom-set-faces
;;    '(mumamo-background-chunk-major
;;      ((((class color) (min-colors 88) (background dark)) (; :background "SteelBlue4"
;;                                                                    ))))
;;    '(mumamo-background-chunk-submode1
;;      ((((class color) (min-colors 88) (background dark)) (:background "DarkOliveGreen"))))
;;    ))

;; (add-hook 'html-mode (lambda ()
;; (defvar html-imenu-generic-expression
;;   '(
;;     ("TITLE" "<title>\\(.*\\)</title>" 1)
;;     ("DIV" "<div\\s-class=\"\\(.*\\)\"[^>]*>" 1)
;;     )
;;   "Imenu generic expression for HTML Mode.  See `imenu-generic-expression'."
;;   )
;; (imenu-add-to-menubar "Index")
;;                     (setq imenu-generic-expression
;;                           html-imenu-generic-expression)
;;                     ))
;; (defun my-html-mode-setup-imenu ()
;;   (setq imenu-generic-expression
;;         '(
;;        ("TITLE" "<title>\\(.*\\)</title>" 1)
;;        ("DIV" "<div\\s-class=\"\\(.*\\)\"[^>]*>" 1)
;;      ))
;;   (setq imenu-case-fold-search nil)
;;   (setq imenu-auto-rescan t)
;;   (setq imenu-space-replacement " ")
;;   (imenu-add-menubar-index)
;;   )
;; (add-hook 'html-mode-hook 'my-html-mode-setup-imenu)
