;; Ask before quitting
(setq confirm-kill-emacs #'yes-or-no-p)

;; Abbrev mode tests
(define-abbrev global-abbrev-table "blogi" "<div class=\"photo\"><a href=\"\">\n<img src=\"\"/></a>\n<p class=\"caption\"></p>\n</div>\n")
(define-abbrev global-abbrev-table "blogp" "<p class=\"regtext\">\n</p>\n")
(define-abbrev global-abbrev-table "blogd" "<p class=\"regtext\">\n<table class=\"regcontent\">\n<tr class=\"tableheader\"><td>From</td><td>To</td><td>Time</td><td>Notes</td></tr>\n<tr><td></td><td></td><td></td><td></td>\n</table>\n</p>\n\n<br/><br/><br/><hr/>\n<br/><p class=\"regtext\"><b>Day Two</b></p>
")
(setq-default abbrev-mode t)


