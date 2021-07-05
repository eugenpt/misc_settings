(defun dotspacemacs/user-config ()
  ;; ...
  ;; Set escape keybinding to "jk"
  (setq-default evil-escape-key-sequence "jk")
 )
(defun ep_test ())

(defun multiply-by-seven (number)
  "Multiply NUMBER by seven."
  (interactive "p")
  (message "number is %d" (* number 7))
  (* number 7)
)

(multiply-by-seven 3)

(message "This is a test message")
(message "This is buffer %s fill-column is %d" (buffer-name) fill-column)

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


(setq org-directory "~/Dropbox/org/")

(add-hook 'org-capture-mode-hook 'evil-insert-state)

(setq org-capture-templates
      '(
        ("t" "Todo" entry (file+headline "~/Dropbox/org/gtd.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree "~/Dropbox/org/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")
        ("i" "Idea" entry (file+datetree "~/Dropbox/org/ideas.org")
         "* %?\nEntered on %U\n  %i")
        ("p" "Personal Journal" entry (file+datetree "~/Dropbox/org/pjournal.org")
         "* %?\nEntered on %U\n  %i\n  %a")
       )
)

;; (use-package org-brain :ensure t
;;   :init
;;   (setq org-brain-path "~/Dropbox/org/brain/")
;;   )

(use-package polymode
  :config
  (add-hook 'org-brain-visualize-mode-hook #'org-brain-polymode))
