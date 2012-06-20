;; Emacs起動時にEshellを起動
;(add-hook 'after-init-hook (lambda() (eshell) ))

(autoload 'multi-term "multi-term" "multi-term" t)
(setq term-default-fg-color "white"
      term-default-bg-color "DimGrey"
      ansi-term-color-vector
      ["DimGrey" "red1" "LightSkyBlue" "LightCyan" "magenta2" "SkyBlue" "cyan3" "white"])
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(global-set-key (kbd "C-c t") '(lambda () (interactive) (multi-term)))
;; (add-hook 'term-mode-hook
;; 	  '(lambda ()
;; 	     (add-to-list 'term-unbind-key-list '"C-o")
;; 	     (define-key term-raw-map (kbd "C-o") 'anything-complete-shell-history)
;; 	     (setq term-bind-key-alist
;; 		   (append '(
;; 			     [(C h)] . term-send-backspace)
;; 			     [(C y)] . term-paste)
;; 			     ) term-bind-key-alist))
;; 	     ))
(global-set-key [(C cn)] 'multi-term-next)
(global-set-key [(C cp)] 'multi-term-prev)

(defun nm-eshell-pcomplete ()
  (interactive)
  (let ((ac-sources '(ac-source-pcomplete
		      ac-source-filename)))
    (auto-complete)))

(defun nm-eshell-auto-complete ()
  (interactive)
  (let ((ac-sources '(ac-source-functions
		      ac-source-variables
		      ac-source-features
		      ac-source-symbols
		      ac-source-words-in-same-mode-buffers)))
    (auto-complete)))

(defun eshell/clear ()
 "Clear the current buffer, leaving one prompt at the top."
 (interactive)
 (let ((inhibit-read-only t))
   (erase-buffer)))

(defun my-ac-eshell-mode ()
  (setq ac-sources
        '(ac-source-pcomplete
          ac-source-words-in-buffer
          ac-source-dictionary)))

(global-set-key (kbd "C-c e") '(lambda () (interactive) (eshell)))
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
	       (setq eshell-hist-ignoredups t)
	       (require 'pcomplete)
	       (add-to-list 'ac-modes 'eshell-mode)
	       (ac-define-source pcomplete
		 '((candidates . pcomplete-completions)))
	       (my-ac-eshell-mode)

	       (define-keys eshell-mode-map
		 ((kbd "TAB") 'nm-eshell-pcomplete)
		 ([(C i)] 'nm-eshell-auto-complete)
		 ([(C o)] 'anything-complete-shell-history)
		 ([(C a)] 'eshell-bol)
		 ([(C p)] 'eshell-previous-matching-input-from-input)
		 ([(C n)] 'eshell-next-matching-input-from-input))
	       ; プロンプトの変更
	       (setq eshell-prompt-function
		     (lambda nil
		       (concat
					; (eshell/pwd)
			(if (= (user-uid) 0) " # " " $ ")))
		     )
	       )))
(eval-after-load "em-alias"
  '(progn

     ))

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

;; anythingは使わない
;; (when (require 'shell-history nil t)
;;   (when (require 'anything-complete nil t)
;;     ;; Automatically collect symbols by 150 secs
;;     (anything-lisp-complete-symbol-set-timer 150)
;;     (define-key emacs-lisp-mode-map "\C-\M-i" 'anything-lisp-complete-symbol-partial-match)
;;     (define-key lisp-interaction-mode-map "\C-\M-i" 'anything-lisp-complete-symbol-partial-match)
;;     ;; replace completion commands with `anything'
;;     (anything-read-string-mode 1)
;;     ;; Bind C-o to complete shell history
;;     (anything-complete-shell-history-setup-key "\C-o")
;;     (add-hook 'shell-mode-hook
;; 	      (lambda ()
;; 		(define-key shell-mode-map (kbd "C-o") 'anything-complete-shell-history)))
;;     (use-anything-show-completion 'anything-complete-shell-history
;; 				  '(length anything-c-source-complete-shell-history))))

;; zshの履歴検索予定
;; (defun popup-zsh_history ()
;;   "popup zsh_history"
;;   (interactive "*")
;;   (let ((aa 'nil)
;; 	(history 'nil)
;; 	(begin "\\(\\$ \\)")
;; 	(end "\\([^ ]+\$\\)")
;; 	(command-get-zsh_history "cat ~/.zsh_history | grep '")
;; 	(path (buffer-substring
;; 	       (line-beginning-position)
;; 	       (line-end-position)
;; 	       ))
;; 	(menu (make))
;; 	)
;;     (setq path (replace-regexp-in-string begin "" path))
;;     (setq path (replace-regexp-in-string end "" path))
;;     (setq path (replace-regexp-in-string "  +" "" path))
;;     (setq result (shell-command-to-string
;; 		  (concat command-get-zsh_history path "'")))
;;     (setq history (split-string result "\n"))
;;     (popup-menu* history)
;;     (dolist (elem history)
;;       (cond ((not (string-match (concat "" path) elem)))
;; 	    (t  (add-to-list 'aa elem))
;; 	    ))
;; ;    (popup-menu* aa)
;;     ))
;(global-set-key (kbd "C-M-p") 'popup-zsh_history)
