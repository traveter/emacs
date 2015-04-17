;; html-helper-mode + font color
;; (when (autoload-if-found 'html-helper-mode "html-helper-mode" "Yay HTML" t)
;;   (eval-after-load 'html-helper-mode
;;     '(progn
;;        (setq html-helper-verbose nil)
;;        )))

(my/init-load
 (use-package emmet-mode
   :init
   (add-hook 'html-helper-mode-hook 'emmet-mode)
   (add-hook 'css-mode-hook 'emmet-mode)
   (add-hook 'web-mode-hook 'emmet-mode)
   :config
  (bind-keys :map emmet-mode-keymap
   ("C-j" . nil))
   ;; (define-key emmet-mode-keymap (kbd "C-j") 'nil)
   (use-package helm-emmet
     :config
     (eval-after-load 'css-mode
       '(progn
          (define-key css-mode-map (kbd "C-i h") 'helm-emmet)))
     (eval-after-load 'web-mode
       '(progn
          (define-key web-mode-map (kbd "C-i h") 'helm-emmet))))
   ))

;; css-mode の設定
(use-package css-mode
 :mode "\\.css\\'"
  :config
  (use-package helm-css-scss
    :config
   (bind-keys :map css-mode-map
    ("C-i C-i" . helm-css-scss)
    ("C-i C-b" . helm-css-scss-back-to-last-point)
    ("C-i C-c" . helm-css-scss-insert-close-comment)
    ("C-i C-n" . helm-css-scss-move-and-echo-next-selector)
    ("C-i C-p" . helm-css-scss-move-and-echo-previous-selector)))

  ;;タブ幅を4に
  (setq cssm-indent-level 4)
  ;;インデントをc-styleにする
  (setq cssm-indent-function #'cssm-c-style-indenter)
  )

(use-package whitespace
  :config
  ;; (set-face-foreground 'whitespace-space "LightSlateGrey")
  ;; (set-face-background 'whitespace-space "DarkSlateGrey")
  ;; (set-face-foreground 'whitespace-tab "LightSlateGrey")
  ;; (set-face-background 'whitespace-tab "DarkSlateGrey")
  ;; (setq whitespace-style '(tabs tab-mark spaces space-mark))
  ;; (setq whitespace-space-regexp "\\(\x3000+\\)")
  ;; (setq whitespace-display-mappings
  ;;            '((space-mark ?\x3000 [?\□])
  ;;              (tab-mark   ?\t   [?\xBB ?\t])
  ;;              ))
  ;; (global-whitespace-mode 1)
  (setq whitespace-style '(face           ; faceで可視化
						   trailing       ; 行末
						   tabs           ; タブ
						   spaces         ; スペース
						   empty          ; 先頭/末尾の空行
						   space-mark     ; 表示のマッピング
						   tab-mark
						   ))

  (setq whitespace-display-mappings
		'((space-mark ?\u3000 [?\u25a1])
		  ;; WARNING: the mapping below has a problem.
		  ;; When a TAB occupies exactly one column, it will display the
		  ;; character ?\xBB at that column followed by a TAB which goes to
		  ;; the next TAB column.
		  ;; If this is a problem for you, please, comment the line below.
		  (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))

  ;; スペースは全角のみを可視化
  (setq whitespace-space-regexp "\\(\u3000+\\)")
  ;; 保存前に自動でクリーンアップ
  ;; (setq whitespace-action '(auto-cleanup))
  (global-whitespace-mode 1)

  (set-face-attribute 'whitespace-trailing nil
					  :background "DarkSlateGrey"
					  :foreground "DeepPink"
					  :underline t)
  (set-face-attribute 'whitespace-tab nil
					  :background "DarkSlateGrey"
					  :foreground "LightSkyBlue"
					  :underline t)
  (set-face-attribute 'whitespace-space nil
					  :background "DarkSlateGrey"
					  :foreground "GreenYellow"
					  :weight 'bold)
  (set-face-attribute 'whitespace-empty nil
					  :background "DarkSlateGrey")
  )

;; (req whitespace
;;      ;; (set-face-foreground 'whitespace-space "LightSlateGrey")
;;      ;; (set-face-background 'whitespace-space "DarkSlateGrey")
;;      ;; (set-face-foreground 'whitespace-tab "LightSlateGrey")
;;      ;; (set-face-background 'whitespace-tab "DarkSlateGrey")
;;      ;; (setq whitespace-style '(tabs tab-mark spaces space-mark))
;;      ;; (setq whitespace-space-regexp "\\(\x3000+\\)")
;;      ;; (setq whitespace-display-mappings
;;      ;;            '((space-mark ?\x3000 [?\□])
;;      ;;              (tab-mark   ?\t   [?\xBB ?\t])
;;      ;;              ))
;;      ;; (global-whitespace-mode 1)
;;      (setq whitespace-style '(face           ; faceで可視化
;;                               trailing       ; 行末
;;                               tabs           ; タブ
;;                               spaces         ; スペース
;;                               empty          ; 先頭/末尾の空行
;;                               space-mark     ; 表示のマッピング
;;                               tab-mark
;;                               ))

;;      (setq whitespace-display-mappings
;;            '((space-mark ?\u3000 [?\u25a1])
;;              ;; WARNING: the mapping below has a problem.
;;              ;; When a TAB occupies exactly one column, it will display the
;;              ;; character ?\xBB at that column followed by a TAB which goes to
;;              ;; the next TAB column.
;;              ;; If this is a problem for you, please, comment the line below.
;;              (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))

;;      ;; スペースは全角のみを可視化
;;      (setq whitespace-space-regexp "\\(\u3000+\\)")
;;      ;; 保存前に自動でクリーンアップ
;;      ;; (setq whitespace-action '(auto-cleanup))
;;      (global-whitespace-mode 1)

;;      (set-face-attribute 'whitespace-trailing nil
;;                          :background "DarkSlateGrey"
;;                          :foreground "DeepPink"
;;                          :underline t)
;;      (set-face-attribute 'whitespace-tab nil
;;                          :background "DarkSlateGrey"
;;                          :foreground "LightSkyBlue"
;;                          :underline t)
;;      (set-face-attribute 'whitespace-space nil
;;                          :background "DarkSlateGrey"
;;                          :foreground "GreenYellow"
;;                          :weight 'bold)
;;      (set-face-attribute 'whitespace-empty nil
;;                          :background "DarkSlateGrey")
;;      )

(use-package js2-mode
 :mode "\\.js\\'"
 :init
 (defun my:js2-init-hook ()
  (setq indent-tabs-mode t
   c-basic-offset 8
   tab-width 4))
 (add-hook 'js2-init-hook 'my:js2-init-hook)
 :config
 (req js2-imenu-extras)
 (js2-imenu-extras-setup)
 (set (make-local-variable 'indent-line-function) 'js-indent-line)
 ;; (use-package tern
 ;;   :config
 ;;   (use-package tern-auto-complete
 ;; 	 :config
 ;; 	 (tern-ac-setup))
 ;;   (defun my:tern-init-hook ()
 ;; 	 (tern-mode t))
 ;;   (add-hook 'js2-mode-hook 'my:tern-init-hook)
 ;;   )
)

(use-package json-mode
  :mode "\\.json\\'"
  )

;; (when (autoload-if-found 'haskell-mode "haskell-mode-autoloads" nil t)
;;   (eval-after-load 'haskell-mode
;;     '(progn
;;        (req ghc
;;             (add-hook 'haskell-mode-hook (lambda () (ghc-init) (flymake-mode)))
;;             )))
;;   (add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
;;   )
;; ;; less-css-mode の設定
;; (when (autoload-if-found 'less-css-mode "less-css-mode" nil t)
;;   (eval-after-load 'less-css-mode
;;     '(progn
;;        (if (string= (window-system) "w32")
;;         (progn
;;           (setq less-css-lessc-command "dotless.Compiler.exe")
;;           (defun less-css-compile ()
;;             "Compiles the current buffer to css using `less-css-lessc-command'."
;;             (interactive)
;;             (message "Compiling less to css")
;;             (compile
;;              (mapconcat 'identity
;;                         (append (list (shell-quote-argument less-css-lessc-command))
;;                                 less-css-lessc-options
;;                                 (list (shell-quote-argument buffer-file-name)
;;                                       " "
;;                                       (shell-quote-argument (less-css--output-path))))
;;                         " ")))
;;           )))))

(eval-after-load 'ox-latex
  '(progn
     (setq org-latex-to-pdf-process '("platex %b" "platex %b" "dvipdfmx %b"))
     ;; (setq org-latex-default-class "jarticle")
     (add-to-list 'org-latex-classes
                  '(("jarticle"
                     "\\documentclass{jarticle}"
                     ("\\section{%s}" . "\\section*{%s}")
                     ("\\subsection{%s}" . "\\subsection*{%s}")
                     ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                     ("\\paragraph{%s}" . "\\paragraph*{%s}")
                     ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
                    ))
     ))

(eval-after-load 'org
  '(progn
     (req ac-org)
     (add-to-list 'ac-modes 'org-mode)
     (setq hoge ac-sources)
     ;;   (ac-define-source org-tag
     ;;          '((candidates . org-options-keywords)
     ;;            (symbol . "Org Option Keyword")))
       ;; (add-to-list 'ac-sources ac-source-org-tag))
     (require 'ob-ditaa)
     (setq org-ditaa-jar-path "~/.emacs.d/bin/ditaa0_9.jar")
     (setq org-ditaa-eps-jar-path "~/.emacs.d/bin/DitaaEps.jar")
     (eval-after-load 'ox-latex
       '(progn
          (message "hoge")
          (add-to-list 'org-latex-classes
                       '("jarticle"
                         "\\documentclass[11pt]{jarticle}"
                         ("\\section{%s}" . "\\section*{%s}")
                         ("\\subsection{%s}" . "\\subsection*{%s}")
                         ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                         ("\\paragraph{%s}" . "\\paragraph*{%s}")
                         ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
          (add-to-list 'org-latex-classes
                       '("jreport"
                        "\\documentclass[11pt]{jreport}"
                        ("\\chapter{%s}" . "\\chapter*{%s}")
                        ("\\section{%s}" . "\\section*{%s}")
                        ("\\subsection{%s}" . "\\subsection*{%s}")
                        ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                        ("\\paragraph{%s}" . "\\paragraph*{%s}")
                        ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
          ))

     (setq org-latex-default-packages-alist
           '(("AUTO" "inputenc"  t)
             ("T1"   "fontenc"   t)
             (""     "fixltx2e"  nil)
             ("dvipdfm" "graphicx,color"  t)
             (""     "mediabb"   nil)
             (""     "longtable" nil)
             (""     "float"     nil)
             (""     "wrapfig"   nil)
             (""     "soul"      t)
             (""     "textcomp"  t)
             (""     "marvosym"  t)
             (""     "amssymb"  t)
             ;; (""     "wasysym"   t)
             ;; (""     "latexsym"  t)
             ;; (""     "amssymb"   t)
             ("dvipdfm,bookmarks=true,bookmarksnumbered=true,bookmarkstype=toc,linkbordercolor={1 1 1},citebordercolor={1 1 1},urlbordercolor={1 1 1}" "hyperref" nil)
             "\\tolerance=1000"
             "\\AtBeginDvi{\\special{pdf:tounicode 90ms-RKSJ-UCS2}}"
             ))
     ))
;; (setq org-export-latex-hyperref-options-format "")

(use-package vbnet-mode
 :mode "\\.vb\\'"
 :config
 (add-to-list 'ac-modes 'vbnet-mode)
)

;; (setq auto-mode-alist
;;       (append '(
;;                 ;; ("\\.\\(html\\|tpl\\|php[3-5]?\\)$"  .       web-mode)
;;                 ;; ("\\.html\\'"                .       nxhtml-mumamo-mode)
;;                 ;; ("\\.html\\'"                .       html-mode)
;;                 ;; ("\\.js\\'"             .       js2-mode)
;;                 ;; ("\\.\\(js\\|json\\)$"  .       js2-mode)
;;                 ;; ("\\.css$"              .       css-mode)
;;                 ;; ("\\.less$"             .       less-css-mode)
;;                 ("\\.vbs$"              .       vbnet-mode)
;;                 ) auto-mode-alist))
