(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist (cons '("\\.cs$" . csharp-mode) auto-mode-alist))

;; Patterns for finding Microsoft C# compiler error messages:
(require 'compile)
(push '("^\\(.*\\)(\\([0-9]+\\),\\([0-9]+\\)): error" 1 2 3 2) compilation-error-regexp-alist)
(push '("^\\(.*\\)(\\([0-9]+\\),\\([0-9]+\\)): warning" 1 2 3 1) compilation-error-regexp-alist)

;; Cモード共通フック
(add-hook 'csharp-mode-hook
          '(lambda()
             (setq comment-column 40)
             (setq c-basic-offset 4)
             (font-lock-add-magic-number)
             ;; オフセットの調整
             (c-set-offset 'substatement-open 0)
             (c-set-offset 'case-label '+)
             (c-set-offset 'arglist-intro '+)
             (c-set-offset 'arglist-close 0)
             )
          )

;; Patterns for defining blocks to hide/show:
(push '(csharp-mode
        "\\(^\\s *#\\s *region\\b\\)\\|{"
        "\\(^\\s *#\\s *endregion\\b\\)\\|}"
        "/[*/]"
        nil
        hs-c-like-adjust-block-beginning)
      hs-special-modes-alist)