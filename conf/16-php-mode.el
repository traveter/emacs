;; (add-to-list 'auto-mode-alist '("\\.php[345s]?\\'" . php-mode))

(add-hook 'php-mode-hook
          '(lambda ()
             (c-set-offset 'case-label 4)
             ;; (req fill-column-indicator
             ;;           (local-set-key [f4] 'fci-mode)
             ;;           (fci-mode)
             ;;           )

             (imenu-add-to-menubar "Imenu")
             (flymake-mode)

             ;; (hs-minor-mode 1)
             ;; (hs-hide-level 2)
             ;; (add-to-list 'hs-special-modes-alist
             ;;                   '(php-mode "function" nil hs-c-like-adjust-block-beginning))
             ;; (define-key php-mode-map (kbd "C-x t") 'hs-toggle-hiding)
             ))

;;php-mode
(use-package php-mode
  :mode "\\.php[345s]?\\'"
  :config
  (defun web-mode-engine-angular ()
	(setq web-mode-engine "angular"))
  (setq imenu-auto-rescan t)
  ;; (req php-omni-completion)
  ;; (setq php-mode-force-pear t)
  (setq php-mode-coding-style 'wordpress)

  ;; (c-set-offset 'arglist-intro 4)
  ;; (c-set-offset 'arglist-cont-nonempty 4)
  ;; C-c RET: php-browse-manual
  (setq php-manual-url "http://www.php.net/manual/ja/")
  ;; C-c C-f: php-search-documentation
  ;; (setq php-search-url "http://jp2.php.net/")

  ;; M-TAB が有効にならないので以下の設定を追加
  (bind-keys :map php-mode-map
             ([C .] . nil)
             ([C-M-a] . php-beginning-of-defun)
             ([C-M-e] . php-end-of-defun)
             ([(M p)] . flymake-goto-prev-error)
             ([(M n)] . flymake-goto-next-error)
             ([(C c) (d)] . flymake-start-syntax-check)
             ([(C c) (a)] . php-adodb-search-web-documentation))
  (custom-set-variables '(php-executable "php")))
