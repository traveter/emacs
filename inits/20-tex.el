;;; YaTeX
;; yatex-mode の起動
(setq auto-mode-alist
      (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)

(setq YaTeX-kanji-code 4
      tex-command "platex  -interaction=nonstopmode"
      dviprint-command-format "dvipdfmx %s"
      dvi2-command "\"C:\\program files (x86)\\Adobe\\Reader 10.0\\Reader\\Acrord32.exe\""
)

; dvi2-commandで自動的に拡張子を補完してくれるようにする設定
(setq YaTeX-dvi2-command-ext-alist
  '(("xdvi\\|dvipdfmx" . ".dvi")
    ("ghostview\\|gv" . ".ps")
    ("acroread\\|pdf\\|Preview\\|TeXShop" . ".pdf")))