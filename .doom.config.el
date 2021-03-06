;;; .doom.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 EP
;;
;; Author: EP <https://github.com/ep>
;; Maintainer: EP <eugen.pt@gmail.com>
;; Created: July 15, 2021
;; Modified: July 15, 2021
;; Version: 0.0.1
;; Keywords: Symbol’s value as variable is void: finder-known-keywords
;; Homepage: https://github.com/ep/.doom
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:
;;;
;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "EP"
      user-mail-address "eugen.pt@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the

;; (setq doom-theme 'doom-one)
(setq doom-theme 'doom-gruvbox)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;; The doom way
(map! :ie "C-h" #'backward-delete-char-untabify)
(map! :after evil-org
        :map evil-org-mode-map
        :i "C-h" #'backward-delete-char-untabify)
(map! (:map (minibuffer-local-map
             minibuffer-local-ns-map
             minibuffer-local-completion-map
             minibuffer-local-must-match-map
             minibuffer-local-isearch-map
             read-expression-map)
        "C-h" #'backward-delete-char-untabify)

      (:after evil
        :map evil-ex-completion-map
        "C-h" #'backward-delete-char-untabify)

      ;; If you use :completion ivy
      (:after ivy
        :map ivy-minibuffer-map
        "C-h" #'backward-delete-char-untabify)

      ;; If you use :completion helm
      (:after helm
        :map helm-map
        "C-h" #'backward-delete-char-untabify))


;; ehm.. new capture tamplates.. ?


(after! org (
add-to-list 'org-capture-templates
        '("t" "Todo" entry (file+headline "~/Dropbox/org/gtd.org" "Tasks")
         "* TODO %?\n  %i\nEntered on %U\n  %i\n From: %a")
))
(after! org (
add-to-list 'org-capture-templates
'("j" "Journal" entry (file+datetree "~/Dropbox/org/journal.org")
         "* %?\nEntered on %U\n  %i\n From: %a")
))
(after! org (
add-to-list 'org-capture-templates
        '("i" "Idea" entry (file+datetree "~/Dropbox/org/ideas.org")
         "* %?\nEntered on %U\n  %i\n From: %a")
))
(after! org (
add-to-list 'org-capture-templates
        '("l" "Persona_l_ Journal" entry (file+datetree "~/Dropbox/org/journalp.org")
         "* %?\nEntered on %U\n  %i\n From: %a")
))
(after! org (
add-to-list 'org-capture-templates
        '("b" "list of things to buy" checkitem (file "~/Dropbox/org/tobuy.org")
         "[ ] %? (created %U)")
        ))

(setq default-input-method "russian-computer")

;;; .doom.el ends here
