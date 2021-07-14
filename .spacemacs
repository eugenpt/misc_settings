(defun dotspacemacs/user-config ()
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
;; (define-key evil-normal-state-map "\C-l" 'evil-window-right)
(add-hook 'git-commit-mode-hook 'evil-insert-state)

;; https://www.reddit.com/r/emacs/comments/5qkg3q/how_to_best_adapt_to_spacemacs_evil/dd2c4eb?utm_source=share&utm_medium=web2x&context=3
;; (define-key evil-normal-state-map "H" 'evil-beginning-of-line)
;; (define-key evil-normal-state-map "L" 'evil-end-of-line)

(defun doodlebug ()
  "Nonce function"
  (interactive)
  (message "Howdie-doodie fella"))

(spacemacs/set-leader-keys "C-h" 'delete-backward-char)


(setq org-directory "~/Dropbox/org/")

(add-hook 'org-capture-mode-hook 'evil-insert-state)
;; test
(setq org-capture-templates
      '(
        ("t" "Todo" entry (file+headline "~/Dropbox/org/gtd.org" "Tasks")
         "* TODO %?\n  %i\nEntered on %U\n  %i\n From: %a")
        ("j" "Journal" entry (file+datetree "~/Dropbox/org/journal.org")
         "* %?\nEntered on %U\n  %i\n From: %a")
        ("i" "Idea" entry (file+datetree "~/Dropbox/org/ideas.org")
         "* %?\nEntered on %U\n  %i\n From: %a")
        ("p" "Personal Journal" entry (file+datetree "~/Dropbox/org/pjournal.org")
         "* %?\nEntered on %U\n  %i\n From: %a")
        ("b" "list of things to buy" checkitem (file "~/Dropbox/org/tobuy.org")
         "[ ] %? (created %U)")
       )
)
;; (use-package org-brain :ensure t
;;   :init
;;   (setq org-brain-path "~/Dropbox/org/brain/")
;;   )

;; (use-package polymode
;;   :config
;;   (add-hook 'org-brain-visualize-mode-hook #'org-brain-polymode))




;; (add-to-list 'org-latex-classes '("apa6" "\\documentclass{apa6}" ))
;; org-latex-classes

  (setq-default evil-escape-key-sequence "jk")
  (set-face-attribute 'default nil :height 130)
  (with-eval-after-load 'org
    (setq org-agenda-files (directory-files-recursively "~/Dropbox/org/" "\\.org$"))
    (setq  org-odt-preferred-output-format "docx")
  )
  (with-eval-after-load 'org-ref
  (setq org-ref-default-bibliography '("~/Dropbox/org/Science/bibliography.bib")
        org-ref-bibliography-notes "~/Dropbox/Science/bibliography-notes.org")
        ;; For pdf export engines.
        org-latex-pdf-process (list "latexmk -pdflatex='%latex -shell-escape -interaction nonstopmode' -pdf -bibtex -f -output-directory=%o %f")
  ) 
  (with-eval-after-load 'ox-latex


    (add-to-list 'org-latex-classes
                 '("nature"
                   "\\documentclass{nature}"
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\paragraph{%s}" . "\\paragraph*{%s}")
                   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

    (add-to-list 'org-latex-classes
                 '("pnas2009"
                   "\\documentclass{pnas2009}"
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\paragraph{%s}" . "\\paragraph*{%s}")
                   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

    (add-to-list 'org-latex-classes
                    '("apa6"
                      "\\documentclass{apa6}"
                      ("\\section{%s}" . "\\section*{%s}")
                      ("\\subsection{%s}" . "\\subsection*{%s}")
                      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                      ("\\paragraph{%s}" . "\\paragraph*{%s}")
                      ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

 )

(display-line-numbers-mode t)

(display-line-numbers--turn-on)

(global-display-line-numbers-mode)

(global-display-line-numbers-mode)

(add-to-list 'desktop-locals-to-save 'evil-markers-alist)

(message "EP's config file loaded successfully.")
)
