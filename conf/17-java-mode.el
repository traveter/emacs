(add-hook 'java-mode-hook 'ajc-java-complete-mode)
(lazyload (ajc-java-complete-mode) "ajc-java-complete-config"
          (setq ajc-tag-file (user:emacs-cache-path ".java_base.tag"))
          )

;; (require 'cedet)
;; (semantic-load-enable-minimum-features) ;; or enable more if you wish
;; (require 'malabar-mode)
;; (setq malabar-groovy-lib-dir (user:emacs-path "/elisp/java/malabar-mode-master/malabar-1.5-SNAPSHOT/lib"))
;; (add-to-list 'auto-mode-alist '("\\.java\\'" . malabar-mode))
