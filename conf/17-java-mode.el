(lazyload (ajc-java-complete-mode) "ajc-java-complete-config"
	  (add-to-list 'ac-modes 'java-mode)
	  (setq ajc-tag-file (user:emacs-cache-path ".java_base.tag"))
	  )
(add-hook 'java-mode-hook 'ajc-java-complete-mode)
