(req use-package)

(my/init-load
 (use-package hl-line+
   :init (setq hl-line-idle-interval 1)
   :config (toggle-hl-line-when-idle))
 (use-package auto-highlight-symbol
   :config (global-auto-highlight-symbol-mode))
 (use-package highlight-symbol
   :config
   (bind-keys* ([f7] . highlight-symbol-at-point)
               ([(meta up)] . highlight-symbol-prev)
               ([(meta down)] . highlight-symbol-next))
   )

 (use-package expand-region
   :bind
   (([(control @)] . er/expand-region)
	([(control meta @)] . er/contract-region)))

 (use-package auto-complete-config
   :config
   (add-to-list 'ac-dictionary-directories (user:emacs-path "dict"))
   (ac-config-default)
   ;; (ac-set-trigger-key "TAB")
   (ac-set-trigger-key "<tab>")
   (setq ac-auto-start nil
         ac-dwim t
         ac-ignore-case 'smart
         ac-quick-help-delay 0.5
         ac-use-menu-map t
         ac-sources (append ac-sources '(ac-source-dictionary))
         ;; ac-modes (append ac-modes (list 'eshell-mode 'web-mode 'smarty-mode 'html-helper-mode
         ;; 'html-mode 'less-css-mode 'yatex-mode))
         ac-modes (append ac-modes (list 'eshell-mode 'smarty-mode 'html-helper-mode
                                         'html-mode 'less-css-mode 'ini-generic-mode))
         ac-comphist-file (user:emacs-cache-path "ac-comphist.dat")
         )

   (use-package yasnippet
     :bind (([(shift space)] . yas-expand))
     :config
     (use-package dropdown-list
       :config
       (setq yas-prompt-functions '(yas-dropdown-prompt
                                    yas-ido-prompt
                                    yas-completing-prompt))
       )
     (yas-global-mode 1)
     (yas-minor-mode 1)
     (setq-default ac-sources '(ac-source-yasnippet
                                ac-source-dictionary
                                ac-source-words-in-buffer
                                ac-source-words-in-same-mode-buffers))
     ;; (global-set-key (kbd "TAB") 'ac-trigger-key-command)
     (bind-keys :map yas-minor-mode-map
                ("TAB" . nil)
                ("S-SPC" . yas-expand)
                ("C-x i i" . yas-insert-snippet)
                ("C-x i n" . yas-new-snippet)
                ("C-x i v" . yas-visit-snippet-file)))
     ;; (define-keys yas-minor-mode-map
     ;;   ((kbd "S-SPC") 'yas-expand)
     ;;   ;; ([tab] nil)
     ;;   ((kbd "TAB") nil)
     ;;   ;; ((kbd "C-x i i") 'yas-insert-snippet)
     ;;   ;; ((kbd "C-x i n") 'yas-new-snippet)
     ;;   ;; ((kbd "C-x i v") 'yas-visit-snippet-file)
     ;;   ))
   )

;; 自動保存
 (use-package recentf-ext
   :config
   (custom-set-variables '(recentf-save-file (user:emacs-cache-path "recentf")))
   (setq recentf-max-saved-items 2000)
   (setq recentf-exclude '(".recentf"))
   (setq recentf-auto-cleanup 10)
   (setq recentf-auto-save-timer (run-with-idle-timer 30 t 'recentf-save-list))
   (recentf-mode 1)
   (defvar my-recentf-list-prev nil)
   (defadvice recentf-save-list
       (around no-message activate)
     "If `recentf-list' and previous recentf-list are equal,
do nothing. And suppress the output from `message' and
`write-file' to minibuffer."
     (unless (equal recentf-list my-recentf-list-prev)
       (flet ((message (format-string &rest args)
                       (eval `(format ,format-string ,@args)))
              (write-file (file &optional confirm)
                          (let ((str (buffer-string)))
                            (with-temp-file file
                              (insert str)))))
         ad-do-it
         (setq my-recentf-list-prev recentf-list))))
   )

 ;; (use-package powerline
 ;;   :config
 ;;   ;; (powerline-default-theme)
 ;;   (set-face-background 'powerline-active1 "SteelBlue")
 ;;   (set-face-background 'powerline-inactive1 "SteelBlue3")

 ;;   (setq-default mode-line-format
 ;;                 '("%e"
 ;;                   (:eval
 ;;                    (let* ((active (powerline-selected-window-active))
 ;;                           (mode-line (if active 'mode-line 'mode-line-inactive))
 ;;                           (face1 (if active 'powerline-active1
 ;;                                    'powerline-inactive1))
 ;;                           (face2 (if active 'powerline-active2
 ;;                                    'powerline-inactive2))
 ;;                           (separator-left
 ;;                            (intern (format "powerline-%s-%s"
 ;;                                            powerline-default-separator
 ;;                                            (car powerline-default-separator-dir))))
 ;;                           (separator-right
 ;;                            (intern (format "powerline-%s-%s"
 ;;                                            powerline-default-separator
 ;;                                            (cdr powerline-default-separator-dir))))
 ;;                           (lhs (list
 ;;                                 (powerline-raw "%*" face2 'l)
 ;;                                 (powerline-buffer-size face2 'l)

 ;;                                 (powerline-raw mode-line-mule-info face2 'l)
 ;;                                 (funcall separator-left face2 mode-line)
 ;;                                 (powerline-buffer-id nil 'l)

 ;;                                 (when (and (boundp 'which-func-mode) which-func-mode)
 ;;                                   (powerline-raw which-func-format nil 'l))

 ;;                                 ;; (powerline-raw " ")
 ;;                                 (funcall separator-left mode-line face1)

 ;;                                 (when (boundp 'erc-modified-channels-object)
 ;;                                   (powerline-raw erc-modified-channels-object
 ;;                                                  face1 'l))

 ;;                                 (powerline-major-mode face1 'l)
 ;;                                 (powerline-process face1)
 ;;                                 (powerline-minor-modes face1 'l)
 ;;                                 (powerline-narrow face1 'l)

 ;;                                 (funcall separator-left face1 face2)

 ;;                                 (powerline-vc face2 'r)))
 ;;                           (rhs (list

 ;;                                 (funcall separator-right face2 face1)

 ;;                                 (powerline-raw "%3l" face1 'l)
 ;;                                 (powerline-raw ":" face1 'l)
 ;;                                 (powerline-raw "%3c" face1 'r)

 ;;                                 ;; (powerline-raw " " face1)

 ;;                                 (powerline-raw "%3p" face1 'r)
 ;;                                 (powerline-raw (format "%d" (count-lines (point-max) (point-min))) face1 'r)
 ;;                                 ;; (powerline-raw "%6p" face1 'r)

 ;;                                 ;; (funcall separator-right face1 mode-line)
 ;;                                 (funcall separator-right face1 nil)

 ;;                                 (powerline-raw " ")
 ;;                                 ;; (powerline-raw global-mode-string mode-line 'r)
 ;;                                 (powerline-raw global-mode-string nil 'r)
 ;;                                 ;; (powerline-hud face2 face1))))
 ;;                                 )))
 ;;                      (concat
 ;;                       (powerline-render lhs)
 ;;                       (powerline-fill face2 (powerline-width rhs))
 ;;                       (powerline-render rhs))))))
 ;;   )

 (use-package tabbar
   :config
   (defun my:tabbar-buffer-groups ()
     (list (cond
            ((memq major-mode '(eshell-mode shell-mode)) "shell")
            ;; ((string-equal "*eshell*" (buffer-name)) "shell")
            ;; ((string-equal "*" (substring (buffer-name) 0 1)) "Common")
            ((eq major-mode 'dired-mode) "Dired")
            ((memq major-mode '(help-mode apropos-mode Info-mode Man-mode)) "Common")
            (t
             (if (and (stringp mode-name)
                      (save-match-data (string-match "[^ ]" mode-name)))
                 mode-name
               (symbol-name major-mode))
             ))))
   (setq tabbar-buffer-groups-function 'my:tabbar-buffer-groups)
   ;; (setq tabbar-buffer-groups-function
   ;;           (lambda () (list "All Buffers")))
   (defun my:tabbar-buffer-list ()
     (delq nil (mapcar #'(lambda (b)
                           (let ((n (buffer-name b)))
                             (cond ((string= "*eshell*" n) b)
                                   ((not (string-match "\*[^\*]+\*" n)) b)
                                   ;; ((not (and (string= (substring (buffer-name) 0 1) "*")
                                   ;;                 (string= (substring (buffer-name) (1- (length (buffer-name)))) "*"))) b)
                                   ;; ((not (or (integerp (find (aref n 0) " *"))
                                   ;;                (string-match "\\[.*\\]" n))) b)
                                   )))
                       (tabbar-buffer-list))))
   (setq tabbar-buffer-list-function 'my:tabbar-buffer-list)

   ;; 外観変更
   (set-face-attribute 'tabbar-default nil :background "gray60")
   (set-face-attribute 'tabbar-unselected nil :background "white" :foreground "gray60"
                       :box '(:line-width 1 :color "white" :style released-button))
   (set-face-attribute 'tabbar-selected nil :background "cyan" :foreground "gray60"
                       :box '(:line-width 1 :color "white" :style pressed-button))
   (set-face-attribute 'tabbar-button nil :box '(:line-width 1 :color "gray72" :style released-button))
   (set-face-attribute 'tabbar-separator nil :height 0.7)
   (bind-keys :map tabbar-mode-map
              ;; ((kbd "M-4") 'tabbar-mode) ;; M-4 で タブ表示、非表示
              ;; ((kbd "M-]") 'tabbar-forward-tab)
              ;; ((kbd "M-[") 'tabbar-backward-tab)
              ;; ((kbd "C-M-]") 'tabbar-forward-group)
              ;; ((kbd "C-M-[") 'tabbar-backward-group)

              ([(M \])] . tabbar-forward-tab)
              ([(M \[)] . tabbar-backward-tab)
              ([(control meta \])] . tabbar-forward-group)
              ([(control meta \[)] . tabbar-backward-group)
              )
   (bind-key* "M-4" 'tabbar-mode)
      (tabbar-mode)
      )
 )


(use-package ag
  :config
  (setq ag-highlight-search t
        ag-reuse-buffers t)
  )

(use-package ace-jump-mode
  :bind (("C-;" . ace-jump-mode))
  )

(use-package migemo
  :config
  (setq migemo-command "cmigemo")
  (setq migemo-options '("-q" "--emacs" "-i" "\g"))
  ;; migemo-dict のパスを指定
  (setq migemo-dictionary (expand-file-name "~/.emacs.d/bin/cmigemo-default-win64/dict/utf-8/migemo-dict"))
  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  ;; 辞書の文字コードを指定．
  (setq migemo-coding-system 'utf-8-unix)
  (migemo-init))

(use-package helm-config
  :init
  (defun helm-window-configuration-change-hook ()
    (let ((fw (frame-width))
          (we-b (eq (nth 0 (window-edges)) 0)))
      (if (> fw 150)
          ;; (if (eq fw (window-width))
          ;;     (setq helm-split-window-default-side (if we-b 'right 'left))
          ;;   (setq helm-split-window-default-side (if we-b 'left 'right)))
          (setq helm-split-window-default-side
                (if (eq fw (window-width)) (if we-b 'right 'left) (if we-b 'left 'right)))
        (setq helm-split-window-default-side 'below))))
  :bind (([(C c) (h)] . helm-mini)
         ([(C c) (C f)] . helm-find-files)
         ([(C c) (C l)] . helm-recentf)
         ([(C c) (C m)] . helm-M-x)
         ([(C c) (o)] . helm-occur)
         ([(M y)] . helm-show-kill-ring))
  :config
  (helm-window-configuration-change-hook)
  (use-package helm
    :config
    ))
(use-package helm-swoop
  :bind (([(M i)] . helm-swoop)
         ([(M I)] . helm-swoop-back-to-last-point)
         ([(C c) (M i)] . helm-multi-swoop)
         ([(C x) (M i)] . helm-multi-swoop-all))
  :config
  (defun helm-swoop-window-configuration-change-hook ()
    (let ((fw (frame-width))
          (we-b (eq (nth 0 (window-edges)) 0)))
      (setq helm-swoop-split-direction
            (if (> fw 150) 'split-window-horizontally 'split-window-vertically))))

  (helm-swoop-window-configuration-change-hook)
  (add-hook 'window-configuration-change-hook 'helm-swoop-window-configuration-change-hook)
  (add-hook 'window-configuration-change-hook 'helm-window-configuration-change-hook)
  ;; isearch実行中にhelm-swoopに移行
  (define-key isearch-mode-map [(M i)] 'helm-swoop-from-isearch)
  ;; helm-swoop実行中にhelm-multi-swoop-allに移行
  (define-key helm-swoop-map [(M i)] 'helm-multi-swoop-all-from-helm-swoop)
  ;; Save buffer when helm-multi-swoop-edit complete
  (setq helm-multi-swoop-edit-save t)
  ;; 値がtの場合はウィンドウ内に分割、nilなら別のウィンドウを使用
  (setq helm-swoop-split-with-multiple-windows nil)
  ;; nilなら一覧のテキストカラーを失う代わりに、起動スピードをほんの少し上げる
  (setq helm-swoop-speed-or-color t)
  )
