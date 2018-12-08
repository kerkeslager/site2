#!/usr/local/bin/guile -s
!#

(display (current-filename))
(newline)

(define (call-with-input-dir path proc)
  (let
    ((dir (opendir path)))
    (proc dir)
    (closedir dir)))

(call-with-input-dir
  (dirname (current-filename))
  (lambda (dir)
    (do ((entry (readdir dir) (readdir dir)))
      ((eof-object? entry))
      (display entry)
      (newline))))
