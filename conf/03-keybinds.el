(req use-package)

(setq-default indent-tabs-mode t)

(defun move-line (arg)
  (let ((col (current-column)))
    (save-excursion
	  (forward-line)
      (transpose-lines arg))
    ;; (when (> arg 0)
    ;;   (forward-line arg))
    (forward-line arg)
    (move-to-column col)))

(defun my:toggle-indent-tab ()
  (interactive)
  (make-local-variable 'indent-tabs-mode)
  (let ((str (if indent-tabs-mode "space" "tab")))
    (message (concat "indent-tabs-mode -> " str)))
  (setq indent-tabs-mode (not indent-tabs-mode)))

(bind-key* [(control h)] 'delete-backward-char)

(defun toggle-kill-ring-save (&optional arg)
  (interactive "P")
  (if arg
      (save-excursion
        (beginning-of-line)
        (let ((begin (point)))
          (end-of-line)
          (kill-ring-save begin (point))))
    (if (region-active-p)
        (kill-ring-save (region-beginning) (region-end))
      (kill-new (thing-at-point 'symbol)))))

;; (global-set-keys
(bind-keys :map global-map
		   ([(meta w)] . toggle-kill-ring-save)
           ([(control f9)] . (lambda () (interactive) (move-line 1)))
           ([(control f10)] . (lambda () (interactive) (move-line -1)))
           ([(shift f12)] . toggle-truncate-lines)
           ([f12] . my:toggle-indent-tab)
           ([(control f1)] . describe-function)
           ([(alt h)] . backward-kill-word)
           ;; ((kbd "M-r") 'replace-string)
           ;; ((kbd "M-g") 'goto-line)
           ([(C ?.)] . forward-word)
           ([(C ?,)] . backward-word)
           ([C-left] . shrink-window-horizontally)
           ([C-right] . enlarge-window-horizontally)
           ([C-up] . shrink-window)
           ([C-down] . enlarge-window)
           ([(C o)] . occur)
           ;; windmove
           ([(control :) (control u)] . windmove-up)
           ([(control :) (control d)] . windmove-down)
           ([(control :) (control r)] . windmove-right)
           ([(control :) (control l)] . windmove-left)
           ((kbd "<C-tab>") . (lambda () (interactive) (insert "\t")))
           ([f5] . linum-mode)
           )

;; (define-keys ctl-x-map
(bind-keys :map ctl-x-map
           ("e" . eval-current-buffer)
           ("l" . my:duplicate-line-and-comment)
           ([(C m)] . my:mark-current-line)
           ([(o)] . (lambda ()
                      (interactive)
                      (message (current-word))
                      ))
           ("4" . user:window-set)
           )

;; (define-keys mode-specific-map
(bind-keys :map mode-specific-map
           ("c" . compile)
           ("g" . goto-line)
           ("r" . replace-string)
           ("," . clipboard-kill-ring-save)
           ("." . clipboard-yank)
           (";" . comment-or-uncomment-region)
           ([(C u)] . cua-mode)
           )

(defun user:window-set()
  (interactive)
  (if (> (frame-width) 150)
      (split-window-horizontally 70)
    (split-window-horizontally (/ (frame-width) 3)))
  (other-window 1))

(defun my:mark-current-line ()
  (interactive)
  (beginning-of-line)
  (push-mark (point) t t)
  (end-of-line))

(defun my:duplicate-line-and-comment ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (let ((begin (point)))
      (end-of-line)
      (kill-ring-save begin (point))
      ))
  (beginning-of-line)
  (let ((begin (point)))
    (end-of-line)
    (comment-region begin (point))
    (end-of-line)
    (newline)
    (yank)
    ))

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

(defun window-resizer ()  "Control window size and position."  (interactive)
       (let ((window-obj (selected-window)) (current-width (window-width))
             (current-height (window-height))
             (dx (if (= (nth 0 (window-edges)) 0) 1 -1))
             (dy (if (= (nth 1 (window-edges)) 0) 1 -1)) c)
         (catch 'end-flag (while t
                            (message "size[%dx%d]" (window-width) (window-height))
                            (setq c (read-char))
                            (cond ((= c ?l) (enlarge-window-horizontally dx))
                                  ((= c ?h) (shrink-window-horizontally dx))
                                  ((= c ?j) (enlarge-window dy))
                                  ((= c ?k) (shrink-window dy))
                                  ;; otherwise              (t               (message "Quit")
                                  (throw 'end-flag t))))))

(bind-key [(C c) (C w)] 'window-resizer)
;; (global-set-key [(C c) (C w)] 'window-resizer)

(use-package sr-speedbar
  :init
  (setq sr-speedbar-width-x 25)
  (setq speedbar-directory-unshown-regexp "^\\'")
  (add-hook 'speedbar-mode-hook
            '(lambda ()
               (speedbar-add-supported-extension
                '("css" "html" "js" "php[0-9]?" "sql" "tpl"))))
  :bind (([f9] . sr-speedbar-toggle))
  :config
  (bind-keys :map speedbar-mode-map ("A" speedbar-toggle-show-all-files)))

;; (when (autoload-if-found 'sr-speedbar-toggle "sr-speedbar" nil t)
;;   (global-set-key [f9] 'sr-speedbar-toggle)
;;   (setq sr-speedbar-width-x 25)
;;   (setq speedbar-directory-unshown-regexp "^\\'")
;;   (add-hook 'speedbar-mode-hook
;;             '(lambda ()
;;                (speedbar-add-supported-extension '("js" "as" "html" "css" "php[0-9]?" "tpl"))))
;;   (eval-after-load 'sr-speedbar
;;     '(progn
;;        (define-key speedbar-mode-map [(A)] 'speedbar-toggle-show-all-files)
;;        )))

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
      (bind-key [mouse-3] 'bingalls-edit-menu)
      ;; (global-set-key [mouse-3] 'bingalls-edit-menu)
      ))
