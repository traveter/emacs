(global-set-keys
   ;;Commenting Regions
   ([(C c)(\;)] `comment-or-uncomment-region)
   ([(C h)] 'delete-backward-char)
   ;; M-h 1つ前の単語削除
   ([(M h)] 'backward-kill-word)
   ;; make Alt-r as replace-string
   ([(M r)] 'replace-string)
   ;; make Alt-g as goto-line
   ([(M g)] 'goto-line)
   ([(C-x)(e)] 'eval-current-buffer)
   ([(C c)(C u)] 'cua-mode)
   ([(C \,)] 'clipboard-kill-ring-save)
   ([(C .)] 'clipboard-yank)
   ((kbd "C-;") 'hs-toggle-hiding)
  )

(define-key mode-specific-map "c" 'compile)

(add-hook 'c-mode-common-hook '(lambda () (hs-minor-mode 1)))
(add-hook 'emacs-lisp-mode-hook '(lambda () (hs-minor-mode 1)))
(add-hook 'java-mode-hook '(lambda () (hs-minor-mode 1)))
(add-hook 'php-mode-hook '(lambda () (hs-minor-mode 1)))

(require 'cl)
(require 'tabbar)
(tabbar-mode)
(setq tabbar-buffer-groups-function
      (lambda ()
	(list "All Buffers")))
(setq tabbar-buffer-list-function
      (lambda ()
	    (remove-if
	     (lambda(buffer)
	       (unless (string= (buffer-name buffer) "*eshell*")
		 (find (aref (buffer-name buffer) 0) " *"))
	       )
	     (buffer-list))))

;; 外観変更
(set-face-attribute 'tabbar-default nil
		    :background "gray60")
(set-face-attribute 'tabbar-unselected nil
		    :background "gray60" :foreground "white"
		    :box '(:line-width 1 :color "white" :style released-button))
(set-face-attribute 'tabbar-selected nil
		    :background "gray60" :foreground "cyan"
		    :box '(:line-width 1 :color "white" :style pressed-button))
(set-face-attribute 'tabbar-button nil
		    :box '(:line-width 1 :color "gray72" :style released-button))
(set-face-attribute 'tabbar-separator nil :height 0.7)

(global-set-keys
 ((kbd "M-4") 'tabbar-mode) ;; M-4 で タブ表示、非表示
 ((kbd "M-]") 'tabbar-forward) ;;M-]で次のタブ、M-[で前のタブに移動
 ((kbd "M-[") 'tabbar-backward))

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
(global-set-keys ([(C c)(C u)] 'windmove-up)
		 ([(C c)(C d)] 'windmove-down)
		 ([(C c)(C r)] 'windmove-right)
		 ([(C c)(C l)] 'windmove-left)
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
(global-set-key [(C c)(C w)] 'window-resizer)

(setq speedbar-directory-unshown-regexp "^\\'")
(global-set-key [f9] 'sr-speedbar-toggle)
(when (autoload-if-found 'sr-speedbar-toggle "sr-speedbar" nil t)
  (eval-after-load "sr-speedbar"
    '(progn
       (speedbar-add-supported-extension '("js" "as" "html" "css" "php[0-9]?" "tpl"))
       )))

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