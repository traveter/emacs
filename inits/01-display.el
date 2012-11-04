(setq initial-frame-alist
      (append
       '((width            . 110)
         (height           . 60)
         (top              . 40)
	 (left             . 8)
	 ;(alpha            . 98)
	 (font             . "Ricty")
	 (cursor-color     . "LightSkyBlue")
	 (background-color . "DimGrey")
	 (foreground-color . "white")
	 )
       initial-frame-alist))
(setq default-frame-alist initial-frame-alist)
;(set-default-font "-outline-Ricty-normal-normal-normal-*-16-*-*-*-c-*-iso8859-1")

(tool-bar-mode -1)
(mouse-wheel-mode t)
(display-time)
(which-function-mode 1)
(show-paren-mode t)
(delete-selection-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)
(add-hook 'before-save-hook 'delete-trailing-whitespace) ; 保存時に無駄なスペースを削除
(setq-default show-trailing-whitespace t)
(set-face-background ' trailing-whitespace "SkyBlue")

(setq make-backup-files nil
      visible-bell t
      inhibit-startup-message t
      frame-title-format "%b (%f)"
      icon-title-format "%b"
      column-number-mode t
      )
(defface hlline-face
  '((((class color)
      (background dark))
     (:background "dark slate gray"))
    (((class color)
      (background light))
     (:background "ForestGreen"))
    (t
     ()))
  "*Face used by hl-line.")
(setq hl-line-face 'hlline-face)
;; (setq hl-line-face 'underline) ; 下線
(global-hl-line-mode)

(scroll-bar-mode -1)
(global-set-key [f6] 'toggle-scroll-bar)

(menu-bar-mode -1)
(global-set-key [f8] 'menu-bar-mode)

;; (defun my-window-size-save ()
;;   (let* ((rlist (frame-parameters (selected-frame)))
;;          (ilist initial-frame-alist)
;;          (nCHeight (frame-height))
;;          (nCWidth (frame-width))
;;          (tMargin (if (integerp (cdr (assoc 'top rlist)))
;;                       (cdr (assoc 'top rlist)) 0))
;;          (lMargin (if (integerp (cdr (assoc 'left rlist)))
;;                       (cdr (assoc 'left rlist)) 0))
;;          buf
;;          (file "~/.framesize.el"))
;;     (if (get-file-buffer (expand-file-name file))
;;         (setq buf (get-file-buffer (expand-file-name file)))
;;       (setq buf (find-file-noselect file)))
;;     (set-buffer buf)
;;     (erase-buffer)
;;     (insert (concat
;;              ;; 初期値をいじるよりも modify-frame-parameters
;;              ;; で変えるだけの方がいい?
;;              "(delete 'width initial-frame-alist)\n"
;;              "(delete 'height initial-frame-alist)\n"
;;              "(delete 'top initial-frame-alist)\n"
;;              "(delete 'left initial-frame-alist)\n"
;;              "(setq initial-frame-alist (append (list\n"
;;              "'(width . " (int-to-string nCWidth) ")\n"
;;              "'(height . " (int-to-string nCHeight) ")\n"
;;              "'(top . " (int-to-string tMargin) ")\n"
;;              "'(left . " (int-to-string lMargin) "))\n"
;;              "initial-frame-alist))\n"
;;              ;;"(setq default-frame-alist initial-frame-alist)"
;;              ))
;;     (save-buffer)
;;     ))

;; (defun my-window-size-load ()
;;   (let* ((file "~/.emacs.d/.framesize.el"))
;;     (if (file-exists-p file)
;;         (load file))))

;; (my-window-size-load)

;; ;; Call the function above at C-x C-c.
;; (defadvice save-buffers-kill-emacs
;;   (before save-frame-size activate)
;;   (my-window-size-save))
