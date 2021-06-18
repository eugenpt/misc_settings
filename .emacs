(add-to-list 'load-path "~/.emacs.d/plugins/")

(require 'simpleclip)

(require 'better-defaults)

(simpleclip-mode 1)

(setq org-log-done 'time)

;; https://realpython.com/emacs-the-best-python-editor/

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))



;; Installs packages
;;
;; myPackages contains a list of package names
(defvar myPackages
  '(better-defaults                 ;; Set up some better Emacs defaults
    elpy
    ein
    telega
    flycheck
    py-autopep8                     ;; Run autopep8 on save
    blacken                         ;; Black formatting on save
    ssh-agency
    magit
    material-theme                  ;; Theme
    )
  )

;; Scans the list in myPackages
;; If the package listed is not already installed, install it
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)


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
(setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
(add-to-list 'python-shell-completion-native-disabled-interpreters
             "jupyter")

;; Enable Flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))
;; Enable autopep8
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)


