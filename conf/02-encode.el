; 言語を日本語にする
(set-language-environment 'Japanese)

; 極力UTF-8とする
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)

(cond ((string= window-system "x")
       (prefer-coding-system 'utf-8-unix)
       (setq default-file-name-coding-system 'utf-8)
       )
      ((string= window-system "w32")
       (prefer-coding-system 'utf-8)
       (setq default-file-name-coding-system 'japanese-shift-jis-dos)
       ))

;(setq default-buffer-file-coding-system ' utf-8)

(when (boundp 'show-trailing-whitespace)
  (setq-default show-trailing-whitespace t))
(setq menu-tree-coding-system 'utf-8)
