;; (when (autoload-if-found 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
;;   (setq auto-mode-alist (cons '("\\.cs$" . csharp-mode) auto-mode-alist))
;;   ;; Patterns for defining blocks to hide/show:
;;   (eval-after-load "csharp-mode"
;;     '(progn
;;        (push '(csharp-mode
;;             "\\(^\\s *#\\s *region\\b\\)\\|{"
;;             "\\(^\\s *#\\s *endregion\\b\\)\\|}"
;;             "/[*/]"
;;             nil
;;             hs-c-like-adjust-block-beginning)
;;           hs-special-modes-alist)
;;        ;; Patterns for finding Microsoft C# compiler error messages:
;;        (req compile
;;          (push '("^\\(.*\\)(\\([0-9]+\\),\\([0-9]+\\)): error" 1 2 3 2) compilation-error-regexp-alist)
;;          (push '("^\\(.*\\)(\\([0-9]+\\),\\([0-9]+\\)): warning" 1 2 3 1) compilation-error-regexp-alist)
;;          )
;;        )))

(use-package flymake
  :mode "\\.\\(php\\|js\\)\\'"
  :init
  (setq flymake-run-in-place nil
        ;; flymake-timer 0
        flymake-number-of-errors-to-display 4
        )
  :config
  ;; Show error message under current line
  (require 'popup)
  (defun flymake-display-err-menu-for-current-line ()
    (interactive)
    (let* ((line-no (flymake-current-line-no))
           (line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no))))
      (when line-err-info-list
        (let* ((count (length line-err-info-list))
               (menu-item-text nil))
          (while (> count 0)
            (setq menu-item-text (flymake-ler-text (nth (1- count) line-err-info-list)))
            (let* ((file (flymake-ler-file (nth (1- count) line-err-info-list)))
                   (line (flymake-ler-line (nth (1- count) line-err-info-list))))
              (if file
                  (setq menu-item-text (concat menu-item-text " - " file "(" (format "%d" line) ")"))))
            (setq count (1- count))
            (if (> count 0) (setq menu-item-text (concat menu-item-text "\n")))
            )
          (popup-tip menu-item-text)))))

  ;; If you don't set :height, :bold face parameter of 'pop-tip-face,
  ;; then seting those default values
  (if (eq 'unspecified (face-attribute 'popup-tip-face :height))
      (set-face-attribute 'popup-tip-face nil :height 1.0))
  (if (eq 'unspecified (face-attribute 'popup-tip-face :weight))
      (set-face-attribute 'popup-tip-face nil :weight 'normal))

  (defun my/display-error-message ()
    (interactive)
    (let ((orig-face (face-attr-construct 'popup-tip-face)))
      (set-face-attribute 'popup-tip-face nil
                          :height 1.5 :foreground "firebrick"
                          :background "LightGoldenrod1" :bold t)
      (unwind-protect
          (flymake-display-err-menu-for-current-line)
        (while orig-face
          (set-face-attribute 'popup-tip-face nil (car orig-face) (cadr orig-face))
          (setq orig-face (cddr orig-face))))))
  (defadvice flymake-goto-prev-error (after flymake-goto-prev-error-display-message)
    (my/display-error-message))
  (defadvice flymake-goto-next-error (after flymake-goto-next-error-display-message)
    (my/display-error-message))

  (ad-activate 'flymake-goto-prev-error 'flymake-goto-prev-error-display-message)
  (ad-activate 'flymake-goto-next-error 'flymake-goto-next-error-display-message)
  (set-face-background 'flymake-errline "red")
  (set-face-background 'flymake-warnline "blue")
  )

;; Cモード共通フック
(add-hook 'c-mode-common-hook
          '(lambda()
             (setq comment-column 40)
             (setq c-basic-offset 4)
             (c-toggle-hungry-state 1)
             ))
