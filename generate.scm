#!/usr/local/bin/guile -s
!#

(define (dir-join . args)
  (if (null? (cdr args))
      (car args)
      (string-append (car args) file-name-separator-string (apply dir-join (cdr args)))))

(define (call-with-input-dir path proc)
  (let*
    ((dir (opendir path))
     (result (proc dir)))
    (closedir dir)
    result))

(define (dir->list dir)
  (let
    ((entry (readdir dir)))
    (if (eof-object? entry)
        '()
        (cons entry (dir->list dir)))))

(define (path->list path)
  (call-with-input-dir path dir->list))

(define (display-list xs)
  (for-each
    (lambda (x)
      (display x)
      (newline))
    xs))

(display-list (path->list (dir-join (dirname (current-filename)) "site")))
