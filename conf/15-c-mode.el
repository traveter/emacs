(when (autoload-if-found 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
  ;; Patterns for defining blocks to hide/show:
  (eval-after-load "csharp-mode"
    '(progn
       (push '(csharp-mode
	       "\\(^\\s *#\\s *region\\b\\)\\|{"
	       "\\(^\\s *#\\s *endregion\\b\\)\\|}"
	       "/[*/]"
	       nil
	       hs-c-like-adjust-block-beginning)
	     hs-special-modes-alist)
       ;; Patterns for finding Microsoft C# compiler error messages:
       (req compile
	    (push '("^\\(.*\\)(\\([0-9]+\\),\\([0-9]+\\)): error" 1 2 3 2) compilation-error-regexp-alist)
	    (push '("^\\(.*\\)(\\([0-9]+\\),\\([0-9]+\\)): warning" 1 2 3 1) compilation-error-regexp-alist)
	    )
       )))
(setq auto-mode-alist (cons '("\\.cs$" . csharp-mode) auto-mode-alist))

;; Cモード共通フック
(add-hook 'c-mode-common-hook
          '(lambda()
             (setq comment-column 40)
             (setq c-basic-offset 4)
	     (c-toggle-hungry-state 1)
             ))
