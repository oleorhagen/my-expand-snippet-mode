;;; my-expand-snippet-mode.el --- Simple snippet expander on <space>, -*- lexical-binding: t -*-
;;; -*- read-symbol-shorthands: (("mes-" . "my-expand-snippet-")) -*-

;;
;;; Simple unit tests for the mode
;;

(require 'ert)
(require 'my-expand-snippet-mode)


(ert-deftest test-mes--is-xpander-key-p ()
  "Tests that the xpander-key predicate functions as expected"
  (with-temp-buffer
    (insert "foobar")
    (should-not (my-expand-snippet--is-xpander-key-p))
    (insert " ,def ")
    (should (my-expand-snippet--is-xpander-key-p))))


(ert-deftest test-mes-current-word-is-a-snippet ()
  "Tests that the sentinel for whether a snippet exists works"
  (with-temp-buffer
    (emacs-lisp-mode)
    (insert "a") ;; The and template
    (should (my-expand-snippet--current-word-is-a-snippet-p))))


(ert-test-erts-file "my-expand-snippet-tests.erts")
