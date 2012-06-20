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

(require 'idle-require)
;; (idle-require-mode 1)