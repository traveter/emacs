(require 'skk-autoloads)
(setq skk-large-jisyo "~/.emacs.d/dic/SKK-JISYO.L")

(global-set-key (kbd "C-x C-j") 'skk-mode)
(global-set-key (kbd "C-x j") 'skk-auto-fill-mode)
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