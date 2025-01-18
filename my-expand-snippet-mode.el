;;; my-expand-snippet-mode.el --- Simple snippet expander on <space>, -*- lexical-binding: t -*-
;;; # -*- read-symbol-shorthands: (("mes-" . "my-expand-snippet-")) -*-

;;
;;; A simple minor-mode for automatically expanding snippets, expanded by a
;;; prefix , (comma), and then the snippet name. Expanded once the first space
;;; after the pattern is found.
;;
;;; Real handy for quickly expanding snippets you use a lot.
;;
;;
;;; - On only comma, call yas-insert-snippet -
;;
;;; TODO - When there is no math, raise an error ?

(defun mes--is-xpander-key-p  ()
  "Checks if the preceding word matches the expected <space>,<snippet><space> pattern"
  (interactive)
  (if (looking-back ",\\w+ " (point-at-bol))
      t
    nil))

;;; TODO - Not used as a sentinel rn
(defun mes--current-word-is-a-snippet-p ()
  "Checks if the current word in the pattern is a snippet"
  (interactive)
  (save-excursion
    (backward-char)
    (if (yas-lookup-snippet (word-at-point t))
        t
      nil)))

(defun mes--is-single-comma ()
  "Sentinel for the single comma pattern: <space><,><space>"
  (interactive)
  (looking-back " , "))

(defun mes-try-n-xpand-word ()
  "Expands the snippet if the previous text matches the pattern as
set out by mes--is-xpander-key-p, and the word is a yasnippet
snippet."
  (interactive)
  (cond ((and (derived-mode-p 'prog-mode)
              (mes--is-xpander-key-p)
              )
         (save-excursion
           (backward-char)     ;; Back to the beginning of the word
           (delete-char 1)     ;; Delete the prefix <space>
           (backward-word)     ;; Step back over the word itself
           (backward-char)     ;; Back to over the comma
           (delete-char 1)     ;; Delete the comma
           (forward-word))
         (evil-insert-state)       ;; Back over the space
         (yas-expand)
         )
        ((mes--is-single-comma)
         (delete-backward-char 3)
         (yas-insert-snippet)))) ;; Enter insert

;;;###autoload
(define-minor-mode my-expand-snippet-mode
  "If enabled, expands snippets automatically from Yasnippet if prefixed with comma"
  :lighter "XPand"
  :require 'yasnippet
  :global nil
  :version "1.0.0"
  (if my-expand-snippet-mode
      (progn
        ;; When enabling the minor mode
        (add-hook 'post-self-insert-hook 'mes-try-n-xpand-word)
        (message "My expand snippet mode enabled."))
    ;; When disabling the minor mode
    (remove-hook 'post-self-insert-hook 'mes-try-n-xpand-word)
    (message "My expand snippet mode disabled.")))

(provide 'my-expand-snippet-mode)

;; Local Variables:
;; read-symbol-shorthands: (("mes-" . "my-expand-snippet-"))
;; End:
