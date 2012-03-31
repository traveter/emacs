;;Commenting Regions
(global-set-key [(C c)(\;)] `comment-or-uncomment-region)
(global-set-key (kbd "C-h") 'delete-backward-char)
(define-key mode-specific-map "c" 'compile)
;; M-h 1つ前の単語削除
(global-set-key "\M-h" 'backward-kill-word)
;; make Alt-r as replace-string
(global-set-key "\M-r" 'replace-string)
;; make Alt-g as goto-line
(global-set-key "\M-g" 'goto-line)

(global-set-key (kbd "\C-xe") 'eval-current-buffer)

;; 行のコピーを挿入
(defun duplicate-line-backward ()
  "Duplicate the current line backward."
  (interactive "*")
  (save-excursion
    (let ((contents
           (buffer-substring
            (line-beginning-position)
            (line-end-position))))
      (message contents)
;      (if (eq arg 1) (setq contents (concat "/* " contents " */")))
      (forward-line 1)
      (insert contents ?\n)
    )))

;; 範囲選択がactive  : 範囲内をコピー貼り付け
;; 範囲選択がinactive: カーソル行の先頭から範囲選択、カーソルは行末に移動
(defun region-select-to-line ()
  (interactive)
;  (if mark-active
;      (set-mark (line-end-position))
  (if mark-active
      (progn
	(kill-ring-save (region-beginning) (region-end))
	(insert ?\n)
	(yank)
      )
    (set-mark  (save-excursion
		 (line-end-position)
		 (line-beginning-position)
		 ))
    (end-of-line)
    ))

(global-set-key (kbd "M-n") '(lambda () (interactive)
			       (goto-line (+ (count-lines (point-min) (point)) (/ (frame-height) 3)))))
(global-set-key (kbd "M-p") '(lambda () (interactive)
			       (goto-line (- (count-lines (point-min) (point)) (/ (frame-height) 3)))))
(global-set-key (kbd "C-M-c") 'duplicate-line-backward)
;; (global-set-key (kbd "C-M-j") '(lambda () (interactive) (duplicate-line-backward)))
(global-set-key (kbd "C-M-j") 'region-select-to-line)

(require 'tabbar)
(tabbar-mode)
(setq tabbar-buffer-groups-function nil)
(dolist (btn '(tabbar-buffer-home-button
               tabbar-scroll-left-button
               tabbar-scroll-right-button))
  (set btn (cons (cons "" nil)
                 (cons "" nil))))
(setq tabbar-auto-scroll-flag nil)
;;M-]で次のタブ、M-[で前のタブに移動
(global-set-key "\M-]" 'tabbar-forward)
(global-set-key "\M-[" 'tabbar-backward)

;; 外観変更
(set-face-attribute 'tabbar-default nil
 :background "gray60")
(set-face-attribute 'tabbar-unselected nil
 :background "gray60" :foreground "white" :box '(:line-width 1 :color "white" :style released-button))
(set-face-attribute 'tabbar-selected nil
 :background "gray60" :foreground "cyan" :box '(:line-width 1 :color "white" :style pressed-button))
(set-face-attribute 'tabbar-button nil
 :box '(:line-width 1 :color "gray72" :style released-button))
(set-face-attribute 'tabbar-separator nil :height 0.7)

;; M-4 で タブ表示、非表示
(global-set-key "\M-4" 'tabbar-mode)

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

(global-set-key [(ctrl up)] '(lambda (arg) (interactive "p") (shrink-window arg)))
(global-set-key [(ctrl down)] '(lambda (arg) (interactive "p") (enlarge-window arg)))
(global-set-key [(ctrl left)] '(lambda (arg) (interactive "p") (shrink-window-horizontally arg)))
(global-set-key [(ctrl right)] '(lambda (arg) (interactive "p") (enlarge-window-horizontally arg)))

; windmove
(define-key global-map [(C tab)] (make-sparse-keymap))
(global-set-key [(C tab)(u)] 'windmove-up)
(global-set-key [(C tab)(d)] 'windmove-down)
(global-set-key [(C tab)(r)] 'windmove-right)
(global-set-key [(C tab)(l)] 'windmove-left)

(defun window-resizer ()  "Control window size and position."  (interactive)
  (let ((window-obj (selected-window))        (current-width (window-width))
        (current-height (window-height))
        (dx (if (= (nth 0 (window-edges)) 0) 1              -1))
        (dy (if (= (nth 1 (window-edges)) 0) 1              -1))        c)
    (catch 'end-flag
      (while t        (message "size[%dx%d]" (window-width) (window-height))
        (setq c (read-char))
        (cond ((= c ?l)               (enlarge-window-horizontally dx))
              ((= c ?h)               (shrink-window-horizontally dx))
              ((= c ?j)               (enlarge-window dy))
              ((= c ?k)               (shrink-window dy))
              ;; otherwise              (t               (message "Quit")
               (throw 'end-flag t))))))
(global-set-key [(C c)(C r)] 'window-resizer)

(setq speedbar-directory-unshown-regexp "^\\'")
(defun sr-speedbar-set ()
  "sr-speedbar initialize"
  (interactive)
  (if (not(featurep 'sr-speedbar))
      (require 'sr-speedbar)
    (global-unset-key [f9])
    (global-set-key [f9] 'sr-speedbar-toggle)
    )
  ;; (setq sr-speedbar-right-side nil)
  (sr-speedbar-toggle)
  )
(global-set-key [f9] 'sr-speedbar-set)
(add-hook 'speedbar-mode-hook
          '(lambda ()
             (speedbar-add-supported-extension '("js" "as" "html" "css" "php[0-9]?" "tpl"))))