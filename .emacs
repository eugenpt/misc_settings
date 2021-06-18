(add-to-list 'load-path "~/.emacs.d/plugins/")

(require 'simpleclip)

(simpleclip-mode 1)

(setq org-log-done 'time)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(package-initialize)

(load-theme 'gruvbox t)

;; Translate C-h to DEL
(keyboard-translate ?\C-h ?\C-?)
;; Define M-h to help  ---  please don't add an extra ' after help!
(global-set-key "\M-h" 'help)
