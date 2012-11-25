;;; YaTeX
;; yatex-mode の起動
(setq auto-mode-alist
      (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
(lazyload (yatex-mode) "yatex"
;; (when (autoload-if-found 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
;;   (eval-after-load "yatex"
    (setq YaTeX-kanji-code 4
	  tex-command "platex  -interaction=nonstopmode"
	  dviprint-command-format "dvipdfmx %s"
	  dvi2-command "SumatraPDF.exe -reuse-instance"
	  )
    ;; dvi2-commandで自動的に拡張子を補完してくれるようにする設定
    (setq YaTeX-dvi2-command-ext-alist
	  '(("xdvi\\|dvipdfmx|emacsclient" . ".dvi")
	    ("ghostview\\|gv" . ".ps")
	    ("acroread\\|pdf\\|Preview\\|TeXShop" . ".pdf")))
    ;; auto-complete-mode for latex
    (req auto-complete-latex
	 (setq ac-l-dict-directory (user:emacs-cache-path "ac-l-dict"))
	 (setq ac-modes (append ac-modes '(yatex-mode)))
	 (define-key YaTeX-mode-map (kbd "C-c f") 'fill-region)
	 (ac-l-setup)
	 )
    )
    ;; ))
(add-hook 'yatex-mode-hook 'yatex-mode-hook-func)


  ;; \documentclass[a4paper]{jarticle}
  ;; \usepackage[dvipdfmx]{graphicx}

  ;; %--余白の設定
  ;; \setlength{\topmargin}{20mm}
  ;; \addtolength{\topmargin}{-1in}
  ;; \setlength{\oddsidemargin}{20mm}
  ;; \addtolength{\oddsidemargin}{-1in}
  ;; \setlength{\evensidemargin}{15mm}
  ;; \addtolength{\evensidemargin}{-1in}
  ;; \setlength{\textwidth}{170mm}
  ;; \setlength{\textheight}{254mm}
  ;; \setlength{\headsep}{0mm}
  ;; \setlength{\headheight}{0mm}
  ;; \setlength{\topskip}{0mm}
