;(require 'cedet)
;(require 'ecb)
(eval-when-compile (require 'cl))

(req powerline
     (powerline-default-theme)
     (set-face-background 'powerline-active1 "SteelBlue")
     (set-face-background 'powerline-inactive1 "SteelBlue3")
     )

(my/init-load
 (req auto-complete-config
      (eval-after-load 'auto-complete-config
	'(progn
	   ;; (ac-define-source to-mailaddr
	   ;;   '((candidates . (list "foo1@example.com"
	   ;; 			   "foo2@example.com"
	   ;; 			   "foo3@example.com"))
	   ;;     (prefix . "^To: \\(.*\\)")))
	   ;; (global-set-key (kbd "C--") 'ac-complete-to-mailaddr)
	   (add-to-list 'ac-dictionary-directories (user:emacs-path "dict"))
	   ;; (global-auto-complete-mode t)
	   (ac-config-default)
	   (ac-set-trigger-key "TAB")
	   (define-key ac-mode-map [tab] 'ac-trigger-key-command)
	   (setq ac-auto-start nil
	   	 ac-dwim t
	   	 ac-quick-help-delay 0.5
	   	 ac-use-menu-map t
	   	 ac-sources (append ac-sources '(ac-source-dictionary))
	   	 ac-modes (append ac-modes
	   	 		  (list 'smarty-mode 'html-helper-mode 'html-mode
	   	 			'eshell-mode 'web-mode 'less-css-mode))
	   	 ;; ac-comphist-file (user:emacs-cache-path "ac-comphist.dat")
	   	 )

	   )))
 (req yasnippet
      (setq yas-trigger-key "S-SPC")
      (setq yas-snippet-dirs '(
			       "~/.emacs.d/snippets"
			       "~/.emacs.d/elisp/yasnippet-0.8.0/snippets"
			       ))
      (eval-after-load "yasnippet"
	'(progn
	   (require 'dropdown-list)
	   (setq yas-prompt-functions '(yas-dropdown-prompt
					yas-ido-prompt
					yas-completing-prompt))
	   (yas-global-mode 1)
	   ;;(add-to-list 'ac-sources 'ac-source-yasnippet)
	   (setq-default ac-sources '(ac-source-yasnippet
				      ac-source-abbrev
				      ac-source-dictionary
				      ac-source-words-in-buffer
				      ac-source-words-in-same-mode-buffers
				      ))
	   (define-keys yas-minor-mode-map
	     ((kbd "C-x i i") 'yas-insert-snippet)
	     ((kbd "C-x i n") 'yas-new-snippet)
	     ((kbd "C-x i v") 'yas-visit-snippet-file)
	     )
	   ));;)
      )
 (req tabbar
      (defun tabbar-buffer-groups ()
	"Return the list of group names the current buffer belongs to.
     Return a list of one element based on major mode."
	(list
	 (cond
	  ((string-equal "*eshell*" (buffer-name))
	   "shell"
	   )
	  ;; ((string-equal "*" (substring (buffer-name) 0 1))
	  ;;  "Common" )
	  ((eq major-mode 'dired-mode)
	   "Dired"
	   )
	  ((memq major-mode
		 '(help-mode apropos-mode Info-mode Man-mode))
	   "Common"
	   )
	  (t
	   ;; Return `mode-name' if not blank, `major-mode' otherwise.
	   (if (and (stringp mode-name)
		    ;; Take care of preserving the match-data because this
		    ;; function is called when updating the header line.
		    (save-match-data (string-match "[^ ]" mode-name)))
	       mode-name
	     (symbol-name major-mode))
	   ))))
      ;; (setq tabbar-buffer-groups-function
      ;; 	   (lambda () (list "All Buffers")))
      (setq tabbar-buffer-list-function
	    (lambda ()
	      (remove-if
	       (lambda(buffer)
		 (unless (string= (buffer-name buffer) "*eshell*")
		   (or (find (aref (buffer-name buffer) 0) " *")
		       (string-match "\\[.*\\]" (buffer-name buffer))
		       )
		   ))
	       (buffer-list))))
      (tabbar-mode)

      ;; 外観変更
      (set-face-attribute 'tabbar-default nil
			  :background "gray60")
      (set-face-attribute 'tabbar-unselected nil
			  :background "white" :foreground "gray60"
			  :box '(:line-width 1 :color "white" :style released-button))
      (set-face-attribute 'tabbar-selected nil
			  :background "cyan" :foreground "gray60"
			  :box '(:line-width 1 :color "white" :style pressed-button))
      (set-face-attribute 'tabbar-button nil
			  :box '(:line-width 1 :color "gray72" :style released-button))
      (set-face-attribute 'tabbar-separator nil :height 0.7)

      (global-set-keys ((kbd "M-4") 'tabbar-mode) ;; M-4 で タブ表示、非表示
		       ((kbd "M-]") 'tabbar-forward-tab)
		       ((kbd "M-[") 'tabbar-backward-tab)
		       ((kbd "C-M-]") 'tabbar-forward-group)
		       ((kbd "C-M-[") 'tabbar-backward-group)
		       )
      )

 )

;; 0.7
;; (setq yas/trigger-key "S-SPC")
;; (autoload 'yas/dropdown-prompt "dropdown-list" nil t)
;; (when (autoload-if-found 'yas/minor-mode "yasnippet" nil t)
;;   (setq yas/snippet-dirs "~/.emacs.d/snippets")
;;   (eval-after-load "yasnippet"
;;     '(progn
;;        (require 'dropdown-list)
;;        (setq yas/prompt-functions '(yas/dropdown-prompt
;; 				    yas/ido-prompt
;; 				    yas/completing-prompt))
;;        (yas/load-directory yas/snippet-dirs)
;;        (yas/initialize)
;;        )))

;; (load "uniq")

;; (when (autoload-if-found 'recentf-ext "recentf-ext" nil t)
;;   (define-key mode-specific-map "l" 'recentf-open-files))
;; (req qwerty
;; (when (autoload-if-found 'dvorak "qwerty" nil t)
;;   (eval-after-load 'dvorak
;;     '(progn
;;        (defun dvorak ()
;; 	 "Dvorak keyboard layout:
;; -------------------------------------------------------------------------
;; | Esc| 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 0  | *  | ^  | \  |
;; -------------------------------------------------------------------------
;; | Tab | '  | ,  | .  | p  | y  | f  | g  | c  | r  | l  | =  | [  |     |
;; -------------------------------------------------------------------|    |
;; | Ctrl | a  | o  | e  | u  | i  | d  | h  | t  | n  | s  | -  | ]  | <- |
;; -------------------------------------------------------------------------
;; | Shift  | ;  | q  | j  | k  | x  | b  | m  | w  | v  | z  | / | Shift |
;; ---------------------------------------------------------------------

;; "
;; 	 (interactive)
;; 	 (anti-qwerty "',.pyfgcrl=(aoeuidhtns;)-qjkxbmwvz\"<>PYFGCRL+{AOEUIDHTNS$}:QJKXBMWVZ?*_@[]/"
;; 	 	      "qwertyuiop@[asdfghjkl;:]zxcvbnm,./QWERTYUIOP`{ASDFGHJKL+*}ZXCVBNM<>?_-=$()'"))
;; 	 )))
(req dvorak-mode
     (global-set-keys ((kbd "C-^") 'dvorak-mode)))

(req nav
     (global-set-key (kbd "C-x c") 'nav-toggle)
     )
;; (when (autoload-if-found 'nav-toggle "nav" "Emacs nav" t)
;;   (defvar nav-width 30)
;;   (defvar ec-root-path "z:/")
;;   (defvar ec-template-path (concat ec-root-path "Download/"))
;;   (defvar ec-class-path (concat ec-root-path "cache/"))
;;   (defvar ec-class-ex-path (concat ec-root-path "TEMP/"))
;;   (defvar ec-html-path (concat ec-root-path "GomezPEER/"))

;;   ;; (setq ec-root-path "/var/www/html/eccube/")
;;   ;; (setq ec-template-path (concat ec-root-path "data/Smarty/templates/"))
;;   ;; (setq ec-class-path (concat ec-root-path "data/class/"))
;;   ;; (setq ec-class-ex-path (concat ec-root-path "data/class_extends/"))
;;   ;; (setq ec-html-path (concat ec-root-path "html/"))

;;   ;; you can select the key you prefer to
;;   (define-key global-map (kbd "C-x n")
;;     '(lambda () (interactive) (nav-toggle) (nav-cd ec-root-path)))
;;   (eval-after-load "nav"
;;     '(progn
;;        (define-keys nav-mode-map
;; 	 ("1" '(lambda () (interactive) (nav-cd ec-root-path)))
;; 	 ("2" '(lambda () (interactive) (nav-cd ec-template-path)))
;; 	 ("3" '(lambda () (interactive) (nav-cd ec-class-path)))
;; 	 ("4" '(lambda () (interactive) (nav-cd ec-class-ex-path)))
;; 	 ("5" '(lambda () (interactive) (nav-cd ec-html-path)))
;;        )))
;;   )
(require 'ec-mode)
(global-set-key (kbd "C-x n") 'ec-mode)
;; (when (autoload-if-found 'ec-toggle "ec-mode" nil t)
;;   (define-key global-map (kbd "C-x n") 'ec-toggle))

(when (autoload-if-found 'ace-jump-mode "ace-jump-mode" "Emacs quick move minor mode" t)
  ;; you can select the key you prefer to
  (define-key global-map (kbd "C-;") 'ace-jump-mode))
;; (req key-combo
;;      (key-combo-load-default)
;;      (key-combo-define-hook 'php-mode-hook
;; 			    'key-combo-pointer-load-default
;; 			    key-combo-pointer-default)
;;      ;; (key-combo-define-global (kbd "C-F") '("$"))
;;      ;; (key-combo-define-global (kbd "C-T") '("$this->"))
;;      )
(when (autoload-if-found 'helm-mini "helm-config" nil t)
  (global-set-key (kbd "C-c h") 'helm-mini)
  (eval-after-load "helm-config"
    '(progn
       (global-set-keys ((kbd "C-c C-f") 'helm-find-files)
			((kbd "C-c l") 'helm-recentf)
			((kbd "C-c o") 'helm-occur)
			((kbd "M-y") 'helm-show-kill-ring)
			))))

(my/idle-time-load 6 (req generic-x))

(my/idle-time-load 5
		   ;; tramp
		   (req tramp
			(when (require 'tramp nil t)
			  (cond ((eq system-type 'windows-nt)
				 (setq tramp-default-method "plink"))
				(t     (setq tramp-default-method "scp"))))
			;; (setq tramp-default-method "ssh")
			;; (setq tramp-default-method "plink")
			;; (setq tramp-shell-prompt-pattern "^[$#] ")
			;; trampで開いたファイルはバックアップファイルを作成しない
			(add-to-list 'backup-directory-alist (cons tramp-file-name-regexp nil))
			))

;; (when (autoload-if-found 'browse-kill-ring "browse-kill-ring" nil t)
;;   (global-set-key [(M y)] 'browse-kill-ring))
(when (autoload-if-found 'e2wm:start-management "e2wm" nil t)
  (global-set-key (kbd "M-+") 'e2wm:start-management))

;; (setq idle-require-symbols '(lambda() ))
;; (req lcomp
;;      (lcomp-install)
;;      )

;; (req which-func
;;      ;; java-mode と javascript-mode でも which-func を使う
;;      (setq which-func-modes (append which-func-modes '(java-mode javascript-mode php-mode)))
;;      (which-func-mode t)
;;      )

;; (defconst cedet-version "1.0.9")

;; (defun load-cedet ()
;;   "load-cedet."
;;   (interactive)
;;   ;; (load "cedet-1.1/common/cedet")
;;   ;; (req ecb)
;;        (global-ede-mode 1)
;;        (setq ac-sources (append ac-sources '(ac-source-semantic)))
;;        ;; Configuration variables here:
;;        (setq semantic-load-turn-useful-things-on t)
;;        (setq semantic-load-turn-everything-on t)

;;        ;; ロード前設定が必要な変数, defcustom系変数
;;        (setq semantic-default-submodes
;; 	     '(
;; 	       ;; Semanticデータベース
;; 	       global-semanticdb-minor-mode
;; 	       ;; アイドルタイムにsemantic-add-system-includeで追加されたパスグループを再解析
;; 	       global-semantic-idle-scheduler-mode
;; 	       ;; タグのサマリを表示
;; 	       global-semantic-idle-summary-mode
;; 	       ;; タグの補完を表示(plugin auto-completeでac-source-semanticを使うのでdisable)
;; 					;global-semantic-idle-completions-mode
;; 	       ;; タグを装飾
;; 	       global-semantic-decoration-mode
;; 	       ;; 現在カーソルでポイントされているfunctionの宣言をハイライト
;; 	       global-semantic-highlight-func-mode
;; 	       ;; ?
;; 	       global-semantic-mru-bookmark-mode
;; 	       ;; ?
;; 	       global-semantic-stickyfunc-mode
;; 	       )
;; 	     semanticdb-default-save-directory (expand-file-name "~/.emacs.d/cache/semantic")
;; 	     )
;;        ;; アイドルタイムにsemantic-add-system-includeで追加されたパスグループをパースする
;;        (setq semantic-idle-work-update-headers-flag t)
;;        (add-hook 'php-mode-user-hook 'semantic-default-java-setup)
;;        (setq imenu-create-index-function 'semantic-create-imenu-index)
;;   )

;; (add-hook 'php-mode-hook 'load-cedet)
;; (add-hook 'java-mode-hook 'load-cedet)
;; (add-hook 'c-mode-hook 'load-cedet)
;; (add-hook 'c++-mode-hook 'load-cedet)
