;; (require 'linum)
;; (global-linum-mode t)
;; (setq linum-format "%4d")
;; (defun linum-toggle()
;;   (interactive)
;;   (linum-mode)
;;   )
;;(global-set-key [f7] 'linum-toggle)
(global-set-key [f7] 'linum-mode)

;(require 'cedet)
;(require 'ecb)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")
;(global-auto-complete-mode t)
(ac-config-default)
(ac-set-trigger-key "TAB")
(setq ac-auto-start nil
      ac-dwim t
      ac-use-menu-map t)

(setq yas/trigger-key "SPC")
(autoload 'yas/dropdown-prompt "dropdown-list" nil t)
(when (autoload-if-found 'yas/minor-mode "yasnippet" nil t)
  (setq yas/root-directory "~/.emacs.d/snippets")
  (eval-after-load "yasnippet"
    '(progn
       (require 'dropdown-list)
       (setq yas/prompt-functions '(yas/dropdown-prompt
				    yas/ido-prompt
				    yas/completing-prompt))
       (yas/load-directory yas/root-directory)
       (yas/initialize)
       )))

;; (require 'yasnippet)
;; (yas/load-directory "~/.emacs.d/snippets")
;; (yas/initialize)
;; (setq yas/trigger-key "SPC")
;; (require 'dropdown-list)
;; (setq yas/prompt-functions '(yas/dropdown-prompt
;; 			     yas/ido-prompt
;; 			     yas/completing-prompt))

;; (load "uniq")

;; (setq idle-require-symbols '(lambda() ))

(require 'lcomp)
(lcomp-install)

(when (autoload-if-found 'recentf-ext "recentf-ext" nil t)
  (define-key mode-specific-map "l" 'recentf-open-files))
(when (autoload-if-found 'browse-kill-ring "browse-kill-ring" nil t)
  (global-set-key [(M y)] 'browse-kill-ring))

;; Configuration variables here:
(setq semantic-load-turn-useful-things-on t)
(setq semantic-load-turn-everything-on t)

;; ロード前設定が必要な変数, defcustom系変数
(setq semantic-default-submodes
      '(
        ;; Semanticデータベース
        global-semanticdb-minor-mode
        ;; アイドルタイムにsemantic-add-system-includeで追加されたパスグループを再解析
        global-semantic-idle-scheduler-mode
        ;; タグのサマリを表示
        global-semantic-idle-summary-mode
        ;; タグの補完を表示(plugin auto-completeでac-source-semanticを使うのでdisable)
					;global-semantic-idle-completions-mode
        ;; タグを装飾
        global-semantic-decoration-mode
        ;; 現在カーソルでポイントされているfunctionの宣言をハイライト
        global-semantic-highlight-func-mode
        ;; ?
        global-semantic-mru-bookmark-mode
        ;; ?
        global-semantic-stickyfunc-mode
        )
      )

;; アイドルタイムにsemantic-add-system-includeで追加されたパスグループをパースする
(setq semantic-idle-work-update-headers-flag t)
(defun load-cedet () "load cedet" (interactive) (require 'cedet))
(add-hook 'php-mode-hook 'load-cedet)
(add-hook 'java-mode-hook 'load-cedet)
(add-hook 'c-mode-hook 'load-cedet)
(add-hook 'c++-mode-hook 'load-cedet)
