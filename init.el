;Add-to-load-path
(let ((default-directory (expand-file-name "~/.emacs.d/elpa")))
  (add-to-list 'load-path default-directory)
  (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
      (normal-top-level-add-subdirs-to-load-path)))

;; (defun add-to-load-path (&rest paths)
;;   (mapc '(lambda (path)
;;            (add-to-list 'load-path path))
;;         (mapcar 'expand-file-name paths)))

;; (add-to-load-path "~/.emacs.d/elisp"
;;  		  "~/.emacs.d/elisp/auto-complete")
;;                "~/.emacs.d/elisp/color-theme"
;;                "~/.emacs.d/conf")

(require 'init-loader)
(init-loader-load "~/.emacs.d/inits") ; 設定ファイルがあるディレクトリを指定
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(mumamo-background-chunk-major ((((class color) (min-colors 88) (background dark)) (:background "SteelBlue4"))))
 '(mumamo-background-chunk-submode1 ((((class color) (min-colors 88) (background dark)) (:background "SpringGreen4")))))
