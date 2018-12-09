#!/usr/local/bin/guile -s
!#

(define (dir-join . args)
  (if (null? (cdr args))
      (car args)
      (string-append (car args) file-name-separator-string (apply dir-join (cdr args)))))

(define (call-with-input-dir path proc)
  (let
    ((dir (opendir path)))
    (proc dir)
    (closedir dir)))

(call-with-input-dir
  (dir-join (dirname (current-filename)) "site")
  (lambda (dir)
    (do ((entry (readdir dir) (readdir dir)))
      ((eof-object? entry))
      (display entry)
      (newline))))
