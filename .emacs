(custom-set-variables
 '(inhibit-startup-screen t))
(custom-set-faces)

(invert-face 'default)
(setq-default fill-column 70)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode -1)
(setq-default word-wrap t)           ; no wrap word

(global-font-lock-mode 1)                    ; turn on syntax highlighting
(setq font-lock-maximum-decoration t)

;;; write in Unix format regardless of the platform on which i'm running
;(set-default buffer-file-coding-system 'utf-8-unix)
;(set-default-coding-systems 'utf-8-unix)
;(prefer-coding-system 'utf-8-unix)
;(set-default default-buffer-file-coding-system 'utf-8-unix)

(column-number-mode 1)                       ; Show column-number in the mode line
(setq x-select-enable-clipboard t)           ; Share the clipboard with X

(setq mouse-sel-retain-highlight t)          ; keep mouse high-lighted
(setq transient-mark-mode t)                 ; highlight the stuff you are marking

;(setq-default indicate-empty-lines t)        ; Show empty lines
(setq truncate-partial-width-windows nil)    ; Don't truncate long lines
(setq shell-file-name "/bin/bash")           ; Set Shell for M-| command
(setq ispell-dictionary "english")           ; Set ispell dictionary
(setq undo-limit 100000)                     ; Increase number of undo

(show-paren-mode 1)                            ; braces highlight
(blink-cursor-mode -1)                         ; cursor blink off
;(setq blink-matching-paren-distance nil)       ; Blinking parenthesis
;(setq show-paren-style 'expression)            ; Highlight text between parens

;(setq linum-format "%d ")


;;;;;;;;;;;;;;;;;; status ;;;;;;;;;;;;;;;;;;;;;
(set-face-attribute  'mode-line
                 nil 
                 :foreground "gray80"
                 :background "gray25" 
                 :box '(:line-width 1 :style released-button))
(set-face-attribute  'mode-line-inactive
                 nil 
                 :foreground "gray30"
                 :background "gray10"
                 :box '(:line-width 1 :style released-button))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(add-to-list 'load-path "~/.emacs.d/clojure-mode")
(require 'clojure-mode)

;(add-to-list 'load-path "~/.emacs.d/nrepl-client")
;(require 'nrepl-client)
;(add-to-list 'load-path "~/.emacs.d/nrepl.el")
;(require 'nrepl)
;(add-to-list 'load-path "~/.emacs.d/ac-nrepl")
;(require 'ac-nrepl)

;(global-auto-complete-mode)

(add-to-list 'load-path "~/.emacs.d/popup-el")
(require 'popup)
(add-to-list 'load-path "~/.emacs.d/auto-complete")
(require 'auto-complete-config)
(ac-config-default)


;; highlight TODO ...
(add-hook 'LaTeX-mode-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))

(add-hook 'c-mode-common-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))



(add-to-list 'load-path "~/.emacs.d/color-theme")
(require 'color-theme)
(color-theme-initialize)
(color-theme-charcoal-black)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)
(setq ido-enable-tramp-completion nil)
(setq ido-default-buffer-method 'selected-window)
(setq ido-default-file-method 'selected-window)
;(require 'ido)
;(ido-mode 'buffers) ;; only use this line to turn off ido for file names!
;(setq ido-ignore-buffers '("^ " "*Completions*" "*Shell Command Output*" "*Messages*" "Async Shell Command"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;(global-set-key (kbd "C-<tab>") 'next-buffer)
;(global-set-key (kbd "C-S-<tab>") 'previous-buffer)
;(global-set-key (kbd "<C-tab>") 'bury-buffer)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;ibuffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'ibuffer)
;  ;(autoload 'ibuffer "ibuffer" "" t)
(global-set-key (kbd "C-x C-b") 'ibuffer)
;  ;;never show emacs usual buffers
(setq ibuffer-never-show-predicates
      '("\\*scratch\\*"
	"\\*Messages\\*"
	"6667"))
;  ;(add-to-list 'ibuffer-never-show-regexps "^\\*")  ; Here�s how to hide all buffers starting with an asterisk.
(require 'ibuf-ext)                               ; It does not contain in emacs 23.2�s ibuffer.el, use following instead � coldnew
(add-to-list 'ibuffer-never-show-predicates "^\\*")


;(set-default-font "-misc-fixed-medium-r-semicondensed--13-120-75-75-c-60-iso8859-1")
;(set-default-font "Inconsolata 12")

;(set-default-font "-unknown-Inconsolata-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")

(setq
  inhibit-startup-screen              t
  inhibit-startup-message             t          ; don't show annoying startup msg
  initial-scratch-message             nil        ; no scratch message
  ;vc-follow-symlinks                 t          ; follow symlinks and don't ask
  echo-keystrokes                     0.01       ; see what you type
  ;scroll-conservatively              50         ; text scrolling
  ;scroll-preserve-screen-position    't
  ;scroll-margin                      10
  ;comint-completion-addsuffix        t          ; Insert space/slash after completion
  ;fill-column                        80         ; number of chars in line
  kill-whole-line                     t          ; delete line in one stage
  default-major-mode                  'text-mode ; default mode
;;;  delete-key-deletes-forward       t          ; meaning are the same as the name :)
  scroll-step                         1          ; Scroll by one line at a time
;;;lazy-lock-defer-on-scrolling        t          ; set this to make scrolling faster  --- TODO: check!
  next-line-add-newlines              nil        ; don't add new lines when scrolling down
  require-final-newline               t          ; make sure file ends with NEWLINE
  mouse-yank-at-point                 t          ; paste at cursor NOT at mouse pointer position
  ;apropos-do-all                     t          ; apropos works better but slower
  ;auto-save-interval                 512        ; autosave every 512 keyboard inputs
  ;kept-new-versions                  5          ; limit the number of newest versions
  ;kept-old-versions                  5          ; limit the number of oldest versions
  ;delete-old-versions                t          ; delete excess backup versions
  ;auto-save-list-file-prefix         "~/.emacs.d/backups/save-"
  make-backup-files                   nil        ; NO annoing backups
  auto-save-list-file-name            nil        ; Don't want any .saves files
  auto-save-default                   nil        ; Don't want any auto saving
  delete-auto-save-files              t          ; no "#" files after a save
  auto-save-list-file-prefix          nil        ; don't record sessions
  ;;;;  visible-bell                  t          ; don't beep   - when use this, the display is blinking :(, so use ring-bell-function...
  ring-bell-function                  'ignore    ; to turn the alarm totally off (http://www.emacswiki.org/emacs/AlarmBell)
;;;  cursor-in-non-selected-windows   nil
  ;dired-recursive-copies             t          ; dired settings
  ;dired-recursive-deletes            t
)

;; BINDKEY

(cua-mode t)                                     ; Cut/Paste with C-x/C-c/C-v
;(require 'redo)
;(global-set-key "\C-r" 'redo)
(global-set-key (kbd "C-z") 'undo)
(global-set-key "\C-g" 'goto-line)
;;;;(global-set-key (kbd "C-M-g") 'goto-line)
;;;;(global-set-key (kbd "C-x C-r") 'query-replace-regexp)
(global-set-key "\C-d" 'kill-line)
(global-set-key "\C-s" 'save-buffer)
(global-set-key "\C-q" 'kill-buffer-quite)
(global-set-key "\C-w" 'bookmark-jump)
(global-set-key "\C-e" 'bookmark-set)
(global-set-key "\C-f" 'isearch-forward)
(global-set-key (read-kbd-macro "ESC .") 'forward-word)
(global-set-key (read-kbd-macro "ESC ,") 'backward-word)
(define-key isearch-mode-map "\C-f" 'isearch-repeat-forward)
(define-key isearch-mode-map "\C-p" 'isearch-repeat-backward)
;(global-set-key (read-kbd-macro "ESC ") 'my-next-buffer)                  ; ENE 4 moroos bolood  M-q ajillahgui baisan baina. !!!!!!!!!!!!!!!!!!!!!!!!!!!
;(global-set-key (read-kbd-macro "ESC ") 'my-prev-buffer)
;(global-set-key (read-kbd-macro "ESC ") 'windmove-up)
;(global-set-key (read-kbd-macro "ESC ") 'windmove-down)
(global-set-key (read-kbd-macro "") 'switch-to-buffer)
(global-set-key (read-kbd-macro "") 'find-file)
(global-set-key (read-kbd-macro "") 'find-grep)
(global-set-key (read-kbd-macro "") 'tabbar-forward-group)
(global-set-key (read-kbd-macro "") 'comment-uncomment-line-or-region) ;; not my shity shit XXX
(global-set-key (read-kbd-macro "") 'toggle-truncate-lines)
(global-set-key (read-kbd-macro "") 'keyboard-escape-quit)
(global-set-key (read-kbd-macro "") 'save-buffers-kill-emacs)
(global-set-key [(control shift tab)] 'tabbar-backward)
(global-set-key [(control tab)]       'tabbar-forward)

