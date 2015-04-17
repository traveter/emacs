(use-package package
  :config
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
  ;; (package-initialize)
  :commands
  (package-list-packages)
  )

;; (req package
;;  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
;;  (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;;  (package-initialize))
