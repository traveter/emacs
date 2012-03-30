;; Emacs起動時にEshellを起動
;(add-hook 'after-init-hook (lambda() (eshell) ))

(autoload 'multi-term "multi-term" "multi-term" t)
(setq term-default-fg-color "white"
      term-default-bg-color "DimGrey"
      ansi-term-color-vector
      ;; [unspecified "#000000" "#ff6565" "#93d44f" "#eab93d"
      ;; 	      "#204a87" "#ce5c00" "#89b6e2" "#ffffff"])
      ["DimGrey" "red1" "LightSkyBlue" "LightCyan" "magenta2" "SkyBlue" "cyan3" "white"])
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(global-set-key (kbd "C-c t") '(lambda ()
				 (interactive)
				 (multi-term)))
(add-hook 'term-mode-hook
	  '(lambda ()
	     ;; (setq term-unbind-key-list
	     ;; 	   (append
	     ;; 	    '("C-n" "C-p")
	     ;; 	    term-unbind-key-list))
	     (setq term-bind-key-alist
	     	   (append '(
	     		     ("C-h" . term-send-backspace)
	     		     ("C-y" . term-paste)
	     		     ) term-bind-key-alist))
	     ;; (define-key term-raw-map (kbd "C-y") 'term-paste)
	     ;; (define-key term-raw-map (kbd "ESC") 'term-send-raw)
	     ))
(global-set-key (kbd "C-c n") 'multi-term-next)
(global-set-key (kbd "C-c p") 'multi-term-prev)

(add-hook 'eshell-mode-hook
          '(lambda ()
             (progn
	       ;; 補完時に大文字小文字を区別しない
	       (setq eshell-cmpl-ignore-case t)
	       ;; 確認なしでヒストリ保存
	       (setq eshell-ask-to-save-history (quote always))
	       ;; 補完時にサイクルする
	       (setq eshell-cmpl-cycle-completions t)
	       ;;補完候補がこの数値以下だとサイクルせずに候補表示
	       (setq eshell-cmpl-cycle-cutoff-length 5)

	       (define-key eshell-mode-map "\C-a" 'eshell-bol)
               (define-key eshell-mode-map "\C-p" 'eshell-previous-matching-input-from-input)
               (define-key eshell-mode-map "\C-n" 'eshell-next-matching-input-from-input)
	       ; プロンプトの変更
	       (setq eshell-prompt-function
		     (lambda nil
		       (concat
					; (eshell/pwd)
			(if (= (user-uid) 0) " # " " $ ")))
		     )
	       )))

;; より下に記述した物が PATH の先頭に追加されます
(dolist (dir (list
              "/sbin"
              "/usr/sbin"
              "/bin"
              "/usr/bin"
              "/usr/local/bin"
              (expand-file-name "~/bin")
              (expand-file-name "~/.emacs.d/bin")
              ))
 ;; PATH と exec-path に同じ物を追加します
 (when (and (file-exists-p dir) (not (member dir exec-path)))
   (setenv "PATH" (concat dir ":" (getenv "PATH")))
   (setq exec-path (append (list dir) exec-path))))