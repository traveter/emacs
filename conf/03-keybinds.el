(global-set-keys ((kbd "C-c ;") `comment-or-uncomment-region)
		 ((kbd "C-h") 'delete-backward-char)
		 ((kbd "M-h") 'backward-kill-word)
		 ((kbd "M-r") 'replace-string)
		 ((kbd "M-g") 'goto-line)
		 ((kbd "C-x e") 'eval-current-buffer)
		 ((kbd "C-c C-u") 'cua-mode)
		 ((kbd "C-,") 'clipboard-kill-ring-save)
		 ((kbd "C-.") 'clipboard-yank)
		 ((kbd "C-;") 'hs-toggle-hiding)
		 )

(define-key mode-specific-map "c" 'compile)

(add-hook 'c-mode-common-hook '(lambda () (hs-minor-mode 1)))
(add-hook 'emacs-lisp-mode-hook '(lambda () (hs-minor-mode 1)))
(add-hook 'java-mode-hook '(lambda () (hs-minor-mode 1)))
(add-hook 'php-mode-hook '(lambda () (hs-minor-mode 1)))

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

(defun my-fullscreen ()
  (interactive)
  (let ((fullscreen (frame-parameter (selected-frame) 'fullscreen)))
    (cond
     ((null fullscreen)
      (set-frame-parameter (selected-frame) 'fullscreen 'fullboth))
     (t
      (set-frame-parameter (selected-frame) 'fullscreen 'nil))))
  (redisplay))
(global-set-key [f11] 'my-fullscreen)

					; windmove
(global-set-keys ((kbd "C-: C-u") 'windmove-up)
		 ((kbd "C-: C-d") 'windmove-down)
		 ((kbd "C-: C-r") 'windmove-right)
		 ((kbd "C-: C-l") 'windmove-left)
		 )

(defun window-resizer ()  "Control window size and position."  (interactive)
  (let ((window-obj (selected-window)) (current-width (window-width))
	(current-height (window-height))
	(dx (if (= (nth 0 (window-edges)) 0) 1 -1))
	(dy (if (= (nth 1 (window-edges)) 0) 1 -1)) c)
    (catch 'end-flag (while t (message "size[%dx%d]"
				       (window-width) (window-height)) (setq c (read-char))
				       (cond ((= c ?l) (enlarge-window-horizontally dx))
					     ((= c ?h) (shrink-window-horizontally dx))
					     ((= c ?j) (enlarge-window dy))
					     ((= c ?k) (shrink-window dy))
					     ;; otherwise              (t               (message "Quit")
					     (throw 'end-flag t))))))
(global-set-key (kbd "C-c C-w") 'window-resizer)

(when (autoload-if-found 'sr-speedbar-toggle "sr-speedbar" nil t)
  (global-set-key [f9] 'sr-speedbar-toggle)
  (setq sr-speedbar-width-x 25)
  (setq speedbar-directory-unshown-regexp "^\\'"))
(add-hook 'speedbar-mode-hook
	  '(lambda ()
	     (speedbar-add-supported-extension '("js" "as" "html" "css" "php[0-9]?" "tpl"))))

;;------------------------------------------------------
;; マウス設定
;;------------------------------------------------------
(if window-system
    (progn
      ;; 右ボタンの割り当て(押しながらの操作)をはずす。
      (global-unset-key [down-mouse-3])
      ;; マウスの右クリックメニューを出す(押して、離したときにだけメニューが出る)
      (defun bingalls-edit-menu (event)
	(interactive "e")
	(popup-menu menu-bar-edit-menu))
      (global-set-key [mouse-3] 'bingalls-edit-menu)
      ))
