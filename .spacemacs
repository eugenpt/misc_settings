(defun dotspacemacs/user-config ()
  ;; ...
  ;; Set escape keybinding to "jk"
  (setq-default evil-escape-key-sequence "jk")
 )
(defun ep_test ())

(defun multiply-by-seven (number)
  "Multiply NUMBER by seven."
  (interactive)
  (message "number"))
(multiply-by-seven 3)


;; Translate C-h to DEL
(keyboard-translate ?\C-h ?\C-?)
;; Define M-h to help  ---  please don't add an extra ' after help!
(global-set-key "\M-h" 'help)

;; (define-key evil-insert-state-map "jj" 'evil-normal-state)
;; (define-key evil-insert-state-map "kk" 'evil-normal-state)
;; (define-key evil-insert-state-map "jk" 'evil-normal-state)
;; (define-key evil-insert-state-map "kj" 'evil-normal-state)

;; (define-key evil-insert-state-map "kj" 'evil-escape)
;; (define-key evil-insert-state-map "kk" 'evil-escape)
;; (define-key evil-insert-state-map "jj" 'evil-escape)
;; (define-key evil-insert-state-map "jk" 'evil-escape)

(define-key evil-normal-state-map "\C-?" 'evil-window-left)
(define-key evil-normal-state-map "\C-l" 'evil-window-right)
(add-hook 'git-commit-mode-hook 'evil-insert-state)

(defun doodlebug ()
  "Nonce function"
  (interactive)
  (message "Howdie-doodie fella"))

(spacemacs/set-leader-keys "C-h" 'delete-backward-char)
