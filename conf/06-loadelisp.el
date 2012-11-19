;(require 'cedet)
;(require 'ecb)

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories (user:emacs-path "dict"))
(setq ac-comphist-file (user:emacs-cache-path "ac-comphist.dat"))
;(global-auto-complete-mode t)
(ac-config-default)
(ac-set-trigger-key "TAB")
(setq ac-auto-start nil
      ac-dwim t
      ac-use-menu-map t
      ac-sources (append ac-sources '(ac-source-dictionary))
      )

;; (autoload 'yas-dropdown-prompt "dropdown-list" nil t)
;; (req yasnippet
;;      (setq yas-trigger-key "S-SPC")
;;      (setq yas-snippet-dirs '(
;; 			      "~/.emacs.d/snippets"
;; 			      "~/.emacs.d/elisp/yasnippet-0.8.0/snippets"
;; 			      )))
;; (eval-after-load "yasnippet"
;;   '(progn
;;      (require 'dropdown-list)
;;      (setq yas-prompt-functions '(yas-dropdown-prompt
;; 				  yas-ido-prompt
;; 				  yas-completing-prompt))
;;      (yas-global-mode 1)
;;      ;;(add-to-list 'ac-sources 'ac-source-yasnippet)
;;      (push 'ac-sources ac-source-yasnippet)
;;      (define-keys yas-minor-mode-map
;;        ((kbd "C-x i i") 'yas-insert-snippet)
;;        ((kbd "C-x i n") 'yas-new-snippet)
;;        ((kbd "C-x i v") 'yas-visit-snippet-file)
;;        )
;;      ));;)

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
(req generic-x)
(when (autoload-if-found 'helm-mini "helm-config")
     (global-set-keys ((kbd "C-c h") 'helm-mini)
		      ((kbd "C-c C-f") 'helm-find-files)
		      ((kbd "C-c l") 'helm-recentf)
		      ))

(my/idle-time-load 2
		   (autoload 'yas-dropdown-prompt "dropdown-list" nil t)
		   (req yasnippet
			(setq yas-trigger-key "S-SPC")
			(setq yas-snippet-dirs '(
						 "~/.emacs.d/snippets"
						 "~/.emacs.d/elisp/yasnippet-0.8.0/snippets"
						 )))
		   (eval-after-load "yasnippet"
		     '(progn
			(require 'dropdown-list)
			(setq yas-prompt-functions '(yas-dropdown-prompt
						     yas-ido-prompt
						     yas-completing-prompt))
			(yas-global-mode 1)
			;;(add-to-list 'ac-sources 'ac-source-yasnippet)
			(push 'ac-sources ac-source-yasnippet)
			(define-keys yas-minor-mode-map
			  ((kbd "C-x i i") 'yas-insert-snippet)
			  ((kbd "C-x i n") 'yas-new-snippet)
			  ((kbd "C-x i v") 'yas-visit-snippet-file)
			  )
			));;)
)
(my/idle-time-load 5
		   ;; tramp
		   (req tramp
			(setq tramp-default-method "ssh")
			;; trampで開いたファイルはバックアップファイルを作成しない
			(add-to-list 'backup-directory-alist (cons tramp-file-name-regexp nil))
			))


(when (autoload-if-found 'browse-kill-ring "browse-kill-ring" nil t)
  (global-set-key [(M y)] 'browse-kill-ring))
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

(defconst cedet-version "1.0.9")
;; (defun load-cedet ()
;;   "load-cedet."
;;   (interactive)
;;   (req cedet
;;        )
;;   (req ecb
;;        )
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

;; (defun load-cedet () "load cedet" (interactive) (require 'cedet) (global-ede-mode 1))
;; (add-hook 'php-mode-hook 'load-cedet)
;; (add-hook 'java-mode-hook 'load-cedet)
;; (add-hook 'c-mode-hook 'load-cedet)
;; (add-hook 'c++-mode-hook 'load-cedet)
