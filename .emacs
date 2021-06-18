(add-to-list 'load-path "~/.emacs.d/plugins/")

(require 'simpleclip)

(simpleclip-mode 1)



(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(package-initialize)

(load-theme 'gruvbox t)
