;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FAUST Mode (very simple syntax colorizing!)
;; by rukano
;; based on the tutorial on:
;; http://xahlee.org/emacs/elisp_syntax_coloring.html
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; BIG TODOS:
;; Colorize Composition Operators
;; Colorize after keyword {}
;; Colorize arguments (numbers)
;; Colorize [] metadata in string?
;; Run Shell faust w/ custom defaults
;; *** Get rid of the No comment syntax defined warning


;; ROADMAP
;; export option and list possibilities
;; create hotkeys for every compilation
;; view graph

(defvar faust-keywords
  '("process" "with" "case" "seq" "par" "sum" "prod"
    "include" "import" "component" "library" "environment" "declare"
    "define" "undef" "error" "pragma" "ident"
    "if" "def" "else" "elif" "endif" "line" "warning")
  "FAUST keywords.")
 
(defvar faust-functions
  '("mem" "prefix" "int" "float"
    "rdtable" "rwtable" "select2" "select3"
    "ffunction" "fconstant" "fvariable"
    "attach" "acos" "asin" "atan" "atan2" "cos" "sin" "tan" "exp"
    "log" "log10" "pow" "sqrt" "abs" "min" "max" "fmod"
    "remainder" "floor" "ceil" "rint")
  "FAUST functions.")

;; TODO: composition operators!
;;(": , :> <: ~ ! _ @ ")
;;(defvar faust-operators "\\([]<>[~:,@!]\\)")
(defvar faust-operators "\\([(:\>)|(\<:)|~!_@,=]\\)")

(defvar faust-ui-keywords
  '("button" "checkbox" "vslider" "hslider" "nentry"
    "vgroup" "hgroup" "tgroup" "vbargraph" "hbargraph")
  "FAUST gui groups?.")

(defvar faust-math-op "\\([][{}()^.\\+*/%-]\\)")
;;(defvar faust-math-op "\\([][{}()~^<>:=,.\\+*/%-@!]\\)")

;; optimize regex for words
(defvar faust-keywords-regexp (regexp-opt faust-keywords 'words))
(defvar faust-function-regexp (regexp-opt faust-functions 'words))
(defvar faust-ui-keywords-regexp (regexp-opt faust-ui-keywords 'words))
(defvar faust-operator-regexp faust-operators)
(defvar faust-math-op-regexp faust-math-op)

;; clear memory
(setq faust-keywords nil)
(setq faust-functions nil)
(setq faust-operators nil)
(setq faust-ui-keywords nil)
(setq faust-math-op nil)

;; create the list for font-lock.
;; each class of keyword is given a particular face
(setq faust-font-lock-keywords
  `(
    (,faust-function-regexp . font-lock-type-face)
    (,faust-ui-keywords-regexp . font-lock-builtin-face)
    (,faust-math-op-regexp . font-lock-function-name-face)
    (,faust-operator-regexp . font-lock-constant-face)
    (,faust-keywords-regexp . font-lock-keyword-face)
    ;; note: order above matters. “faust-keywords-regexp” goes last because
    ;; otherwise the keyword “state” in the function “state_entry”
    ;; would be highlighted.
))


;; define the mode
(define-derived-mode faust-mode fundamental-mode
  "FAUST mode"
  "Major mode for editing FAUST files (Functional Audio Stream)…"

  ;; code for syntax highlighting
  (setq font-lock-defaults '((faust-font-lock-keywords)))
  
  ;; clear memory
  (setq faust-keywords-regexp nil)
  (setq faust-functions-regexp nil)
  (setq faust-operators-regexp nil)
  (setq faust-ui-keywords-regexp nil)
  (setq faust-math-op-regexp nil)
)

;; comment dwin support
(defun faust-comment-dwim (arg)
"Comment or uncomment current line or region in a smart way.
For detail, see `comment-dwim'."
   (interactive "*P")
   (require 'newcomment)
   (let ((deactivate-mark nil) (comment-start "//") (comment-end ""))
     (comment-dwim arg)))

(modify-syntax-entry ?\/ ". 12b" faust-mode-syntax-table)
(modify-syntax-entry ?\n "> b" faust-mode-syntax-table)

