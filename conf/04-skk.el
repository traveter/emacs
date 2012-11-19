(setq skk-user-directory (user:emacs-cache-path "ddskk/")) ; ディレクトリ指定
(setq skk-large-jisyo (user:emacs-path "dic/SKK-JISYO.L"))
(setq skk-kakutei-jisyo (user:emacs-path "dic/SKK-JISYO.edict"))
;; (require 'skk-autoloads)
;; C-x C-j で skk モードを起動
(define-key global-map (kbd "C-x C-j") 'skk-mode)
(lazyload (skk-mode) "skk-autoloads"
  ;; .skk を自動的にバイトコンパイル
  (setq skk-byte-compile-init-file t)
  ;;(global-set-key "\C-x\C-j" 'skk-mode)
  (global-set-key (kbd "C-x j") 'skk-auto-fill-mode)
  (global-set-key (kbd "C-c b") 'skk-undo-kakuteiy)
  (global-set-key (kbd "C-x t") 'skk-tutorial)

  ;; skk用のstickeyキー設定
  (setq skk-sticky-key ";")
  ;; 変換候補をインラインで表示
  (setq skk-show-inline 'vertical)
  ;; 各種メッセージを日本語で通知する
  (setq skk-japanese-message-and-error t)
  ;; ▼モードで Enter キーを押したとき
  ;;   nil => 確定と改行（デフォルト）
  ;;   non-nil => 確定するのみ。改行しない。
  (setq skk-egg-like-newline t)
  ;; 対応する閉括弧を自動的に挿入する
  (setq skk-auto-insert-paren t)
  ;; 句読点ではなくカンマやピリオドを入力
  (setq skk-kutouten-type 'en)
  ;; 改行のキーバインドが重複するので変更
  (setq skk-kakutei-key "\C-o")
  )
;; 句読点を動的に決定する
(add-hook 'skk-mode-hook
          (lambda ()
            (save-excursion
              (goto-char 0)
              (make-local-variable 'skk-kutouten-type)
              (if (re-search-forward "。" 10000 t)
                  (setq skk-kutouten-type 'en)
                (setq skk-kutouten-type 'jp)))))
