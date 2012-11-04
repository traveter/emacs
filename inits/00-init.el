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

(defmacro user-emacs-path (path)
  (concat user-emacs-directory path)
  )

(defmacro user-emacs-cache-path (path)
  (concat user-emacs-directory "cache/" path)
  )

(req deferred)
;; (req idle-require)
;; (idle-require-mode 1)
