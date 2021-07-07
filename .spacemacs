(defun dotspacemacs/user-config ()
  ;; ...
  ;; Set escape keybinding to "jk"
  (setq-default evil-escape-key-sequence "jk")
  (set-face-attribute 'default nil :height 130)
  
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

;; https://www.reddit.com/r/emacs/comments/5qkg3q/how_to_best_adapt_to_spacemacs_evil/dd2c4eb?utm_source=share&utm_medium=web2x&context=3
(define-key evil-normal-state-map "H" 'evil-beginning-of-line)
(define-key evil-normal-state-map "L" 'evil-end-of-line)

(defun doodlebug ()
  "Nonce function"
  (interactive)
  (message "Howdie-doodie fella"))

(spacemacs/set-leader-keys "C-h" 'delete-backward-char)


