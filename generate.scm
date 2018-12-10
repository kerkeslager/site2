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

(define (flatten xss)
  (if (null? xss)
      '()
      (append (car xss) (flatten (cdr xss)))))

(define (fs-find path)
  (cond ((equal? "." (basename path)) '())
        ((equal? ".." (basename path)) '())
        ((eq? (stat:type (stat path)) 'regular) (cons path '()))
        ((eq? (stat:type (stat path)) 'directory)
         (flatten (map (lambda (p) (fs-find (dir-join path p))) (path->list path))))))


(define (display-list xs)
  (for-each
    (lambda (x)
      (display x)
      (newline))
    xs))

(display-list (fs-find (dir-join (dirname (current-filename)) "site")))
