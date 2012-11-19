;; マクロ定義
(defmacro req (lib &rest body)
  `(when (locate-library ,(symbol-name lib))
     (require ',lib) ,@body))

;; マクロ定義
(defmacro lazyload (func lib &rest body)
  `(when (locate-library ,lib)
     ,@(mapcar (lambda (f) `(autoload ',f ,lib nil t)) func)
     (eval-after-load ,lib
       '(progn
          ,@body))))

(defmacro define-keys (mode-map &rest body)
  "特定のキーマップをまとめて設定する"
  `(progn
     ,@(mapcar #'(lambda (arg)
                   `(define-key ,mode-map ,@arg)) body)))

;;global-set-keyの複数版
(defmacro global-set-keys (&rest body)
  "`global-set-key`をまとめて設定する。詳細については`define-keys`を参照。"
  `(define-keys global-map ,@body))

(defun autoload-if-found (functions file &optional docstring interactive type)
  "set autoload iff. FILE has found."
  (if (not (listp functions))
      (setq functions (list functions)))
  (and (locate-library file)
       (progn
         (dolist (function functions)
           (autoload function file docstring interactive type))
         t )))

(defmacro my/idle-time-load (interval &rest body)
  `(add-hook 'after-init-hook (lambda ()
				(run-with-idle-timer ,interval nil
						     (lambda () ,@body)))))

(defun user:emacs-path (path)
  (concat user-emacs-directory path)
  )

(defun user:emacs-cache-path (path)
  (concat user-emacs-directory "cache/" path)
  )

;;; initsフォルダのみ、保存時に自動コンパイルして即反映させる
(defun auto-save-byte-compile-file ()
  "Do `byte-compile-file' and reload setting immediately, When elisp file saved only in inits folder."
  (interactive)
  (message buffer-file-name)
  (if (equal (expand-file-name (user:emacs-path "conf/")) (file-name-directory buffer-file-name))
      (progn
	(byte-compile-file buffer-file-name t)
	(message (concat "byte-compile " buffer-file-name))
	)))

(add-hook 'emacs-lisp-mode-hook
  (lambda ()
    (add-hook 'after-save-hook 'auto-save-byte-compile-file nil t)))

(req deferred)
;; (req idle-require)
;; (idle-require-mode 1)
