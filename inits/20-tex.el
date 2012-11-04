;;; YaTeX
;; yatex-mode の起動
(setq auto-mode-alist
      (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(setq YaTeX-kanji-code 4
      tex-command "platex  -interaction=nonstopmode"
      dviprint-command-format "dvipdfmx %s"
      ;; dvi2-command "\"C:\\program files\\Adobe\\Reader 10.0\\Reader\\Acrord32.exe\""
      dvi2-command "SumatraPDF.exe -reuse-instance"
)
;; auto-complete-mode for latex
(require 'auto-complete-latex)
(setq ac-l-dict-directory "~/.emacs.d/cache/ac-l-dict/")
(defun yatex-mode-hook-func ()
  (interactive)
  (local-set-key "\C-cf" 'fill-region)
  (when (require 'auto-complete-latex nil t)
    (ac-l-setup)
    (auto-complete-mode t)))
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

; dvi2-commandで自動的に拡張子を補完してくれるようにする設定
(setq YaTeX-dvi2-command-ext-alist
  '(("xdvi\\|dvipdfmx|emacsclient" . ".dvi")
    ("ghostview\\|gv" . ".ps")
    ("acroread\\|pdf\\|Preview\\|TeXShop" . ".pdf")))
