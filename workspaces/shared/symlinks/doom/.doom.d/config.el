;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Andy Rice"
      user-mail-address "andy@andydrice.com")

(setq auto-save-default t
      make-backup-files t)
(auto-save-visited-mode +1)

(map! :leader
      :desc "M-x"                   :n "SPC" #'counsel-M-x

      :desc "ivy resume" :n ":" #'ivy-resume
      :desc "Async shell command"   :n "!"   #'async-shell-command
      :desc "Toggle eshell"         :n "'"   #'+term/toggle
      :desc "Open dir in iTerm" :n "oi" #'+macos/open-in-iterm

      (:desc "windows" :prefix "w"
       :desc "popup raise" :n "p" #'+popup/raise)

      (:desc "project" :prefix "p"
       :desc "Eshell"               :n "'" #'projectile-run-eshell
       :desc "Terminal" :n "t" #'projectile-run-vterm ))

(setq doom-font (font-spec :family "Fira Code" :size 15 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Inconsolata Nerd Font" :size 15))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-vibrant)

(after! org (setq org-directory "~/Documents/org/"
             org-agenda-files '("~/Documents/org")
             org-default-notes-file "~/Documents/org/refile.org"
             ))

(after! org (setq org-agenda-span 'day
                  org-agenda-start-day "+0d"
                  org-agenda-compact-blocks t
                  org-agenda-include-diary t
                  org-agenda-use-time-grid t
                  org-agenda-dim-blocked-tasks nil
                  ))

(setq org-agenda-custom-commands
      (quote(
             ("h" "Habits" tags-todo "STYLE=\"habit\""
              ((org-agenda-overriding-header "Habits")
               (org-agenda-sorting-strategy
                '(todo-state-down effort-up category-keep))))
             (" " "Agenda"
              ((agenda "" nil)
               (tags-todo "weeklykpi"
                          ((org-agenda-overriding-header "Weekly KPIs")
                           (org-agenda-sorting-strategy
                            '(todo-state-down effort-up category-keep))
                           (org-tags-match-list-sublevels 'indented)))
               (tags "REFILE"
                     ((org-agenda-overriding-header "Tasks to Refile")
                      (org-tags-match-list-sublevels nil)))
               (tags-todo "manager"
                          ((org-agenda-overriding-header "Manager/Admin Tasks")
                           (org-tags-match-list-sublevels 'indented)))
               (tags-todo "errands"
                          ((org-agenda-overriding-header "Errands")
                           (org-tags-match-list-sublevels 'indented)))
               (tags-todo "chores"
                          ((org-agenda-overriding-header "Chores")
                           (org-tags-match-list-sublevels 'indented)))
               (tags "-REFILE/"
                     ((org-agenda-overriding-header "Tasks to Archive")
                      (org-agenda-skip-function 'ar/skip-non-archivable-tasks)
                      (org-tags-match-list-sublevels nil))))
              nil))))

(setq org-refile-use-outline-path 'file)
;; (setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps nil)
;; (setq org-completion-use-ido nil)
;; ;; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes 'confirm)
(setq org-refile-targets '((org-agenda-files :maxlevel . 9)))

(setq org-archive-mark-done nil)
(setq org-archive-location "%s_archive::* Archive")

(defun ar/skip-non-archivable-tasks ()
    "Skip trees that are not available for archiving"
    (save-restriction
      (widen)
      ;; Consider only tasks with done todo headings as archivable candidates
      (let ((next-headline (save-excursion (or (outline-next-heading) (point-max))))
            (subtree-end (save-excursion (org-end-of-subtree t))))
        (if (member (org-get-todo-state) org-todo-keywords-1)
            (if (member (org-get-todo-state) org-done-keywords)
                (let* ((daynr (string-to-number (format-time-string "%d" (current-time))))
                       (a-month-ago (* 60 60 24 (+ daynr 1)))
                       (last-month (format-time-string "%Y-%m-" (time-subtract (current-time) (seconds-to-time a-month-ago))))
                       (this-month (format-time-string "%Y-%m-" (current-time)))
                       (subtree-is-current (save-excursion
                                             (forward-line 1)
                                             (and (< (point) subtree-end)
                                                  (re-search-forward (concat last-month "\\|" this-month) subtree-end t)))))
                  (if subtree-is-current
                      subtree-end ; Has a date in this month or last month, skip it
                    nil))  ; available to archive
              (or subtree-end (point-max)))
          next-headline))))

(after! org
  (setq org-todo-keyword-faces
          '(("TODO" . "SlateGray")
            ("BLOCKED" . "Firebrick")
            ("DONE" . "ForestGreen")
            ("DEFERRED" .  "SlateBlue")))
  (setq org-todo-keywords
          '((sequence "TODO" "BLOCKED(b@/!)" "DEFERRED(e@/!)" "CANCELLED(c!/!)" "|" "DONE(d!/!)")
            (sequence "OUTCOME" "|" "DONE(d!/!)" "CANCELLED(c!/!)"))))

(after! org
  (setq org-capture-templates
        (quote (("t" "todo" entry (file "~/Documents/org/refile.org")
                 "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
                ("r" "respond" entry (file "~/Documents/org/refile.org")
                 "* TODO Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
                ("j" "Journal" entry (file+datetree "~/Documents/org/journal/misc.org")
                 "* %?\n%U\n" :clock-in t :clock-resume t)
                ("m" "Meeting" entry (file "~/Documents/org/refile.org")
                 "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
                ("p" "Phone call" entry (file "~/Documents/org/refile.org")
                 "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
                ("d" "Daily Review" entry (file "~/Documents/org/refile.org")
                 (file "~/.spacemacs.d/org-templates/daily.orgtmpl") :clock-in t :clock-resume t)
                ("w" "Weekly Review" entry (file "~/Documents/org/refile.org")
                 (file "~/.spacemacs.d/org-templates/weekly.orgtmpl") :clock-in t :clock-resume t)
                ("h" "Habit" entry (file "~/Documents/org/refile.org")
                 "* TODO %?\nSCHEDULED: <%<%Y-%m-%d %a> .+1d/3d>\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: TODO\n:END:\n")
                ))
        ))

(after! org
  (org-clock-persistence-insinuate)
  (setq org-clock-mode-line-total 'current
        org-clock-persist t
        org-clock-in-resume t
        org-clock-out-remove-zero-time-clocks t
        org-log-into-drawer t
        org-clock-into-drawer t
        org-clock-idle-time 15
        org-clock-auto-resolution 'when-no-clock-is-running
        ))

(setq projectile-project-search-path '("~/Projects/"))

(evil-global-set-key 'normal "/" 'swiper)

(setq-hook! 'typescript-mode-hook +format-with-lsp nil)
(setq-hook! 'typescript-mode-hook flycheck-checker 'javascript-eslint)
(setq-hook! 'js2-mode-hook +format-with-lsp nil)
(setq-hook! 'js2-mode-hook flycheck-checker 'javascript-eslint)

;; (use-package! poetry
;;   :hook (python-mode . poetry-tracking-mode))
(use-package! poetry
  :hook (python-mode . (lambda () (when (poetry-venv-exist-p)
                                    (setq-local lsp-mspyls-server-command '("poetry" "run" "mspyls"))
                                    (poetry-venv-workon)))))

(after! lsp-python-ms
  (set-lsp-priority! 'pyright 1))

(after! lsp-mode
  (setq lsp-diagnostic-package :none))

(after! flycheck
  (add-hook 'pyhon-mode-local-vars-hook
            (lambda ()
              (when (flycheck-may-enable-checker 'python-flake8)
                (flycheck-select-checker 'python-flake8)))))

(after! python-pytest
  (setq python-pytest-arguments '("--color" "--failed-first"))
  (evil-set-initial-state 'python-pytest-mode 'normal))

(set-popup-rule! "^\\*pytest*" :side 'right :size .50)

(after! dap-mode
  ;; (setq dap-auto-show-output t)
  (setq dap-output-window-max-height 50)
  (setq dap-output-window-min-height 50)
  (setq dap-auto-configure-features '(locals))

  (setq dap-ui-buffer-configurations
        `((,"*dap-ui-locals*"  . ((side . right) (slot . 1) (window-width . 0.50))) ;; changed this to 0.50
          (,"*dap-ui-repl*" . ((side . right) (slot . 1) (window-width . 0.50))) ;; added this! TODO enable when release on MELPA
          (,"*dap-ui-expressions*" . ((side . right) (slot . 2) (window-width . 0.20)))
          (,"*dap-ui-sessions*" . ((side . right) (slot . 3) (window-width . 0.20)))
          (,"*dap-ui-breakpoints*" . ((side . left) (slot . 2) (window-width . , 0.20)))
          (,"*debug-window*" . ((side . bottom) (slot . 3) (window-width . 0.20)))))

  ;; (set-popup-rule! "^\\*dap-debug-script*" :side 'bottom :size .30)


  (defun my/window-visible (b-name)
    "Return whether B-NAME is visible."
    (-> (-compose 'buffer-name 'window-buffer)
        (-map (window-list))
        (-contains? b-name)))

  (defun my/show-debug-windows (session)
    "Show debug windows."
    (let ((lsp--cur-workspace (dap--debug-session-workspace session)))
      (save-excursion
        (unless (my/window-visible dap-ui--repl-buffer)
          (dap-ui-repl)))))

  (add-hook 'dap-stopped-hook 'my/show-debug-windows)

  (defun my/hide-debug-windows (session)
    "Hide debug windows when all debug sessions are dead."
    (unless (-filter 'dap--session-running (dap--get-sessions))
      (and (get-buffer dap-ui--repl-buffer)
           (kill-buffer dap-ui--repl-buffer)
           (get-buffer dap-ui--debug-window-buffer)
           (kill-buffer dap-ui--debug-window-buffer))))

  (add-hook 'dap-terminated-hook 'my/hide-debug-windows)

  )

(after! dap-python
  (dap-register-debug-template "dap-debug-script"
                               (list :type "python"
                                     :args []
                                     :cwd "${workspaceFolder}"
                                     ;; :cwd (lsp-workspace-root)
                                     ;; :justMyCode :json-false
                                     ;; :debugOptions ["DebugStdLib" "ShowReturnValue" "RedirectOutput"]
                                     ;; :program nil ; (expand-file-name "~/git/blabla")
                                     :request "launch"
                                     ;; :debugger 'ptvsd
                                     :debugger 'debugpy
                                     :name "dap-debug-script"))

  (dap-register-debug-template "dap-debug-test-at-point"
                               (list :type "python-test-at-point"
                                     :args ""
                                     :justMyCode :json-false
                                     ;; :cwd "${workspaceFolder}"
                                     :request "launch"
                                     :module "pytest"
                                     :debugger 'debugpy
                                     :name "dap-debug-test-at-point"))

  ;; ("Python :: Run pytest (at point)" :type "python-test-at-point" :args "" :program nil :module "pytest" :request "launch" :name "Python :: Run pytest (at point)")

  ;; (dap-register-debug-template "Python :: Run pytest (at point), ptvsd"
  ;;                              (list :type "python-test-at-point"
  ;;                                    :args ""
  ;;                                    :module "pytest"
  ;;                                    :request "launch"
  ;;                                    :debugger 'ptvsd
  ;;                                    :name "Python :: Run pytest (at point)"))

  ;; (dap-register-debug-template "Python :: Run pytest (at point), debugpy"
  ;;                              (list :type "python-test-at-point"
  ;;                                    :args ["/Users/luca/git/wondercast/caf/test/customer_allocation/summarize_historical/summarize_historical_test.py::test_summarize"]
  ;;                                    ;; :module "pytest"
  ;;                                    :request "launch"
  ;;                                    :debugger 'debugpy
  ;;                                    :name "Python :: Run pytest (at point)"))

  )

(defadvice! +dap-python-poetry-executable-find-a (orig-fn &rest args)
  "Use the Python binary from the current virtual environment."
  :around #'dap-python--pyenv-executable-find
  (if (getenv "VIRTUAL_ENV")
      (executable-find (car args))
    (apply orig-fn args)))
;; (after! dap-python
;;   (defun dap-python--pyenv-executable-find (command)
;;     (concat (getenv "VIRTUAL_ENV") "/bin/python")))

(map! :localleader
      :map +dap-running-session-mode-map
      "d" nil)

;; (map! :after dap-mode
;;     :map dap-mode-map
;;     :localleader "d" nil)

(map! :after dap-mode
    :map python-mode-map
    :localleader
    ;; "d" nil
    (:desc "debug" :prefix "d"
      :desc "Hydra" :n "h" #'dap-hydra
      :desc "Run debug configuration" :n "d" #'dap-debug
      :desc "dap-ui REPL" :n "r" #'dap-ui-repl
      ;; :desc "Debug test function" :n "t" #'dap-python-debug-test-at-point  # TODO
      :desc "Run last debug configuration" :n "l" #'dap-debug-last
      :desc "Toggle breakpoint" :n "b" #'dap-breakpoint-toggle
      :desc "dap continue" :n "c" #'dap-continue
      :desc "dap next" :n "n" #'dap-next
      :desc "Debug script" :n "s" #'dap-python-script
      :desc "dap step in" :n "i" #'dap-step-in
      :desc "dap eval at point" :n "e" #'dap-eval-thing-at-point
      :desc "Disconnect" :n "q" #'dap-disconnect ))

(after! dap-mode
  (setq dap-python-debugger 'debugpy))

;; (after! harvest
;;   (add-hook 'org-clock-in-hook 'harvest)
;;   (add-hook 'org-clock-out-hook 'harvest-clock-out))
