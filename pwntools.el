(defun xah-random-string (&optional Ncount)
  "return a random string of length Ncount.
The possible chars are: 2 to 9, upcase or lowercase English alphabet but no a e i o u, no L l and no 0 1.
First char is always a letter

URL `http://xahlee.info/emacs/emacs/elisp_insert_random_number_string.html'
Created: 2024-04-03
Version: 2025-10-16"
  (let* ((xletters "BCDFGHJKMNPQRSTVWXYZbcdfghjkmnpqrstvwxyz")
         (xcharset (concat xletters "23456789"))
         (xlen (length xcharset))
         (xtotal-count (if Ncount Ncount 5))
         (xresult (make-list xtotal-count 0)))
    (setq xresult (mapcar (lambda (_) (aref xcharset (random xlen))) xresult))
    (setcar xresult (aref xletters (random (length xletters))))
    (concat xresult)))


(defun pwntools ()
  (interactive)
  (setq pwn-command (read-string "pwn command: "))
  (setq pwn-path  (replace-regexp-in-string "\n$"  " " (shell-command-to-string "which pwn")))
  (setq pwntools-buffer (generate-new-buffer "*pwntools*"))
  (if (string-match "--debug" pwn-command)
      (let ((new-pwn-command (concat (string-replace "--debug" "-f elf" pwn-command)))
	    (temp-obj (concat "pwn_" (xah-random-string 5))))
	(shell-command (concat  pwn-path new-pwn-command "> " temp-obj
				" && chmod 777 " temp-obj))
	(with-current-buffer pwntools-buffer
	  (insert (format "Temp program %s created. Debugging in gdb, remember to delete %s." temp-obj temp-obj)))
	(display-buffer pwntools-buffer)
	(gud-gdb (concat "gdb --fullname " (expand-file-name (concat default-directory temp-obj)))))
    ((lambda ()
       (shell-command (concat pwn-path pwn-command) pwntools-buffer)
       (display-buffer pwntools-buffer)
       (if (string-match "^asm" pwn-command)
	   (with-current-buffer pwntools-buffer
	     (if (fboundp 'nhexl-mode) (nhexl-mode) (hexl-mode))))
       ))))

(autoload 'pwntools "pwntools" "An emacs way of interacting with pwntools." t)
(provide 'pwntools)
