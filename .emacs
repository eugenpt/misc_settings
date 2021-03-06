(add-to-list 'load-path "~/.emacs.d/plugins/")

;; (require 'simpleclip)
;; (simpleclip-mode 1)

;; mkdir ~/.emacs.d/plugins
;; cd ~/.emacs.d/plugins
;; git clone git@github.com:rolandwalker/simpleclip.git
;; ln -s ./simpleclip/simpleclip.el ./
;; git clone git@github.com:technomancy/better-defaults.git
;; ln -s ./better-defaults/better-defaults.el ./



(require 'simpleclip) 
(require 'better-defaults)


(setq org-log-done 'time)

;; https://realpython.com/emacs-the-best-python-editor/

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))



;; installs packages
;;
;; mypackages contains a list of package names
(defvar myPackages
  '(better-defaults                 ;; set up some better emacs defaults
    elpy
    which-key
    ein
    telega
    flycheck
    py-autopep8                     ;; run autopep8 on save
    blacken                         ;; black formatting on save
    ssh-agency
    magit
    material-theme                  ;; theme
    company-irony
    web-mode
    evil
    )
  )

(eval-after-load 'company '(add-to-list 'company-backends 'company-irony))
;; scans the list in mypackages
;; if the package listed is not already installed, install it
;; (mapc (lambda (tp)
;;           (or (package-installed-p tp)
;;             (package-install tp)))
;;       mypackages)


  


(mapc   (lambda (x) (package-install x) ) myPackages)

(package-initialize)

(load-theme 'gruvbox-dark-soft t)

;; Translate C-h to DEL
(keyboard-translate ?\C-h ?\C-?)
;; Define M-h to help  ---  please don't add an extra ' after help!
(global-set-key "\M-h" 'help)


(global-linum-mode t)
(setq inhibit-startup-message t)


(elpy-enable)

;; Use IPython for REPL
; (setq python-shell-interpreter "jupyter"
;       python-shell-interpreter-args "console --simple-prompt"
;       python-shell-prompt-detect-failure-warning nil)
; (add-to-list 'python-shell-completion-native-disabled-interpreters
;              "jupyter")

;; Enable Flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))
;; Enable autopep8
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; https://github.com/osv/company-web
(require 'web-mode)
(require 'company)                                   ; load company mode
(require 'company-web-html)                          ; load company mode html backend
;; and/or
(require 'company-web-jade)                          ; load company mode jade backend
(require 'company-web-slim)                          ; load company mode slim backend

;; you may key bind, for example for web-mode:
(define-key web-mode-map (kbd "C-'") 'company-web-html)



;; (setq-default indent-tabs-mode nil)
;; (setq-default tab-width 2)
;; (setq indent-line-function 'insert-tab)



(require 'evil)
(evil-mode 0)
